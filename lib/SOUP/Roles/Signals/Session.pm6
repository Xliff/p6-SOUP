use v6.c;

use NativeCall;

use SOUP::Raw::Types;

use GLib::Roles::Signals::Generic;

role SOUP::Roles::Signals::Session {
  also does GLib::Roles::Signals::Generic;

  has %!signals-s;

  # SoupSession, SoupMessage, SoupAuth, gboolean, gpointer
  method connect-authenticate (
    $obj,
    $signal = 'authenticate',
    &handler?
  ) {
    my $hid;
    %!signals-s{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-authenticate($obj, $signal,
        -> $, $sm, $sa, $g, $ud {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $sm, $sa, $g, $ud ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-s{$signal}[0].tap(&handler) with &handler;
    %!signals-s{$signal}[0];
  }

  # SoupSession, SoupMessage, gpointer
  method connect-request-queue (
    $obj,
    $signal,
    &handler?
  ) {
    my $hid;
    %!signals-s{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-request-queue($obj, $signal,
        -> $, $sm, $ud {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $sm, $ud ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-s{$signal}[0].tap(&handler) with &handler;
    %!signals-s{$signal}[0];
  }

  # SoupSession, SoupMessage, SoupSocket, gpointer
  method connect-request-started (
    $obj,
    $signal = 'request-started',
    &handler?
  ) {
    my $hid;
    %!signals-s{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-request-started($obj, $signal,
        -> $, $sm, $ss, $ud {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $sm, $ss, $ud ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-s{$signal}[0].tap(&handler) with &handler;
    %!signals-s{$signal}[0];
  }

}

# SoupSession, SoupMessage, SoupAuth, gboolean, gpointer
sub g-connect-authenticate(
  Pointer $app,
  Str $name,
  &handler (Pointer, SoupMessage, SoupAuth, gboolean, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

# SoupSession, SoupMessage, gpointer
sub g-connect-request-queue(
  Pointer $app,
  Str $name,
  &handler (Pointer, SoupMessage, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

# SoupSession, SoupMessage, SoupSocket, gpointer
sub g-connect-request-started(
  Pointer $app,
  Str $name,
  &handler (Pointer, SoupMessage, SoupSocket, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }
