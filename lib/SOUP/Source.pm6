use v6.c;

use Method::Also;

use SOUP::Raw::Types;
use SOUP::Raw::Misc;

use GLib::Source;

use GLib::Roles::StaticClass;

class SOUP::Source {
  also does GLib::Roles::StaticClass;

  method completion (
    GMainContext() $async_context,
                   &function,
    gpointer       $data = gpointer,
                   :$raw = False
  ) {
    my $s = soup_add_completion($async_context, &function, $data);

    $s ??
      ( $raw ?? $s !! GLib::Source.new($s, :!ref) )
      !!
      Nil;
  }

  method idle (
    GMainContext() $async_context,
                   &function,
    gpointer       $data = gpointer,
                   :$raw = False
  ) {
    my $s = soup_add_idle($async_context, &function, $data);

    $s ??
      ( $raw ?? $s !! GLib::Source.new($s, :!ref) )
      !!
      Nil;
  }

  method io_watch (
    GMainContext() $async_context,
    GIOChannel()   $chan,
    Int()          $condition,
                   &function,
    gpointer       $data = gpointer,
                   :$raw = False
  )
    is also<io-watch>
  {
    my GIOCondition $c = $condition,
    my $s = soup_add_io_watch($async_context, $chan, $c, &function, $data);

    $s ??
      ( $raw ?? $s !! GLib::Source.new($s, :!ref) )
      !!
      Nil;
  }

  method timeout (
    GMainContext() $async_context,
    Int()          $interval,
                   &function,
    gpointer       $data = gpointer,
                   :$raw = False
  ) {
    my guint $i = $interval;
    my $s = soup_add_timeout($async_context, $i, &function, $data);

    $s ??
      ( $raw ?? $s !! GLib::Source.new($s, :!ref) )
      !!
      Nil;
  }

}
