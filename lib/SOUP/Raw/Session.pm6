use v6.c;

use NativeCall;

use GLib::Raw::Object;
use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GIO::Raw::Definitions;
use SOUP::Raw::Definitions;

unit package SOUP::Raw::Session;

### /usr/include/libsoup-2.4/libsoup/soup-session.h

sub soup_session_abort (SoupSession $session)
  is native(soup)
  is export
{ * }

sub soup_session_add_feature (
  SoupSession $session,
  SoupSessionFeature $feature
)
  is native(soup)
  is export
{ * }

sub soup_session_add_feature_by_type (
  SoupSession $session,
  GType $feature_type
)
  is native(soup)
  is export
{ * }

sub soup_session_cancel_message (
  SoupSession $session,
  SoupMessage $msg,
  guint $status_code
)
  is native(soup)
  is export
{ * }

# cw: Defined in .h files, but aparently deprecated
# sub soup_session_connect_async (
#   SoupSession $session,
#   SoupURI $uri,
#   GCancellable $cancellable,
#   SoupSessionConnectProgressCallback $progress_callback,
#   GAsyncReadyCallback $callback,
#   gpointer $user_data
# )
#   is native(soup)
#   is export
# { * }

sub soup_session_connect_finish (
  SoupSession $session,
  GAsyncResult $result,
  CArray[Pointer[GError]] $error
)
  returns GIOStream
  is native(soup)
  is export
{ * }

sub soup_session_get_async_context (SoupSession $session)
  returns GMainContext
  is native(soup)
  is export
{ * }

sub soup_session_get_feature (SoupSession $session, GType $feature_type)
  returns SoupSessionFeature
  is native(soup)
  is export
{ * }

sub soup_session_get_feature_for_message (
  SoupSession $session,
  GType $feature_type,
  SoupMessage $msg
)
  returns SoupSessionFeature
  is native(soup)
  is export
{ * }

sub soup_session_get_features (SoupSession $session, GType $feature_type)
  returns GSList
  is native(soup)
  is export
{ * }

sub soup_session_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_session_has_feature (SoupSession $session, GType $feature_type)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_session_new ()
  returns SoupSession
  is native(soup)
  is export
{ * }

sub soup_session_new_with_options (
  # accept-language 	gchar*
  Str, Str,
  # accept-language-auto 	gboolean
  Str, gboolean,
  # add-feature 	SoupSessionFeature*
  Str, SoupSessionFeature,
  # add-feature-by-type 	GType* (GObject)
  Str, GObject,
  # async-context 	gpointer (GMainContext)
  Str, GMainContext,
  # http-aliases 	GStrv
  Str, CArray[Str],
  # https-aliases 	GStrv
  Str, CArray[Str],
  # idle-timeout 	guint
  Str, guint,
  # local-address 	SoupAddress*
  Str, SoupAddress,
  # max-conns 	gint
  Str, gint,
  # max-conns-per-host 	gint
  Str, gint,
  # proxy-resolver 	GProxyResolver*
  Str, GProxyResolver,
  # proxy-uri 	SoupURI*
  Str, SoupURI,
  # remove-feature-by-type 	GType* (GObject)
  Str, GObject,
  # ssl-ca-file 	gchar*
  Str, Str,
  # ssl-strict 	gboolean
  Str, gboolean,
  # ssl-use-system-ca-file 	gboolean
  Str, gboolean,
  # timeout 	guint
  Str, guint,
  # tls-database 	GTlsDatabase*
  Str, GTlsDatabase,
  # tls-interaction 	GTlsInteraction*
  Str, GTlsInteraction,
  # use-ntlm 	gboolean
  Str, gboolean,
  # use-thread-context 	gboolean
  Str, gboolean,
  # user-agent 	gchar*
  Str, Str,
  # End
  Str
)
  returns SoupSession
  is native(soup)
  is export
{ * }

sub soup_session_pause_message (SoupSession $session, SoupMessage $msg)
  is native(soup)
  is export
{ * }

sub soup_session_prefetch_dns (
  SoupSession $session,
  Str $hostname,
  GCancellable $cancellable,
  &callback (SoupAddress, guint, Pointer),
  gpointer $user_data
)
  is native(soup)
  is export
{ * }

sub soup_session_prepare_for_uri (SoupSession $session, SoupURI $uri)
  is native(soup)
  is export
{ * }

sub soup_session_queue_message (
  SoupSession $session,
  SoupMessage $msg,
  &callback (SoupSession, SoupMessage, gpointer),
  gpointer $user_data
)
  is native(soup)
  is export
{ * }

sub soup_session_redirect_message (SoupSession $session, SoupMessage $msg)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_session_remove_feature (
  SoupSession $session,
  SoupSessionFeature $feature
)
  is native(soup)
  is export
{ * }

sub soup_session_remove_feature_by_type (
  SoupSession $session,
  GType $feature_type
)
  is native(soup)
  is export
{ * }

sub soup_session_request (
  SoupSession $session,
  Str $uri_string,
  CArray[Pointer[GError]] $error
)
  returns SoupRequest
  is native(soup)
  is export
{ * }

sub soup_session_request_http (
  SoupSession $session,
  Str $method,
  Str $uri_string,
  CArray[Pointer[GError]] $error
)
  returns SoupRequestHTTP
  is native(soup)
  is export
{ * }

sub soup_session_request_http_uri (
  SoupSession $session,
  Str $method,
  SoupURI $uri,
  CArray[Pointer[GError]] $error
)
  returns SoupRequestHTTP
  is native(soup)
  is export
{ * }

sub soup_session_request_uri (
  SoupSession $session,
  SoupURI $uri,
  CArray[Pointer[GError]] $error
)
  returns SoupRequest
  is native(soup)
  is export
{ * }

sub soup_session_requeue_message (SoupSession $session, SoupMessage $msg)
  is native(soup)
  is export
{ * }

sub soup_session_send (
  SoupSession $session,
  SoupMessage $msg,
  GCancellable $cancellable,
  CArray[Pointer[GError]] $error
)
  returns GInputStream
  is native(soup)
  is export
{ * }

sub soup_session_send_async (
  SoupSession $session,
  SoupMessage $msg,
  GCancellable $cancellable,
  GAsyncReadyCallback $callback,
  gpointer $user_data
)
  is native(soup)
  is export
{ * }

sub soup_session_send_finish (
  SoupSession $session,
  GAsyncResult $result,
  CArray[Pointer[GError]] $error
)
  returns GInputStream
  is native(soup)
  is export
{ * }

sub soup_session_send_message (SoupSession $session, SoupMessage $msg)
  returns guint
  is native(soup)
  is export
{ * }

sub soup_session_steal_connection (SoupSession $session, SoupMessage $msg)
  returns GIOStream
  is native(soup)
  is export
{ * }

sub soup_session_unpause_message (SoupSession $session, SoupMessage $msg)
  is native(soup)
  is export
{ * }

sub soup_session_websocket_connect_async (
  SoupSession $session,
  SoupMessage $msg,
  Str $origin,
  Str $protocols,
  GCancellable $cancellable,
  GAsyncReadyCallback $callback,
  gpointer $user_data
)
  is native(soup)
  is export
{ * }

sub soup_session_websocket_connect_finish (
  SoupSession $session,
  GAsyncResult $result,
  CArray[Pointer[GError]] $error
)
  returns SoupWebsocketConnection
  is native(soup)
  is export
{ * }

sub soup_session_would_redirect (SoupSession $session, SoupMessage $msg)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_request_error_quark ()
  returns GQuark
  is native(soup)
  is export
{ * }
