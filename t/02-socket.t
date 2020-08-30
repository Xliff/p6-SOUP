use v6.c;

use Test;
use NativeCall;

use GLib::Compat::Definitions;
use SOUP::Raw::Types;

use GLib::Test;
use GLib::Log;
use GIO::Socket;
use GIO::SocketAddress;
use SOUP::Address;
use SOUP::Socket;
use SOUP::Server;
use SOUP::URI;

# Port of https://github.com/GNOME/libsoup/blob/master/tests/socket-test.c

subtest 'Unconnected Socket Tests', {
  my $in-localhost = sockaddr_in.new;

  $in-localhost.sin_family      = AF_INET;
  $in-localhost.sin_port        = 0;
  $in-localhost.sin_addr.s_addr = htonl(INADDR_LOOPBACK);

  my $localhost = SOUP::Address.new-from-sockaddr($in-localhost);
  ok $localhost,                          '$localhost SOUP::Address object is defined';

  my $res = $localhost.resolve-sync;
  is $res,               SOUP_STATUS_OK, '$localhost resolves correctly';

  my $sock = SOUP::Socket.new(local-address => $localhost);
  ok $sock,                              '$sock SOUP::Socket obect is defined';

  {
    my $addr = $sock.local-address;
    ok $addr,                              '$addr SOUP::Addres object from SOUP::Socket is defined';
    is $addr.get-physical, '127.0.0.1',    'Socket physical address is 127.0.0.1';
    is $addr.port,         0,              'Socket port is 0';
  }

  # Must fix GLib::Log before the rest of these tests can be written.
  my $log = GLib::Test::Log.new(G_LOG_LEVEL_WARNING);
  $log.expect(
    'socket not connected'
  );

  {
    my $r-addr = $sock.remote-address;
    ok $log.got-expected,                  'Got proper message when retrieving an address from an unconnected socket';
    $log.done;
  }

  ok $sock.listen,                         'Socket can be set to listening state';

  {
    my $addr = $sock.local-address;
    ok $addr,                              'Can get local address from connected socket';
    is $addr.get-physical, '127.0.0.1',    'Socket physical address is 127.0.0.1';
    ok $addr.port > 0,                     'Socket is listening on a non-zero port';
  }

}
