use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GIO::Raw::Definitions;
use SOUP::Raw::Definitions;
use SOUP::Raw::Enums;

unit package SOUP::Raw::Sockeet;

### /usr/include/libsoup-2.4/libsoup/soup-socket.h

sub soup_socket_connect_async (
  SoupSocket $sock,
  GCancellable $cancellable,
  &callback (SoupSocket, guint, gpointer),
  gpointer $user_data
)
  is native(soup)
  is export
{ * }

sub soup_socket_connect_sync (SoupSocket $sock, GCancellable $cancellable)
  returns guint
  is native(soup)
  is export
{ * }

sub soup_socket_disconnect (SoupSocket $sock)
  is native(soup)
  is export
{ * }

sub soup_socket_get_fd (SoupSocket $sock)
  returns gint
  is native(soup)
  is export
{ * }

sub soup_socket_get_local_address (SoupSocket $sock)
  returns SoupAddress
  is native(soup)
  is export
{ * }

sub soup_socket_get_remote_address (SoupSocket $sock)
  returns SoupAddress
  is native(soup)
  is export
{ * }

sub soup_socket_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_socket_is_connected (SoupSocket $sock)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_socket_is_ssl (SoupSocket $sock)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_socket_listen (SoupSocket $sock)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_socket_new (Str)
  returns SoupSocket
  is native(soup)
  is export
{ * }

sub soup_socket_read (
  SoupSocket $sock,
  gpointer $buffer,
  gsize $len,
  gsize $nread is rw,
  GCancellable $cancellable,
  CArray[Pointer[GError]] $error
)
  returns SoupSocketIOStatus
  is native(soup)
  is export
{ * }

sub soup_socket_read_until (
  SoupSocket $sock,
  gpointer $buffer,
  gsize $len,
  gconstpointer $boundary,
  gsize $boundary_len is rw,
  gsize $nread,
  gboolean $got_boundary is rw,
  GCancellable $cancellable,
  CArray[Pointer[GError]] $error
)
  returns SoupSocketIOStatus
  is native(soup)
  is export
{ * }

sub soup_socket_start_proxy_ssl (
  SoupSocket $sock,
  Str $ssl_host,
  GCancellable $cancellable
)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_socket_start_ssl (SoupSocket $sock, GCancellable $cancellable)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_socket_write (
  SoupSocket $sock,
  gconstpointer $buffer,
  gsize $len,
  gsize $nwrote is rw,
  GCancellable $cancellable,
  CArray[Pointer[GError]] $error
)
  returns SoupSocketIOStatus
  is native(soup)
  is export
{ * }
