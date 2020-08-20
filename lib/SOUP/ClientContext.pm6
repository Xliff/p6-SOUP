use v6.c;

use SOUP::Raw::Types;
use SOUP::Raw::Server;

use GIO::Socket;
use GIO::SocketAddress;
use GIO::Stream;
use SOUP::Address;
use SOUP::Socket;

# BOXED

class SOUP::ClientContext {
  has SoupClientContext $!sc;

  submethod BUILD (:$client) {
    $!sc = $client;
  }

  method get_address (:$raw = False)
    is DEPRECATED<get_remote_address>
  {
    my $a = soup_client_context_get_address($!sc);

    $a ??
      ( $raw ?? $a !! SOUP::Address.new($a) )
      !!
      Nil;
  }

  method get_auth_domain {
    soup_client_context_get_auth_domain($!sc);
  }

  method get_auth_user {
    soup_client_context_get_auth_user($!sc);
  }

  method get_gsocket (:$raw = False) {
    my $gs = soup_client_context_get_gsocket($!sc);

    $gs ??
      ( $raw ?? $gs !! GIO::Socket.new($gs) )
      !!
      Nil;
  }

  method get_host {
    soup_client_context_get_host($!sc);
  }

  method get_local_address (:$raw = False) {
    my $a = soup_client_context_get_local_address($!sc);

    $a ??
      ( $raw ?? $a !! GIO::SocketAddress.new($a) )
      !!
      Nil;
  }

  method get_remote_address (:$raw = False) {
    my $a = soup_client_context_get_remote_address($!sc);

    $a ??
      ( $raw ?? $a !! GIO::SocketAddress.new($a) )
      !!
      Nil;
  }

  method get_socket (:$raw = False)
    is DEPRECATED<get_gsocket>
  {
    my $ss = soup_client_context_get_socket($!sc);

    $ss ??
      ( $raw ?? $ss !! SOUP::Socket.new($ss) )
      !!
      Nil;
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_client_context_get_type, $n, $t );
  }

  method steal_connection (:$raw = False) {
    my $ios = soup_client_context_steal_connection($!sc);

    $ios ??
       ( $raw ?? $ios !! GIO::Stream.new($ios) )
       !!
       Nil;
  }

}
