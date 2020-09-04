use v6.c;

use Method::Also;

use SOUP::Raw::Types;
use SOUP::Raw::Logger;

use GLib::Roles::Object;
use SOUP::Roles::SessionFeature;

our subset SoupLoggerAncestry is export of Mu
  where SoupLogger | SoupSessionFeature | GObject;

class SOUP::Logger {
  also does GLib::Roles::Object;
  also does SOUP::Roles::SessionFeature;

  has SoupLogger $!sl;

  submethod BUILD (:$logger) {
    self.setSoupLogger($logger) if $logger;
  }

  method setSoupLogger (SoupLoggerAncestry $_) {
    my $to-parent;

    $!sl = do {
      when SoupLogger {
        $to-parent = cast(GObject, $_);
        $_;
      }

      when SoupSessionFeature {
        $to-parent = cast(GObject, $_);
        $!sf = $_;
        cast(SoupLogger, $_);
      }

      default {
        $to-parent = $_;
        cast(SoupLogger, $_);
      }
    }
    self!setObject($to-parent);
    self.roleInit-SoupSessionFeature unless $!sf;
  }

  method SOUP::Raw::Definitions::SoupLogger
    is also<SoupLogger>
  { $!sl }

  multi method new (SoupLoggerAncestry $logger) {
    $logger ?? self.bless( :$logger ) !! Nil;
  }
  multi method new (SoupLoggerLogLevel $level, gint $max_body_size) {
    my SoupLoggerLogLevel $l = $level;
    my gint $m = $max_body_size;
    my $logger = soup_logger_new($l, $m);

    $logger ?? self.bless( :$logger ) !! Nil;
  }

  method attach (SoupSession() $session) {
    soup_logger_attach($!sl, $session);
  }

  method detach (SoupSession() $session) {
    soup_logger_detach($!sl, $session);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_logger_get_type, $n, $t );
  }

  method set_printer (
    &printer,
    gpointer $printer_data  = gpointer,
    GDestroyNotify $destroy = gpointer
  )
    is also<set-printer>
  {
    soup_logger_set_printer($!sl, &printer, $printer_data, $destroy);
  }

  method set_request_filter (
    &request_filter,
    gpointer $filter_data  = gpointer,
    GDestroyNotify $destroy = gpointer
  )
    is also<set-request-filter>
  {
    soup_logger_set_request_filter(
      $!sl,
      &request_filter,
      $filter_data,
      $destroy
    );
  }

  method set_response_filter (
    &response_filter,
    gpointer $filter_data  = gpointer,
    GDestroyNotify $destroy = gpointer
  )
    is also<set-response-filter>
  {
    soup_logger_set_response_filter(
      $!sl,
      &response_filter,
      $filter_data,
      $destroy
    );
  }

}
