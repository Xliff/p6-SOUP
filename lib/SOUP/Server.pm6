use v6.c;

use NativeCall;

use GLib::Raw::ExtendedTypes;
use SOUP::Raw::Types;
use SOUP::Raw::Server;

use GLib::MainContext;
use GIO::Socket;
use SOUP::Socket;
use SOUP::URI;

use GLib::Roles::ListData;
use GLib::Roles::Object;

our subset SoupServerAncestry is export of Mu
  where SoupServer | GObject;

class SOUP::Server {
  also does GLib::Roles::Object;

  has SoupServer $!ss is implementor;

  submethod BUILD (:$server) {
    self.setSoupServer($server) if $server;
  }

  method setSoupServer (SoupServerAncestry $_) {
    $!ss = {
      when SoupServer { $_                   }
      default         { cast(SoupServer, $_) }
    }
    self.roleInit-Object;
  }

  multi method new (SoupServerAncestry $server) {
    $server ?? self.bless( :$server ) !! Nil;
  }
  multi method new (*@options) {
    my $server = soup_server_new(Str);
    $server = $server ?? self.bless( :$server ) !! Nil;

    if @options {
      $server."{ .[0] }"() = .[1] for @options.rotor(2);
    }
    $server;
  }

  # Type: gpointer (GMainContext)
  method async-context (:$raw = False) is rw is DEPRECATED {
    my $gv = GLib::Value.new( G_TYPE_POINTER );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('async-context', $gv)
        );

        my $o = $gv.pointer;
        return Nil unless $o;

        $o = cast(GMainContext, $o);
        return $o if $raw;

