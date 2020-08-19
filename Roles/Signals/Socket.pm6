use v6.c;

role SOUP::Roles::Signals::Socket {
  %!signals-sock;

  # SoupSocket, GSocketClientEvent, GIOStream, gpointer
  method connect-event (
    $obj,
    $signal = 'event',
    &handler?
  ) {
    my $hid;
    %!signals-sock{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-event($obj, $signal,
        -> $, $ce, $i, $ud {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $ce, $i, $ud ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-sock{$signal}[0].tap(&handler) with &handler;
    %!signals-sock{$signal}[0];
  }

  # SoupSocket, SoupSocket, gpointer
  method connect-socket (
    $obj,
    $signal,
    &handler?
  ) {
    my $hid;
    %!signals-sock{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-socket($obj, $signal,
        -> $, $ss, $ud {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $ss, $ud ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-sock{$signal}[0].tap(&handler) with &handler;
    %!signals-sock{$signal}[0];
  }
}

# SoupSocket, GSocketClientEvent, GIOStream, gpointer
sub g-connect-event(
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

# SoupSocket, SoupSocket, gpointer
sub g-connect-socket(
  Pointer $app,
  Str $name,
  &handler (Pointer, SoupSocket, Pointer),
  Pointer $data,
  uint32 $flags
)
returns uint64
is native(gobject)
is symbol('g_signal_connect_object')
{ * }
