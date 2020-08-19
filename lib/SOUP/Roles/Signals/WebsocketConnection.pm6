use v6.c;

use NativeCall;

use SOUP::Raw::Types;

use GLib::Roles::Signals::Generic;

role SOUP::Roles::Signals::WebsocketConnection {
  also does GLib::Roles::Signals::Generic;

  has %!signals-wsc;

  # SoupWebsocketConnection, gint, GBytes, gpointer
  method connect-message (
    $obj,
    $signal = 'message',
    &handler?
  ) {
    my $hid;
    %!signals-wsc{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-message($obj, $signal,
        -> $, $g, $b, $ud {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $g, $b, $ud ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-wsc{$signal}[0].tap(&handler) with &handler;
    %!signals-wsc{$signal}[0];
  }

  # SoupWebsocketConnection, GBytes, gpointer
  method connect-pong (
    $obj,
    $signal = 'pong',
    &handler?
  ) {
    my $hid;
    %!signals-wsc{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-pong($obj, $signal,
        -> $, $g, $ud {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $g, $ud ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-wsc{$signal}[0].tap(&handler) with &handler;
    %!signals-wsc{$signal}[0];
  }

}


# SoupWebsocketConnection, gint, GBytes, gpointer
sub g-connect-message(
  Pointer $app,
  Str $name,
  &handler (Pointer, gint, GBytes, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

# SoupWebsocketConnection, GBytes, gpointer
sub g-connect-pong(
  Pointer $app,
  Str $name,
  &handler (Pointer, GBytes, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }
