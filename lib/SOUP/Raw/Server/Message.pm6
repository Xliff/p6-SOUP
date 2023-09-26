use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GIO::Raw::Definitions;
use GIO::Raw::Enums;
use SOUP::Raw::Definitions;
use SOUP::Raw::Enums;

unit package SOUP::Raw::Server::Message;

### /usr/src/libsoup/libsoup/server/soup-server-message.h

sub soup_server_message_get_http_version (SoupServerMessage $msg)
  returns SoupHTTPVersion
  is      native(soup)
  is      export
{ * }

sub soup_server_message_get_local_address (SoupServerMessage $msg)
  returns GSocketAddress
  is      native(soup)
  is      export
{ * }

sub soup_server_message_get_method (SoupServerMessage $msg)
  returns Str
  is      native(soup)
  is      export
{ * }

sub soup_server_message_get_reason_phrase (SoupServerMessage $msg)
  returns Str
  is      native(soup)
  is      export
{ * }

sub soup_server_message_get_remote_address (SoupServerMessage $msg)
  returns GSocketAddress
  is      native(soup)
  is      export
{ * }

sub soup_server_message_get_remote_host (SoupServerMessage $msg)
  returns Str
  is      native(soup)
  is      export
{ * }

sub soup_server_message_get_request_body (SoupServerMessage $msg)
  returns SoupMessageBody
  is      native(soup)
  is      export
{ * }

sub soup_server_message_get_request_headers (SoupServerMessage $msg)
  returns SoupMessageHeaders
  is      native(soup)
  is      export
{ * }

sub soup_server_message_get_response_body (SoupServerMessage $msg)
  returns SoupMessageBody
  is      native(soup)
  is      export
{ * }

sub soup_server_message_get_response_headers (SoupServerMessage $msg)
  returns SoupMessageHeaders
  is      native(soup)
  is      export
{ * }

sub soup_server_message_get_socket (SoupServerMessage $msg)
  returns GSocket
  is      native(soup)
  is      export
{ * }

sub soup_server_message_get_status (SoupServerMessage $msg)
  returns guint
  is      native(soup)
  is      export
{ * }

sub soup_server_message_get_tls_peer_certificate (SoupServerMessage $msg)
  returns GTlsCertificate
  is      native(soup)
  is      export
{ * }

sub soup_server_message_get_tls_peer_certificate_errors (SoupServerMessage $msg)
  returns GTlsCertificateFlags
  is      native(soup)
  is      export
{ * }

sub soup_server_message_get_uri (SoupServerMessage $msg)
  returns GUri
  is      native(soup)
  is      export
{ * }

sub soup_server_message_is_options_ping (SoupServerMessage $msg)
  returns uint32
  is      native(soup)
  is      export
{ * }

sub soup_server_message_pause (SoupServerMessage $msg)
  is      native(soup)
  is      export
{ * }

sub soup_server_message_set_http_version (
  SoupServerMessage $msg,
  SoupHTTPVersion   $version
)
  is      native(soup)
  is      export
{ * }

sub soup_server_message_set_redirect (
  SoupServerMessage $msg,
  guint             $status_code,
  Str               $redirect_uri
)
  is      native(soup)
  is      export
{ * }

sub soup_server_message_set_response (
  SoupServerMessage $msg,
  Str               $content_type,
  SoupMemoryUse     $resp_use,
  Str               $resp_body,
  gsize             $resp_length
)
  is      native(soup)
  is      export
{ * }

sub soup_server_message_set_status (
  SoupServerMessage $msg,
  guint             $status_code,
  Str               $reason_phrase
)
  is      native(soup)
  is      export
{ * }

sub soup_server_message_steal_connection (SoupServerMessage $msg)
  returns GIOStream
  is      native(soup)
  is      export
{ * }

sub soup_server_message_unpause (SoupServerMessage $msg)
  is      native(soup)
  is      export
{ * }
