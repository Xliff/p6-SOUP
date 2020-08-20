use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use SOUP::Raw::Definitions;

role SOUP::Roles::Signals::Server {
  has %!signals-ss;

  # SoupServer, SoupMessage, SoupClientContext, gpointer
  method connect-message-client (
    $obj,
    $signal,
    &handler?
  ) {
    my $hid;
    %!signals-ss{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-message-client($obj, $signal,
        -> $, $sm, $scc, $ud {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $sm, $scc, $ud ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-ss{$signal}[0].tap(&handler) with &handler;
    %!signals-ss{$signal}[0];
  }

}

# SoupServer, SoupMessage, SoupClientContext, gpointer
sub g-connect-message-client(
  Pointer $app,
  Str $name,
  &handler (Pointer, SoupMessage, SoupClientContext, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }
