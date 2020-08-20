use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GIO::Raw::Definitions;
use SOUP::Raw::Definitions;
use SOUP::Raw::Enums;

unit package SOUP::Raw::Server;

### /usr/include/libsoup-2.4/libsoup/soup-server.h

sub soup_server_accept_iostream (
  SoupServer $server,
  GIOStream $stream,
  GSocketAddress $local_addr,
  GSocketAddress $remote_addr,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_server_add_auth_domain (
  SoupServer $server,
  SoupAuthDomain $auth_domain
)
  is native(soup)
  is export
{ * }

sub soup_server_add_early_handler (
  SoupServer $server,
  Str $path,
  &callback (SoupServer, SoupMessage, Str, GHashTable, SoupClientContext, gpointer),
  gpointer $user_data,
  GDestroyNotify $destroy
)
  is native(soup)
  is export
{ * }

sub soup_server_add_handler (
  SoupServer $server,
  Str $path,
  &callback (SoupServer, SoupMessage, Str, GHashTable, SoupClientContext, gpointer),
  gpointer $user_data,
  GDestroyNotify $destroy
)
  is native(soup)
  is export
{ * }

sub soup_server_add_websocket_extension (
  SoupServer $server,
  GType $extension_type
)
  is native(soup)
  is export
{ * }

sub soup_server_add_websocket_handler (
  SoupServer $server,
  Str $path,
  Str $origin,
  Str $protocols,
  &callback (SoupServer, SoupWebsocketConnection, Str, SoupClientContext, gpointer),
  gpointer $user_data,
  GDestroyNotify $destroy
)
  is native(soup)
  is export
{ * }

sub soup_server_disconnect (SoupServer $server)
  is native(soup)
  is export
{ * }

sub soup_server_get_async_context (SoupServer $server)
  returns GMainContext
  is native(soup)
  is export
{ * }

sub soup_server_get_listener (SoupServer $server)
  returns SoupSocket
  is native(soup)
  is export
{ * }

sub soup_server_get_listeners (SoupServer $server)
  returns GSList
  is native(soup)
  is export
{ * }

sub soup_server_get_port (SoupServer $server)
  returns guint
  is native(soup)
  is export
{ * }

sub soup_server_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_server_get_uris (SoupServer $server)
  returns GSList
  is native(soup)
  is export
{ * }

sub soup_server_is_https (SoupServer $server)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_server_listen (
  SoupServer $server,
  GSocketAddress $address,
  SoupServerListenOptions $options,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_server_listen_all (
  SoupServer $server,
  guint $port,
  SoupServerListenOptions $options,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_server_listen_fd (
  SoupServer $server,
  gint $fd,
  SoupServerListenOptions $options,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_server_listen_local (
  SoupServer $server,
  guint $port,
  SoupServerListenOptions $options,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_server_listen_socket (
  SoupServer $server,
  GSocket $socket,
  SoupServerListenOptions $options,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_server_new (Str)
  returns SoupServer
  is native(soup)
  is export
{ * }

sub soup_server_pause_message (SoupServer $server, SoupMessage $msg)
  is native(soup)
  is export
{ * }

sub soup_server_quit (SoupServer $server)
  is native(soup)
  is export
{ * }

sub soup_server_remove_auth_domain (
  SoupServer $server,
  SoupAuthDomain $auth_domain
)
  is native(soup)
  is export
{ * }

sub soup_server_remove_handler (SoupServer $server, Str $path)
  is native(soup)
  is export
{ * }

sub soup_server_remove_websocket_extension (
  SoupServer $server,
  GType $extension_type
)
  is native(soup)
  is export
{ * }

sub soup_server_run (SoupServer $server)
  is native(soup)
  is export
{ * }

sub soup_server_run_async (SoupServer $server)
  is native(soup)
  is export
{ * }

sub soup_server_set_ssl_cert_file (
  SoupServer $server,
  Str $ssl_cert_file,
  Str $ssl_key_file,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_client_context_get_address (SoupClientContext $client)
  returns SoupAddress
  is native(soup)
  is export
{ * }

sub soup_client_context_get_auth_domain (SoupClientContext $client)
  returns SoupAuthDomain
  is native(soup)
  is export
{ * }

sub soup_client_context_get_auth_user (SoupClientContext $client)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_client_context_get_gsocket (SoupClientContext $client)
  returns GSocket
  is native(soup)
  is export
{ * }

sub soup_client_context_get_host (SoupClientContext $client)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_client_context_get_local_address (SoupClientContext $client)
  returns GSocketAddress
  is native(soup)
  is export
{ * }

sub soup_client_context_get_remote_address (SoupClientContext $client)
  returns GSocketAddress
  is native(soup)
  is export
{ * }

sub soup_client_context_get_socket (SoupClientContext $client)
  returns SoupSocket
  is native(soup)
  is export
{ * }

sub soup_client_context_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_client_context_steal_connection (SoupClientContext $client)
  returns GIOStream
  is native(soup)
  is export
{ * }

sub soup_server_unpause_message (SoupServer $server, SoupMessage $msg)
  is native(soup)
  is export
{ * }
