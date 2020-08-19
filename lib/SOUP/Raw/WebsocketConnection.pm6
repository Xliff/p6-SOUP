use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GIO::Raw::Definitions;
use SOUP::Raw::Definitions;
use SOUP::Raw::Enums;

unit package SOUP::Raw::WebsocketConnection;

### /usr/include/libsoup-2.4/libsoup/soup-websocket-connection.h

sub soup_websocket_connection_close (
  SoupWebsocketConnection $self,
  gushort $code,
  Str $data
)
  is native(soup)
  is export
{ * }

sub soup_websocket_connection_get_close_code (SoupWebsocketConnection $self)
  returns gushort
  is native(soup)
  is export
{ * }

sub soup_websocket_connection_get_close_data (SoupWebsocketConnection $self)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_websocket_connection_get_connection_type (
  SoupWebsocketConnection $self
)
  returns SoupWebsocketConnectionType
  is native(soup)
  is export
{ * }

sub soup_websocket_connection_get_extensions (SoupWebsocketConnection $self)
  returns GList
  is native(soup)
  is export
{ * }

sub soup_websocket_connection_get_io_stream (SoupWebsocketConnection $self)
  returns GIOStream
  is native(soup)
  is export
{ * }

sub soup_websocket_connection_get_keepalive_interval (
  SoupWebsocketConnection $self
)
  returns guint
  is native(soup)
  is export
{ * }

sub soup_websocket_connection_get_max_incoming_payload_size (
  SoupWebsocketConnection $self
)
  returns guint64
  is native(soup)
  is export
{ * }

sub soup_websocket_connection_get_origin (SoupWebsocketConnection $self)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_websocket_connection_get_protocol (SoupWebsocketConnection $self)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_websocket_connection_get_state (SoupWebsocketConnection $self)
  returns SoupWebsocketState
  is native(soup)
  is export
{ * }

sub soup_websocket_connection_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_websocket_connection_get_uri (SoupWebsocketConnection $self)
  returns SoupURI
  is native(soup)
  is export
{ * }

sub soup_websocket_connection_new (
  GIOStream $stream,
  SoupURI $uri,
  SoupWebsocketConnectionType $type,
  Str $origin,
  Str $protocol
)
  returns SoupWebsocketConnection
  is native(soup)
  is export
{ * }

sub soup_websocket_connection_new_with_extensions (
  GIOStream $stream,
  SoupURI $uri,
  SoupWebsocketConnectionType $type,
  Str $origin,
  Str $protocol,
  GList $extensions
)
  returns SoupWebsocketConnection
  is native(soup)
  is export
{ * }

sub soup_websocket_connection_send_binary (
  SoupWebsocketConnection $self,
  gconstpointer $data,
  gsize $length
)
  is native(soup)
  is export
{ * }

sub soup_websocket_connection_send_message (
  SoupWebsocketConnection $self,
  SoupWebsocketDataType $type,
  GBytes $message
)
  is native(soup)
  is export
{ * }

sub soup_websocket_connection_send_text (
  SoupWebsocketConnection $self,
  Str $text
)
  is native(soup)
  is export
{ * }

sub soup_websocket_connection_set_keepalive_interval (
  SoupWebsocketConnection $self,
  guint $interval
)
  is native(soup)
  is export
{ * }

sub soup_websocket_connection_set_max_incoming_payload_size (
  SoupWebsocketConnection $self,
  guint64 $max_incoming_payload_size
)
  is native(soup)
  is export
{ * }