        GLib::MainContext.new($o);
      },
      STORE => -> $,  $val is copy {
        warn 'async-context is a construct-only attribute'
      }
    );
  }

  # Type: GStrv
  method http-aliases is rw  {
    my $gv = GLib::Value.new( $G_TYPE_STRV );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('http-aliases', $gv)
        );

        my $o = $gv.pointer;
        return Nil unless $o;

        CStringArrayToArray( cast(CArray[Str], $o) );
      },
      STORE => -> $,  $val is copy {
        my $vl = resolve-gstrv($val);
        $gv.pointer = cast(Pointer, $vl);
        self.prop_set('http-aliases', $gv);
      }
    );
  }

  # Type: GStrv
  method https-aliases is rw  {
    my $gv = GLib::Value.new( $G_TYPE_STRV );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('https-aliases', $gv)
        );

        my $o = $gv.pointer;
        return Nil unless $o;

        CStringArrayToArray( cast(CArray[Str], $o) );
      },
      STORE => -> $, $val is copy {
        my $vl = resolve-gstrv($val);
        $gv.pointer = cast(Pointer, $vl);
        self.prop_set('https-aliases', $gv);
      }
    );
  }

  # Type: SoupAddress
  method interface (:$raw = False) is rw is DEPRECATED {
    my $gv = GLib::Value.new( SOUP::Address.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('interface', $gv)
        );

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(SoupAddress, $o);
        return $o if $raw;

        SOUP::Address.new($o);
      },
      STORE => -> $,  $val is copy {
        warn 'interface is a construct-only attribute'
      }
    );
  }

  # Type: guint
  method port is rw is DEPRECATED {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('port', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        warn 'port is a construct-only attribute'
      }
    );
  }

  # Type: gboolean
  method raw-paths is rw  {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('raw-paths', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        warn 'raw-paths is a construct-only attribute'
      }
    );
  }

  # Type: gchar
  method server-header is rw  {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('server-header', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'server-header is a construct-only attribute'
      }
    );
  }

  # Type: gchar
  method ssl-cert-file is rw is DEPRECATED {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('ssl-cert-file', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'ssl-cert-file is a construct-only attribute'
      }
    );
  }

  # Type: gchar
  method ssl-key-file is rw is DEPRECATED {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('ssl-key-file', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'ssl-key-file is a construct-only attribute'
      }
    );
  }

  # Type: GTlsCertificate
  method tls-certificate (:$raw = False) is rw  {
    my $gv = GLib::Value.new( GIO::TlsCertificate.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('tls-certificate', $gv)
        );

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(GTlsCertificate, $o);
        return $o if $raw;

        GIO::TlsCertificate.new($o);
      },
      STORE => -> $, $val is copy {
        warn 'tls-certificate is a construct-only attribute'
      }
    );
  }

  # Is originally:
  # SoupServer, SoupMessage, SoupClientContext, gpointer --> void
  method request-aborted {
    self.connect-message-client($!ss, 'request-aborted');
  }

  # Is originally:
  # SoupServer, SoupMessage, SoupClientContext, gpointer --> void
  method request-finished {
    self.connect-message-client($!ss, 'request-finished');
  }

  # Is originally:
  # SoupServer, SoupMessage, SoupClientContext, gpointer --> void
  method request-read {
    self.connect-message-client($!ss, 'request-read');
  }

  # Is originally:
  # SoupServer, SoupMessage, SoupClientContext, gpointer --> void
  method request-started {
    self.connect-message-client($!ss, 'request-started');
  }

  method accept_iostream (
    GIOStream() $stream,
    GSocketAddress() $local_addr,
    GSocketAddress() $remote_addr  = GSocketAddress,
    CArray[Pointer[GError]] $error = gerror
  ) {
    clear_error;
    my $rv = so soup_server_accept_iostream(
      $!ss,
      $stream,
      $local_addr,
      $remote_addr,
      $error = gerror
    );
    set_error($error);
    $rv;
  }

  method add_auth_domain (SoupAuthDomain() $auth_domain) {
    soup_server_add_auth_domain($!ss, $auth_domain);
  }

  method add_early_handler (
    Str() $path,
    &callback,
    gpointer $user_data     = gpointer,
    GDestroyNotify $destroy = GDestroyNotify
  ) {
    soup_server_add_early_handler($!ss, $path, &callback, $user_data, $destroy);
  }

  method add_handler (
    Str() $path,
    &callback,
    gpointer $user_data     = gpointer,
    GDestroyNotify $destroy = GDestroyNotify
  ) {
    soup_server_add_handler($!ss, $path, &callback, $user_data, $destroy);
  }

  method add_websocket_extension (GType $extension_type) {
    soup_server_add_websocket_extension($!ss, $extension_type);
  }

  method add_websocket_handler (
    Str() $path,
    Str() $origin,
    Str() $protocols,
    &callback,
    gpointer $user_data     = gpointer,
    GDestroyNotify $destroy = GDestroyNotify
  ) {
    soup_server_add_websocket_handler(
      $!ss,
      $path,
      $origin,
      $protocols,
      &callback,
      $user_data,
      $destroy
    );
  }

  method disconnect {
    soup_server_disconnect($!ss);
  }

  method get_async_context (:$raw = False) is DEPRECATED {
    my $mc = soup_server_get_async_context($!ss);

    $mc ??
      ( $raw ?? $mc !! GLib::MainContext.new($mc) )
      !!
      Nil;
  }

  method get_listener (:$raw = False)
   is DEPRECATED<get_listeners>
  {
    my $s = soup_server_get_listener($!ss);

    $s ??
      ( $raw ?? $s !! SOUP::Socket.new($s) )
      !!
      Nil;
  }

  method get_listeners (:$glist = False, :$raw = False){
    my $sl = soup_server_get_listeners($!ss);

    return Nil unless $sl;
    return $sl if $glist && $raw;

    $sl = GLib::GList.new($sl) but GLib::Roles::ListData[GSocket];
    return $sl if $glist;

    $raw ?? $sl.Array !! $sl.map({ GIO::Socket.new($_) });
  }

  method get_port {
    soup_server_get_port($!ss);
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_server_get_type, $n, $t );
  }

  method get_uris (:$glist = False, :$raw = False) {
    my $ul = soup_server_get_uris($!ss);

    return Nil unless $ul;
    return $ul if $glist && $raw;

    $ul = GLib::GList.new($ul) but GLib::Roles::ListData[SoupURI];
    return $ul if $glist;

    $raw ?? $ul.Array !! $ul.map({ SOUP::URI.new($_) });
  }

  method is_https {
    so soup_server_is_https($!ss);
  }

  method listen (
    GSocketAddress() $address,
    Int() $options,
    CArray[Pointer[GError]] $error = gerror
  ) {
    my SoupServerListenOptions $o = $options;

    soup_server_listen($!ss, $address, $o, $error);
  }

  method listen_all (
    Int() $port,
    Int() $options,
    CArray[Pointer[GError]] $error = gerror
  ) {
    my guint $p = $port;
    my SoupServerListenOptions $o = $options;

    soup_server_listen_all($!ss, $p, $options, $error);
  }

  method listen_fd (
    Int() $fd,
    Int() $options,
    CArray[Pointer[GError]] $error = gerror
  ) {
    my gint $f = $fd;
    my SoupServerListenOptions $o = $options;

    soup_server_listen_fd($!ss, $f, $o, $error);
  }

  method listen_local (
    Int() $port,
    Int() $options,
    CArray[Pointer[GError]] $error = gerror
  ) {
    my guint $p = $port;
    my SoupServerListenOptions $o = $options;

    soup_server_listen_local($!ss, $p, $o, $error);
  }

  method listen_socket (
    GSocket() $socket,
    Int() $options,
    CArray[Pointer[GError]] $error = gerror
  ) {
    my SoupServerListenOptions $o = $options;

    soup_server_listen_socket($!ss, $socket, $o, $error);
  }

  method pause_message (SoupMessage() $msg) {
    soup_server_pause_message($!ss, $msg);
  }

  method quit
   is DEPRECATED<the 'listen'-based methods>
  {
    soup_server_quit($!ss);
  }

  method remove_auth_domain (SoupAuthDomain() $auth_domain) {
    soup_server_remove_auth_domain($!ss, $auth_domain);
  }

  method remove_handler (Str() $path) {
    soup_server_remove_handler($!ss, $path);
  }

  method remove_websocket_extension (Int() $extension_type;) {
    my GType $e = $extension_type;

    soup_server_remove_websocket_extension($!ss, $e);
  }

  method run
   is DEPRECATED<the 'listen'-based methods>
  {
    soup_server_run($!ss);
  }

  method run_async
   is DEPRECATED<the 'listen'-based methods>
  {
    soup_server_run_async($!ss);
  }

  method set_ssl_cert_file (
    Str() $ssl_cert_file,
    Str() $ssl_key_file,
    CArray[Pointer[GError]] $error = gerror
  ) {
    clear_error;
    my $rv = so soup_server_set_ssl_cert_file(
      $!ss,
      $ssl_cert_file,
      $ssl_key_file,
      $error = gerror
    );
    set_error($error);
    $rv;
  }

  method unpause_message (SoupMessage() $msg) {
    soup_server_unpause_message($!ss, $msg);
  }

}
