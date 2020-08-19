use v6.c;

use SOUP::Raw::Types;
use SOUP::Raw::WebsocketConnection;

use GIO::Stream;

use GLib::Roles::Object;
use SOUP::Roles::Signals::WebsocketConnection;

our subset SoupWebsocketConnectionAncestry is export of Mu
  where SoupWebsocketConnection | GObject;

class SOUP::WebsocketConnection {
  also does GLib::Roles::Object;
  also does SOUP::Roles::Signals::WebsocketConnection;

  has SoupWebsocketConnection $!swc is implementor;

  submethod BUILD (:$websocket) {
    self.setSoupWebsocketConnection($websocket) if $websocket;
  }

  method setSoupoWebsocketConnection (SoupWebsocketConnectionAncestry $_) {
    my $to-parent;

    $!swc = do {
      when SoupWebsocketConnection {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(SoupWebsocketConnection, $_);
      }
    }
    self!setObject($to-parent);
  }

  method SOUP::Raw::Definitions::SoupWebsocketConnection
  { $!swc }

  multi method new (SoupWebsocketConnectionAncestry $websocket) {
    $websocket ?? self.bless( :$websocket ) !! Nil;
  }
  multi method new (
    SoupURI() $uri,
    Int() $type,
    Str() $origin,
    Str() $protocol
  ) {
    my SoupWebsocketConnectionType $t = $type,
    my $websocket = soup_websocket_connection_new(
      $uri,
      $t,
      $origin,
      $protocol
    );

    $websocket ?? self.bless( :$websocket ) !! Nil;
  }

  method new_with_extensions (
    GIOStream() $stream,
    SoupURI() $uri,
    SoupWebsocketConnectionType $type,
    Str() $origin,
    Str() $protocol,
    GList() $extensions
  ) {
    my SoupWebsocketConnectionType $t = $type;
    my $websocket = soup_websocket_connection_new_with_extensions(
      $stream,
      $uri,
      $t,
      $origin,
      $protocol,
      $extensions
    );

    $websocket ?? self.bless( :$websocket ) !! Nil;
  }

  method connection-type is rw {
    Proxy.new:
      FETCH => -> $    { self.get_connection_type },

      STORE => -> $, $ {
        warn '.connection-type is a construct-only-writeable parameter!'
      };
  }

  method io-stream (:$raw = False) is rw {
    Proxy.new:
      FETCH => -> $    { self.get_io_stream(:$raw) },

      STORE => -> $, $ {
        warn '.io-stream is a construct-only-writeable parameter!'
      };
  }

  method keepalive-interval is rw {
    Proxy.new:
      FETCH => -> $         { self.get_keepalive_interval },
      STORE => -> $, Int \i { self.set_keepalive_interval(i) };
  }

  method max-incoming-payload-size is rw {
    Proxy.new:
      FETCH => -> $         { self.get_max_incoming_payload_size    },
      STORE => -> $, Int \i { self.set_max_incoming_payload_size(i) };
  }

  method origin is rw {
    Proxy.new:
      FETCH => -> $    { self.get_origin },

      STORE => -> $, $ {
        warn '.origin is a construct-only-writeable parameter!'
      };
  }

  method protocol is rw {
    Proxy.new:
      FETCH => -> $    { self.get_protocol },

      STORE => -> $, $ {
        warn '.protocol is a construct-only-writeable parameter!'
      };
  }

  method state is rw {
    Proxy.new:
      FETCH => -> $    { self.get_state },

      STORE => -> $, $ {
        warn '.state is not a writeable attribute!'
      };
  }

  method uri is rw {
    Proxy.new:
      FETCH => -> $    { self.get_uri },

      STORE => -> $, $ {
        warn '.uri is not a writeable attribute!'
      };
  }

  # Is originally:
  # SoupWebsocketConnection, gpointer --> void
  method closed {
    self.connect($!swc, 'closed');
  }

  # Is originally:
  # SoupWebsocketConnection, gpointer --> void
  method closing {
    self.connect($!swc, 'closing');
  }

  # Is originally:
  # SoupWebsocketConnection, GError, gpointer --> void
  method error {
    self.connect-error($!swc, 'error');
  }

  # Is originally:
  # SoupWebsocketConnection, gint, GBytes, gpointer --> void
  method message {
    self.connect-message($!swc);
  }

  # Is originally:
  # SoupWebsocketConnection, GBytes, gpointer --> void
  method pong {
    self.connect-pong($!swc);
  }

  method close (Int() $code, Str() $data) {
    my gushort $c = $code;

    soup_websocket_connection_close($!swc, $c, $data);
  }

  method get_close_code {
    soup_websocket_connection_get_close_code($!swc);
  }

  method get_close_data {
    soup_websocket_connection_get_close_data($!swc);
  }

  method get_connection_type {
    SoupWebsocketConnectionTypeEnum(
      soup_websocket_connection_get_connection_type($!swc)
    );
  }

  method get_extensions {
    soup_websocket_connection_get_extensions($!swc);
  }

  method get_io_stream (:$raw = False) {
    my $ios = soup_websocket_connection_get_io_stream($!swc);

    $ios ??
      ( $raw ?? $ios !! GIO::Stream.new($ios) )
      !!
      Nil;
  }

  method get_keepalive_interval {
    soup_websocket_connection_get_keepalive_interval($!swc);
  }

  method get_max_incoming_payload_size {
    soup_websocket_connection_get_max_incoming_payload_size($!swc);
  }

  method get_origin {
    soup_websocket_connection_get_origin($!swc);
  }

  method get_protocol {
    soup_websocket_connection_get_protocol($!swc);
  }

  method get_state {
    SoupWebsocketStateEnum( soup_websocket_connection_get_state($!swc) )
  }

  method get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &soup_websocket_connection_get_type,
      $n,
      $t
    );
  }

  method get_uri {
    soup_websocket_connection_get_uri($!swc);
  }

  method send_binary (gpointer $data, Int() $length) {
    my gsize $l = $length;

    soup_websocket_connection_send_binary($!swc, $data, $l);
  }

  method send_message (Int() $type, GBytes() $message) {
    my SoupWebsocketDataType $t = $type;

    soup_websocket_connection_send_message($!swc, $t, $message);
  }

  method send_text (Str() $text) {
    soup_websocket_connection_send_text($!swc, $text);
  }

  method set_keepalive_interval (Int() $interval) {
    my guint $i = $interval;

    soup_websocket_connection_set_keepalive_interval($!swc, $i);
  }

  method set_max_incoming_payload_size (Int() $max_incoming_payload_size) {
    my guint64 $m = $max_incoming_payload_size;

    soup_websocket_connection_set_max_incoming_payload_size($!swc, $m);
  }

}
