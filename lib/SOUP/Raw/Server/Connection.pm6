use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GIO::Raw::Definitions;
use GIO::Raw::Enums;
use SOUP::Raw::Definitions;

unit package SOUP::Raw::Server::Connections;

### /usr/src/libsoup/libsoup/server/soup-server-connection.h

sub soup_server_connection_accepted (SoupServerConnection $conn)
  is      native(soup)
  is      export
{ * }

sub soup_server_connection_disconnect (SoupServerConnection $conn)
  is      native(soup)
  is      export
{ * }

sub soup_server_connection_get_io_data (SoupServerConnection $conn)
  returns SoupServerMessageIO
  is      native(soup)
  is      export
{ * }

sub soup_server_connection_get_iostream (SoupServerConnection $conn)
  returns GIOStream
  is      native(soup)
  is      export
{ * }

sub soup_server_connection_get_local_address (SoupServerConnection $conn)
  returns GSocketAddress
  is      native(soup)
  is      export
{ * }

sub soup_server_connection_get_remote_address (SoupServerConnection $conn)
  returns GSocketAddress
  is      native(soup)
  is      export
{ * }

sub soup_server_connection_get_socket (SoupServerConnection $conn)
  returns GSocket
  is      native(soup)
  is      export
{ * }

sub soup_server_connection_get_tls_peer_certificate (SoupServerConnection $conn)
  returns GTlsCertificate
  is      native(soup)
  is      export
{ * }

sub soup_server_connection_get_tls_peer_certificate_errors (SoupServerConnection $conn)
  returns GTlsCertificateFlags
  is      native(soup)
  is      export
{ * }

sub soup_server_connection_is_connected (SoupServerConnection $conn)
  returns uint32
  is      native(soup)
  is      export
{ * }

sub soup_server_connection_is_ssl (SoupServerConnection $conn)
  returns uint32
  is      native(soup)
  is      export
{ * }

sub soup_server_connection_new (
  GSocket                $socket,
  GTlsCertificate        $tls_certificate,
  GTlsDatabase           $tls_database,
  GTlsAuthenticationMode $tls_auth_mode
)
  returns SoupServerConnection
  is      native(soup)
  is      export
{ * }

sub soup_server_connection_new_for_connection (
  GIOStream      $connection,
  GSocketAddress $local_addr,
  GSocketAddress $remote_addr
)
  returns SoupServerConnection
  is      native(soup)
  is      export
{ * }

sub soup_server_connection_set_advertise_http2 (
  SoupServerConnection $conn,
  gboolean             $advertise_http2
)
  is      native(soup)
  is      export
{ * }

sub soup_server_connection_steal (SoupServerConnection $conn)
  returns GIOStream
  is      native(soup)
  is      export
{ * }
