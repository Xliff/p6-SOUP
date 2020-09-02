use v6.c;

use NativeCall;

use SOUP::Raw::Types;

role SOUP::Roles::Signals::CookieJar {
  has %!signals-cj;

  # SoupCookieJar, SoupCookie, SoupCookie, gpointer
  method connect-changed (
    $obj,
    $signal = 'changed',
    &handler?
  ) {
    my $hid;
    %!signals-cj{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-changed($obj, $signal,
        -> $, $sc1, $sc2, $ud {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $sc1, $sc2, $ud ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-cj{$signal}[0].tap(&handler) with &handler;
    %!signals-cj{$signal}[0];
  }

}

# SoupCookieJar, SoupCookie, SoupCookie, gpointer
sub g-connect-changed(
  Pointer $app,
  Str $name,
  &handler (Pointer, SoupCookie, SoupCookie, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }
