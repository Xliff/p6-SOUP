use v6.c;

use SOUP::Raw::Types;
use SOUP::Raw::Server::Connection;

use GLib::Raw::Types;

use GIO::Stream;
use GIO::SocketAddress;
use GIO::TlsCertificate;
use GIO::TlsDatabase;
use SOUP::Server::Message::IO;

use GLib::Roles::Implementor;
use GLib::Roles::Object;

our subset SoupServerConnectionAncestry is export of Mu
  where SoupServerConnection | GObject;

class SOUP::Server::Conection {
  also does GLib::Roles::Object;

  has SoupServerConnection $!ssc is implementor;

  submethod BUILD ( :$soup-server-connection ) {
    self.setSoupServerConnection($soup-server-connection)
      if $soup-server-connection
  }

  method setSoupServerConnection (SoupServerConnectionAncestry $_) {
    my $to-parent;

    $!ssc = do {
      when SoupServerConnection {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(SoupServerConnection, $_);
      }
    }
    self.setGOjbect($to-parent);
  }

  method SOUP::Raw::Definitions::SoupServerConnection
  { $!ssc }

  multi method new (
     $soup-server-connection where * ~~ SoupServerConnectionAncestry,

    :$ref = True
  ) {
    return unless $soup-server-connection;

    my $o = self.bless( :$soup-server-connection );
    $o.ref if $ref;
    $o;
  }

  multi method new (
    GSocket()         $socket,
    GTlsCertificate() $tls_certificate,
    GTlsDatabase()    $tls_database,
    Int()             $tls_auth_mode
  ) {
    my GTlsAuthenticationMode $t = $tls_auth_mode;

    my $soup-server-conn = soup_server_connection_new(
      $!ssc,
      $tls_certificate,
      $tls_database,
      $t
    );

    $soup-server-conn ?? self.bless( :$soup-server-conn ) !! Nil;
  }

  method new_for_connection (
    GIOStream()      $stream,
    GSocketAddress() $local_addr,
    GSocketAddress() $remote_addr
  ) {
    my $soup-server-conn = soup_server_connection_new_for_connection(
      $stream,
      $local_addr,
      $remote_addr
    );

    $soup-server-conn ?? self.bless( :$soup-server-conn ) !! Nil
  }

  # Type: GIoStream
  method connection is rw  is g-property {
    my $gv = GLib::Value.new( GIO::IOStream.get_type );
    Proxy.new(
      FETCH => sub ($) {
        warn 'connection does not allow reading' if $DEBUG;
        0;
      },
      STORE => -> $, GIOStream() $val is copy {
        $gv.object = $val;
        self.prop_set('connection', $gv);
      }
    );
  }

  # Type: GSocketAddress
  method local-address ( :$raw = False ) is rw  is g-property {
    my $gv = GLib::Value.new( GIO::SocketAddress.get_type );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('local-address', $gv);
        propReturnObject(
          $gv.object,
          $raw,
          |GIO::SocketAddress.getTypePair
        );
      },
      STORE => -> $, GSocketAddress() $val is copy {
        $gv.object = $val;
        self.prop_set('local-address', $gv);
      }
    );
  }

  # Type: GSocketAddress
  method remote-address ( :$raw = False ) is rw  is g-property {
    my $gv = GLib::Value.new( GIO::SocketAddress.get_type );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('remote-address', $gv);
        propReturnObject(
          $gv.object,
          $raw,
          |GIO::SocketAddress.getTypePair
        );
      },
      STORE => -> $, GSocketAddress() $val is copy {
        $gv.object = $val;
        self.prop_set('remote-address', $gv);
      }
    );
  }

  # Type: GSocket
  method socket ( :$raw = False ) is rw  is g-property {
    my $gv = GLib::Value.new( GIO::Socket.get_type );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('socket', $gv);
        propReturnObject(
          $gv.object,
          $raw,
          |GIO::Socket.getTypePair
        );
      },
      STORE => -> $, SoupSocket() $val is copy {
        $gv.object = $val;
        self.prop_set('socket', $gv);
      }
    );
  }

  # Type: GTlsAuthenticationMode
  method tls-auth-mode ( :$enum = True ) is rw  is g-property {
    my $gv = GLib::Value.typeFromEnum( GTlsAuthenticationMode );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('tls-auth-mode', $gv);
        my $e = $gv.enum;
        return $e unless $enum;
        GTlsAuthenticationModeEnum($e);
      },
      STORE => -> $, Int()  $val is copy {
        $gv.valueFromEnum(GTlsAuthenticationMode) = $val;
        self.prop_set('tls-auth-mode', $gv);
      }
    );
  }

  # Type: GTlsCertificate
  method tls-certificate ( :$raw = False ) is rw  is g-property {
    my $gv = GLib::Value.new( GIO::TlsCertificate.get_type );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('tls-certificate', $gv);
        propReturnObject(
          $gv.object,
          $raw,
          |GIO::TlsCertificate.getTypePair
        );
      },
      STORE => -> $, GTlsCertificate() $val is copy {
        $gv.object = $val;
        self.prop_set('tls-certificate', $gv);
      }
    );
  }

  # Type: GTlsDatabase
  method tls-database ( :$raw = False ) is rw  is g-property {
    my $gv = GLib::Value.new( GIO::TlsDatabase.get_type );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('tls-database', $gv);
        propReturnObject(
          $gv.object,
          $raw,
          |GTlsDatabase.getTypePair
        );
      },
      STORE => -> $, GTlsDatabase() $val is copy {
        $gv.object = $val;
        self.prop_set('tls-database', $gv);
      }
    );
  }

  # Type: GTlsCertificate
  method tls-peer-certificate ( :$raw = False ) is rw  is g-property {
    my $gv = GLib::Value.new( GIO::TlsCertificate.get_type );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('tls-peer-certificate', $gv);
        propReturnObject(
          $gv.object,
          $raw,
          |GIO::TlsCertificate.getTypePair
        );
      },
      STORE => -> $,  $val is copy {
        warn 'tls-peer-certificate does not allow writing'
      }
    );
  }

  # Type: GTlsCertificateFlags
  method tls-peer-certificate-errors ( :set(:$flags) = True )
    is rw
    is g-property
  {
    my $gv = GLib::Value.typeFromEnum( GTlsCertificateFlags );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('tls-peer-certificate-errors', $gv);
        my $e = $gv.enum;
        return $e unless $flags;
        getFlags(GTlsCertificateFlagsEnum, $e);
      },
      STORE => -> $,  $val is copy {
        warn 'tls-peer-certificate-errors does not allow writing'
      }
    );
  }

  method accepted {
    soup_server_connection_accepted($!ssc);
  }

  method disconnect {
    soup_server_connection_disconnect($!ssc);
  }

  method get_io_data ( :$raw = False ) {
    propReturnObject(
      soup_server_connection_get_io_data($!ssc),
      $raw,
      |SOUP::Server::Message::IO.getTypePair
    );
  }

  method get_iostream ( :$raw = False ) {
    propReturnObject(
      soup_server_connection_get_iostream($!ssc),
      $raw,
      |GIO::IOStream.getTypePair
    );
  }

  method get_local_address ( :$raw = False ) {
    propReturnObject(
      soup_server_connection_get_local_address($!ssc),
      $raw,
      |GIO::SocketAddress.getTypePair
    );
  }

  method get_remote_address ( :$raw = False ) {
    propReturnObject(
      soup_server_connection_get_remote_address($!ssc),
      $raw,
      |GIO::SocketAddress.getTypePair
    );
  }

  method get_socket ( :$raw = False ) {
    propReturnObject(
      soup_server_connection_get_socket($!ssc),
      $raw,
      |GIO::Socket.getTypePair
    );
  }

  method get_tls_peer_certificate ( :$raw = False ) {
    propReturnObject(
      soup_server_connection_get_tls_peer_certificate($!ssc),
      $raw,
      |GIO::TlsCertificate.getTypePair
    );
  }

  method get_tls_peer_certificate_errors ( :set(:$flags) = True ) {
    my $f = soup_server_connection_get_tls_peer_certificate_errors($!ssc);
    return $f unless $flags;
    getFlags(GTlsCertificateFlagsEnum, $f);
  }

  method is_connected {
    so soup_server_connection_is_connected($!ssc);
  }

  method is_ssl {
    so soup_server_connection_is_ssl($!ssc);
  }

  method set_advertise_http2 (Int() $advertise_http2) {
    my gboolean $a = $advertise_http2.so.Int;

    soup_server_connection_set_advertise_http2($!ssc, $a);
  }

  method steal ( :$raw = False ) {
    propReturnObject(
      soup_server_connection_steal($!ssc),
      $raw,
      |GIO::Stream.getTypePair
    );
  }

}
