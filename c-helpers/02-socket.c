#include <stdio.h>
#include <fcntl.h>
#include <gio/gnetworking.h>
#include <libsoup/soup.h>

void main (int argc, char **argv)
{
	SoupAddress *localhost;
	SoupSocket *sock;
	SoupSocket *client;
	SoupAddress *addr;
	guint res;
	struct sockaddr_in in_localhost;

//	g_test_bug ("673083");

	in_localhost.sin_family = AF_INET;
	in_localhost.sin_port = 0;
	in_localhost.sin_addr.s_addr = htonl (INADDR_LOOPBACK);


  printf( "AF_INET = %d\n", AF_INET);
	printf( "Size = %ld\n", sizeof(in_localhost) );
  printf( "Size sin_family = %ld\n", sizeof(in_localhost.sin_family) );
  printf( "Size sin_port = %ld\n", sizeof(in_localhost.sin_port) );
  printf( "Size sin_addr = %ld\n", sizeof(in_localhost.sin_addr) );


	localhost = soup_address_new_from_sockaddr (
		(struct sockaddr *) &in_localhost, sizeof (in_localhost));

  printf( "phy = %s\n", soup_address_get_physical(localhost) );

//	g_assert_true (localhost != NULL);
	res = soup_address_resolve_sync (localhost, NULL);
//	g_assert_cmpuint (res, ==, SOUP_STATUS_OK);

	sock = soup_socket_new (SOUP_SOCKET_LOCAL_ADDRESS, localhost,
				NULL);
//	g_assert_true (sock != NULL);

	addr = soup_socket_get_local_address (sock);
//	g_assert_true (addr != NULL);
//	g_assert_cmpstr (soup_address_get_physical (addr), ==, "127.0.0.1");
//	g_assert_cmpuint (soup_address_get_port (addr), ==, 0);

	printf("%p\n", localhost);
	printf("%p\n", addr);

	printf( "Addr = %s\n", soup_address_get_physical(addr) );
}
