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
use SOUP::Test;
use SOUP::URI;

# Port of https://github.com/GNOME/libsoup/blob/master/tests/socket-test.c

subtest 'Unconnected Socket Tests', {
  my $in-localhost = sockaddr_in.new;

  $in-localhost.sin_family      = AF_INET;
  $in-localhost.sin_port        = 0;
  $in-localhost.sin_addr.s_addr = htonl(INADDR_LOOPBACK);

  my $localhost = SOUP::Address.new-from-sockaddr($in-localhost);
  ok $localhost,                                          '$localhost SOUP::Address object is defined';

  my $res = $localhost.resolve-sync;
  is $res,                   SOUP_STATUS_OK,              '$localhost resolves correctly';

  my $sock = SOUP::Socket.new(local-address => $localhost);
  ok $sock,                                               '$sock SOUP::Socket obect is defined';

  {
    my $addr = $sock.local-address;
    ok $addr,                                             '$addr SOUP::Addres object from SOUP::Socket is defined';
    is $addr.get-physical,   '127.0.0.1',                 'Socket physical address is 127.0.0.1';
    is $addr.port,           0,                           'Socket port is 0';
  }

  {
    my $log = GLib::Test::Log.new(G_LOG_LEVEL_WARNING);
    $log.expect('socket not connected');

    my $r-addr = $sock.remote-address;
    ok $log.got-expected,                                 'Got proper message when retrieving an address from an unconnected socket';
    $log.done;
  }

  ok $sock.listen,                                        'Socket can be set to listening state';

  {
    my $addr = $sock.local-address;
    ok  $addr,                                            'Can get local address from connected socket';
    is  $addr.get-physical,  '127.0.0.1',                 'Socket physical address is 127.0.0.1';
    ok  $addr.port > 0,                                   'Socket is listening on a non-zero port';
  }

  {
    my $client = SOUP::Socket.new(remote-address => $sock.local-address);
    is  $client.connect-sync, SOUP_STATUS_OK,             'Can connect another socket to same address as $sock';

    my $addr = $client.local-address;
    ok  $addr,                                            'Can get local address from client socket';
    my $r-addr = $client.remote-address;
    ok  $r-addr,                                          'Can get local address from client socket';
    is  $r-addr.get-physical, '127.0.0.1',                'Socket physical address is 127.0.0.1';
    ok  $r-addr.port > 0,                                 'Socket is listening on a non-zero port';
    $client.unref;
  }

  {
    my $client = SOUP::Socket.new(remote-address => $sock.local-address);
    my $log = GLib::Test::Log.new(G_LOG_LEVEL_WARNING);

    {
      my $r-addr = $sock.remote-address;
      ok  $log.count,                                       'Attempting to get remote address of unconnected socket complains';
    }

    $log.reset;
    $sock.disconnect;
    $log.expect('socket not connected');

    {
      my $r-addr = $sock.remote-address;
      ok  $log.got-expected,                              'Attempting to get remote address of disconnected socket complains';
      nok $r-addr,                                        'Remote address object is not defined';
      $log.reset;
    }

    {
      $log.expect('socket not connected');
      my $addr = $sock.remote-address;
      ok  $log.got-expected,                              'Attempting to get local address of disconnected socket complains';
      nok $addr,                                          'Local address object is not defined';
      $log.reset;
    }

    {
      is $client.connect-sync, SOUP_STATUS_CANT_CONNECT, "Attempting to connect new client results in CAN'T CONNECT error";
      $log.expect('socket not connected');
      my $addr = $client.local-address;
      ok  $log.got-expected,                             'Attempting to get local address of disconnected client complains';
      nok $addr,                                         'Local address object is not defined';
      $log.reset;
    }
  }
}

subtest 'File descriptor client tests', {
  my $server = SOUP::Test::Server.new;
  my $uri = $server.get-uri;
  my $gsock = GIO::Socket.new(G_SOCKET_FAMILY_IPV4, G_SOCKET_TYPE_STREAM);
  nok $ERROR,                                            'No error detected when creating socket';

  my $gaddr = GIO::InetSocketAddress.new-from-string('127.0.0.1', $uri.port);
  $gsock.connect($gaddr);
  nok $ERROR,                                            'No error detected when connecting socket';
  ok $gsock.is-connected,                                'Socket is commected';

  my $local-gaddr = $gsock.local-address;
  nok $ERROR,                                            'No error detected when retrieving socket\'s local address';

  my $sock = SOUP::Socket.new( fd => $gsock.fd );
  nok $ERROR,                                            'No error detected when creating a SoupSocket';
  ok  $sock,                                             'Created SoupSocket is defined';
  is  $sock.fd,           $gsock.fd,                     'SoupSocket and Socket have the same file descriptor';
  nok $sock.is-server,                                   'SoupSocket is not a server';
  ok  $sock.is-connected,                                'SoupSocket is connected';

  my ($local, $remote) = ($sock.local-address, $sock.remote-address);
  is  $local.physical,    '127.0.0.1',                   'SoupSocket local address is 127.0.0.1';
  is  $remote.physical,   '127.0.0.1',                   'SoupSocket remote address is 127.0.0.1';
  is  $local.port,        $local-gaddr.port,             'SoupSocket port is the same as regular socket\'s';
  is  $remote.port,       $uri.port,                     'SoupSocket remote port is the same as server\'s';

  .unref for $local, $remote, $gaddr, $local-gaddr, $gsock;
  $server.quit-unref;
}
