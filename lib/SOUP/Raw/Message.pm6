use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GIO::Raw::Definitions;
use GIO::Raw::Enums;
use SOUP::Raw::Definitions;
use SOUP::Raw::Enums;

unit package SOUP::Raw::Message;

### /usr/include/libsoup-2.4/libsoup/soup-message.h

sub soup_message_add_header_handler (
  SoupMessage $msg,
  Str $signal,
  Str $header,
  GCallback $callback,
  gpointer $user_data
)
  returns guint
  is native(soup)
  is export
{ * }

sub soup_message_add_status_code_handler (
  SoupMessage $msg,
  Str $signal,
  guint $status_code,
  GCallback $callback,
  gpointer $user_data
)
  returns guint
  is native(soup)
  is export
{ * }

sub soup_message_content_sniffed (
  SoupMessage $msg,
  Str $content_type,
  GHashTable $params
)
  is native(soup)
  is export
{ * }

sub soup_message_disable_feature (SoupMessage $msg, GType $feature_type)
  is native(soup)
  is export
{ * }

sub soup_message_finished (SoupMessage $msg)
  is native(soup)
  is export
{ * }

sub soup_message_get_address (SoupMessage $msg)
  returns SoupAddress
  is native(soup)
  is export
{ * }

sub soup_message_get_first_party (SoupMessage $msg)
  returns SoupURI
  is native(soup)
  is export
{ * }

sub soup_message_get_flags (SoupMessage $msg)
  returns SoupMessageFlags
  is native(soup)
  is export
{ * }

sub soup_message_get_http_version (SoupMessage $msg)
  returns SoupHTTPVersion
  is native(soup)
  is export
{ * }

sub soup_message_get_https_status (
  SoupMessage $msg,
  GTlsCertificate $certificate,
  GTlsCertificateFlags $errors
)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_message_get_is_top_level_navigation (SoupMessage $msg)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_message_get_priority (SoupMessage $msg)
  returns SoupMessagePriority
  is native(soup)
  is export
{ * }

sub soup_message_get_site_for_cookies (SoupMessage $msg)
  returns SoupURI
  is native(soup)
  is export
{ * }

sub soup_message_get_soup_request (SoupMessage $msg)
  returns SoupRequest
  is native(soup)
  is export
{ * }

sub soup_message_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_message_get_uri (SoupMessage $msg)
  returns SoupURI
  is native(soup)
  is export
{ * }

sub soup_message_got_body (SoupMessage $msg)
  is native(soup)
  is export
{ * }

sub soup_message_got_chunk (SoupMessage $msg, SoupBuffer $chunk)
  is native(soup)
  is export
{ * }

sub soup_message_got_headers (SoupMessage $msg)
  is native(soup)
  is export
{ * }

sub soup_message_got_informational (SoupMessage $msg)
  is native(soup)
  is export
{ * }

sub soup_message_is_keepalive (SoupMessage $msg)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_message_new (Str $method, Str $uri_string)
  returns SoupMessage
  is native(soup)
  is export
{ * }

sub soup_message_new_from_uri (Str $method, SoupURI $uri)
  returns SoupMessage
  is native(soup)
  is export
{ * }

sub soup_message_restarted (SoupMessage $msg)
  is native(soup)
  is export
{ * }

sub soup_message_set_chunk_allocator (
  SoupMessage $msg,
  &allocator (SoupMessage, gsize, gpointer --> SoupBuffer),
  gpointer $user_data,
  GDestroyNotify $destroy_notify
)
  is native(soup)
  is export
{ * }

sub soup_message_set_first_party (SoupMessage $msg, SoupURI $first_party)
  is native(soup)
  is export
{ * }

sub soup_message_set_flags (SoupMessage $msg, SoupMessageFlags $flags)
  is native(soup)
  is export
{ * }

sub soup_message_set_http_version (SoupMessage $msg, SoupHTTPVersion $version)
  is native(soup)
  is export
{ * }

sub soup_message_set_is_top_level_navigation (
  SoupMessage $msg,
  gboolean $is_top_level_navigation
)
  is native(soup)
  is export
{ * }

sub soup_message_set_priority (
  SoupMessage $msg,
  SoupMessagePriority $priority
)
  is native(soup)
  is export
{ * }

sub soup_message_set_redirect (
  SoupMessage $msg,
  guint $status_code,
  Str $redirect_uri
)
  is native(soup)
  is export
{ * }

sub soup_message_set_request (
  SoupMessage $msg,
  Str $content_type,
  SoupMemoryUse $req_use,
  Str $req_body,
  gsize $req_length
)
  is native(soup)
  is export
{ * }

sub soup_message_set_response (
  SoupMessage $msg,
  Str $content_type,
  SoupMemoryUse $resp_use,
  Str $resp_body,
  gsize $resp_length
)
  is native(soup)
  is export
{ * }

sub soup_message_set_site_for_cookies (SoupMessage $msg, SoupURI $site_for_cookies)
  is native(soup)
  is export
{ * }

sub soup_message_set_status (SoupMessage $msg, guint $status_code)
  is native(soup)
  is export
{ * }

sub soup_message_set_status_full (
  SoupMessage $msg,
  guint $status_code,
  Str $reason_phrase
)
  is native(soup)
  is export
{ * }

sub soup_message_set_uri (SoupMessage $msg, SoupURI $uri)
  is native(soup)
  is export
{ * }

sub soup_message_starting (SoupMessage $msg)
  is native(soup)
  is export
{ * }

sub soup_message_wrote_body (SoupMessage $msg)
  is native(soup)
  is export
{ * }

sub soup_message_wrote_body_data (SoupMessage $msg, SoupBuffer $chunk)
  is native(soup)
  is export
{ * }

sub soup_message_wrote_chunk (SoupMessage $msg)
  is native(soup)
  is export
{ * }

sub soup_message_wrote_headers (SoupMessage $msg)
  is native(soup)
  is export
{ * }

sub soup_message_wrote_informational (SoupMessage $msg)
  is native(soup)
  is export
{ * }
