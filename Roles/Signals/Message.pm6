use v6.c;

use NativeCall;

use SOUP::Raw::Types;

role SOUP::Roles::Signals::Message {
  has %!signals-m;

  # SoupMessage, gchar, GHashTable, gpointer
  method connect-content-sniffed (
    $obj,
    $signal = 'content-sniffed',
    &handler?
  ) {
    my $hid;
    %!signal-m{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-content-sniffed($obj, $signal,
        -> $, $g, $, $ud {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $g, $, $ud ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signal-m{$signal}[0].tap(&handler) with &handler;
    %!signal-m{$signal}[0];
  }

  # SoupMessage, SoupBuffer, gpointer
  method connect-got-chunk (
    $obj,
    $signal = 'got-chunk',
    &handler?
  ) {
    my $hid;
    %!signal-m{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-got-chunk($obj, $signal,
        -> $, $sb, $ud {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $sb, $ud ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signal-m{$signal}[0].tap(&handler) with &handler;
    %!signal-m{$signal}[0];
  }

  # SoupMessage, GSocketClientEvent, GIOStream, gpointer
  method connect-network-event (
    $obj,
    $signal = 'network-event',
    &handler?
  ) {
    my $hid;
    %!signal-m{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-network-event($obj, $signal,
        -> $, $gsce, $gis, $ud {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $gsce, $gis, $ud ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signal-m{$signal}[0].tap(&handler) with &handler;
    %!signal-m{$signal}[0];
  }

  # SoupMessage, SoupBuffer, gpointer
  method connect-wrote-body-data (
    $obj,
    $signal = 'wrote-body-data',
    &handler?
  ) {
    my $hid;
    %!signal-m{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-wrote-body-data($obj, $signal,
        -> $, $sb, $ud {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $sb, $ud ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signal-m{$signal}[0].tap(&handler) with &handler;
    %!signal-m{$signal}[0];
  }

}

# SoupMessage, gchar, GHashTable, gpointer
sub g-connect-content-sniffed(
  Pointer $app,
  Str $name,
  &handler (Pointer, Str, GHashTable, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

# SoupMessage, SoupBuffer, gpointer
sub g-connect-got-chunk(
  Pointer $app,
  Str $name,
  &handler (Pointer, SoupBuffer, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

# SoupMessage, GSocketClientEvent, GIOStream, gpointer
sub g-connect-network-event(
  Pointer $app,
  Str $name,
  &handler (Pointer, GSocketClientEvent, GIOStream, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

# SoupMessage, SoupBuffer, gpointer
sub g-connect-wrote-body-data(
  Pointer $app,
  Str $name,
  &handler (Pointer, SoupBuffer, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }
