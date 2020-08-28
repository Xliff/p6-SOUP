use v6.c;

use Method::Also;

use NativeCall;

use SOUP::Raw::Types;
use SOUP::Raw::Socket;

use GLib::Value;
use GIO::TlsCertificate;
use SOUP::Address;

use GLib::Roles::Object;
use GIO::Roles::Initable;

our subset SoupSocketAncestry is export of Mu
  where SoupSocket | GInitable | GObject;

class SOUP::Socket {
  also does GLib::Roles::Object;
  also does GIO::Roles::Initable;

  has SoupSocket $!sock is implementor;
  has $!init = False;

  submethod BUILD (:$socket) {
    self.setSoupSocket($socket) if $socket;
  }

  method setSoupSocket (SoupSocketAncestry $_) {
    my $to-parent;

    $!sock = do {
      when SoupSocket {
        $to-parent = cast(GObject, $_);
        $_;
      }

      when GInitable {
        $!i = $_;
        $to-parent = cast(GObject, $_);
        cast(SoupSocket, $_);
      }

      default {
        $to-parent = $_;
        cast(SoupSocket, $_);
      }
    }

    self!setObject($to-parent);
    self.roleInit-Initable unless $!i;
  }

  method SOUP::Raw::Definitions::SoupSocket
    is also<SoupSocket>
  { $!sock }

  multi method new (SoupSocketAncestry $socket) {
    $socket ?? self.bless( :$socket ) !! Nil;
  }
  multi method new (*%options) {
    # cw: This constructor ALL CONSTRUCT-ONLY ATTRIBUTES at construction time.
    samewith(
      'async-context'      , [//]( |%options<async-context async_context>,
                                   GMainContext ),
      'local-address'      , [//]( |%options<local-address local_address>,
                                   SoupAddress ),
      'remote-address'     , [//]( |%options<remote-address remote_address>,
                                   SoupAddress ),
      'ssl-fallback'       , [//]( |%options<ssl-fallback ssl_fallback>,
                                   False ),
      'ssl-strict'         , [//]( |%options<ssl-strict ssl_strict>,
                                   False ),
      'use-thread-context' , [//]( |%options<
                                      use-thread-context
                                      use_thread_context
                                   >,
                                   False )
    );
  }
  # cw: PLEASE USE THE ABOVE multi. This constructor IS NOT INTENDED TO BE
  #     CLIENT FACING!
  multi method new(
    'async-context',        GMainContext()    $async-context,
    'local-address',        SoupAddress()     $local-addr,
    'remote-address',       SoupAddress()     $remote-addr,
    'ssl-fallback',         Int()             $fallback,
    'ssl-strict',           Int()             $strict,
    'use-thread-context',   Int()             $use-thread-context
  ) {
    my $socket = soup_socket_new(
      'async-context'     , $async-context // GMainContext,
      'local-address'     , $local-addr    // SoupAddress,
      'remote-address'    , $remote-addr   // SoupAddress,
      'ssl-fallback'      , $fallback.so.Int,
      'ssl-strict'        , $strict.so.Int,
      'use-thread-context', $use-thread-context.so.Int,
      Str
    );

    $socket = $socket ?? self.bless( :$socket ) !! Nil;
  }

  # Type: gpointer
  method async-context (:$raw = False) is rw  is also<async_context> {
    my $gv = GLib::Value.new( G_TYPE_POINTER );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('async-context', $gv)
        );

        my $o = $gv.pointer;
        return Nil unless $o;

        $o = cast(GMainContext, $gv.pointer);
        return $o if $raw;

        GLib::MainContext.new($o)
      },
      STORE => -> $, $val is copy {
        warn 'async-context is a construct-only attribute'
      }
    );
  }

  # Type: gint
  method fd is rw  {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('fd', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        warn 'fd is a construct-only attribute'
      }
    );
  }

  # Type: gboolean
  method ipv6-only is rw  is also<ipv6_only> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('ipv6-only', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('ipv6-only', $gv);
      }
    );
  }

  # Type: gboolean
  method is-server is rw  is also<is_server> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('is-server', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        warn 'is-server does not allow writing'
      }
    );
  }

  # Type: SoupAddress
  method local-address (:$raw = False) is rw  is also<local_address> {
    my $gv = GLib::Value.new( SOUP::Address.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('local-address', $gv)
        );

        my $o = $gv.object;

        say "O: { $o // 'UNDEF'}";
        return Nil unless $o;

        $o = cast(SoupAddress, $o);
        return $o if $raw;

        SOUP::Address.new($o);
      },
      STORE => sub ($, SoupAddress() $val is copy) {
        if $!init {
          warn 'local-address is a construct-only attribute';
          return;
        }
        $gv.pointer = $val;
        self.prop_set('local-address', $gv);
      }
    );
  }

  # Type: gboolean
  method non-blocking is rw  is also<non_blocking> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('non-blocking', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('non-blocking', $gv);
      }
    );
  }

  # Type: SoupAddress
  method remote-address (:$raw = False) is rw  is also<remote_address> {
    my $gv = GLib::Value.new( SOUP::Address.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('remote-address', $gv)
        );

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(SoupAddress, $o);
        return $o if $raw;

        SOUP::Address.new($o);
      },
      STORE => -> $, $val is copy {
        warn 'remote-address is a construct-only attribute'
      }
    );
  }

  # Type: SoupSocketProperties
  #
  # cw: Not a part of the public interface?!
  #
  # method socket-properties is rw  {
  #   my $gv = GLib::Value.new( -type- );
  #   Proxy.new(
  #     FETCH => sub ($) {
  #       warn 'socket-properties does not allow reading' if $DEBUG;
  #       0;
  #     },
  #     STORE => -> $,  $val is copy {
  #       #$gv.TYPE = $val;
  #       self.prop_set('socket-properties', $gv);
  #     }
  #   );
  # }

  # Type: gpointer
  method ssl-creds is rw  is also<ssl_creds> {
    my $gv = GLib::Value.new( G_TYPE_POINTER );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('ssl-creds', $gv)
        );
        $gv.pointer
      },
      STORE => -> $, gpointer $val is copy {
        $gv.pointer = $val;
        self.prop_set('ssl-creds', $gv);
      }
    );
  }

  # Type: gboolean
  method ssl-fallback is rw  is also<ssl_fallback> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('ssl-fallback', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        warn 'ssl-fallback is a construct-only attribute'
      }
    );
  }

  # Type: gboolean
  method ssl-strict is rw  is also<ssl_strict> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('ssl-strict', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        warn 'ssl-strict is a construct-only attribute'
      }
    );
  }

  # Type: guint
  method timeout is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('timeout', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('timeout', $gv);
      }
    );
  }

  # Type: GTlsCertificate
  method tls-certificate (:$raw = False) is rw  is also<tls_certificate> {
    my $gv = GLib::Value.new( GIO::GTlsCertificate.get-type );
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
      STORE => -> $,  $val is copy {
        warn 'tls-certificate does not allow writing'
      }
    );
  }

  # Type: GTlsCertificateFlags
  method tls-errors is rw  is also<tls_errors> {
    my $gv = GLib::Value.new( GLib::Value.typeFromEnum(GTlsCertificateFlags) );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('tls-errors', $gv)
        );
        $gv.valueFromEnum(GTlsCertificateFlags);
      },
      STORE => -> $,  $val is copy {
        warn 'tls-errors does not allow writing'
      }
    );
  }

  # Type: gboolean
  method trusted-certificate is rw  is also<trusted_certificate> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('trusted-certificate', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        warn 'trusted-certificate does not allow writing'
      }
    );
  }

  # Type: gboolean
  method use-thread-context is rw  is also<use_thread_context> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('use-thread-context', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        warn 'use-thread-context is a construct-only attribute'
      }
    );
  }

  # Is originally:
  # SoupSocket, gpointer --> void
  method disconnected {
    self.connect($!sock, 'disconnected');
  }

  # Is originally:
  # SoupSocket, GSocketClientEvent, GIOStream, gpointer --> void
  method event {
    self.connect-event($!sock);
  }

  # Is originally:
  # SoupSocket, SoupSocket, gpointer --> void
  method new-connection is also<new_connection> {
    self.connect-socket($!sock, 'new-connection');
  }

  # Is originally:
  # SoupSocket, gpointer --> void
  method readable {
    self.connect($!sock, 'readable');
  }

  # Is originally:
  # SoupSocket, gpointer --> void
  method writable {
    self.connect($!sock, 'writable');
  }

  proto method connect_async (|)
      is also<connect-async>
  { * }

  multi method connect_async (
    &callback,
    gpointer $user_data         = gpointer,
    GCancellable() $cancellable = GCancellable
  ) {
    samewith($cancellable, &callback, $user_data);
  }
  multi method connect_async (
    GCancellable() $cancellable,
    &callback,
    gpointer $user_data = gpointer
  ) {
    soup_socket_connect_async($!sock, $cancellable, &callback, $user_data);
  }

  method connect_sync (GCancellable() $cancellable = GCancellable)
    is also<connect-sync>
  {
    soup_socket_connect_sync($!sock, $cancellable);
  }

  method disconnect {
    soup_socket_disconnect($!sock);
  }

  method get_fd is also<get-fd> {
    soup_socket_get_fd($!sock);
  }

  method get_local_address (:$raw = False) is also<get-local-address> {
    my $a = soup_socket_get_local_address($!sock);

    $a ??
      ( $raw ?? $a !! SOUP::Address.new($a) )
      !!
      Nil;
  }

  method get_remote_address (:$raw = False) is also<get-remote-address> {
    my $a = soup_socket_get_remote_address($!sock);

    $a ??
      ( $raw ?? $a !! SOUP::Address.new($a) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_socket_get_type, $n, $t );
  }

  method is_connected is also<is-connected> {
    so soup_socket_is_connected($!sock);
  }

  method is_ssl is also<is-ssl> {
    so soup_socket_is_ssl($!sock);
  }

  method listen {
    so soup_socket_listen($!sock);
  }

  multi method read (
    Str $buffer,
    GCancellable() $cancellable    = GCancellable,
    CArray[Pointer[GError]] $error = gerror,
    :$all                          = True
  ) {
    samewith($buffer.encode, $cancellable, $error, :$all);
  }
  multi method read (
    Buf $buffer,
    GCancellable() $cancellable    = GCancellable,
    CArray[Pointer[GError]] $error = gerror,
    :$all                          = True
  ) {
    samewith(
      CArray[uint8].new($buffer),
      $buffer.elems,
      $cancellable,
      $error,
      :$all
    );
  }
  multi method read (
    CArray[uint8] $buffer,
    Int() $length                  = -1,
    GCancellable() $cancellable    = GCancellable,
    CArray[Pointer[GError]] $error = gerror,
    :$all                          = True,
  ) {
    my $l = $length >= 0 ?? $length !! $buffer.elems;
    samewith(
      cast(Pointer, $buffer),
      $l,
      $,
      $cancellable,
      $error,
      :$all
    );
  }
  multi method read (
    gpointer $buffer,
    Int() $len,
    $nread is rw,
    GCancellable() $cancellable    = GCancellable,
    CArray[Pointer[GError]] $error = gerror,
    :$all                          = False
  ) {
    my gsize ($l, $n) = ($len, 0);

    clear_error;
    my $rv = SoupSocketIOStatus(
      soup_socket_read($!sock, $buffer, $l, $n, $cancellable, $error)
    );
    set_error($error);
    $nread = $n;
    $all.not ?? $rv !! ($rv, $nread);
  }

  sub handlePotentialBuffer($_) {
    when Array | Buf      { CArray[uint8].new($_); proceed }

    when CArray[uint8]    { cast(Pointer, $_)              }

    default {
      die "Do not know how to handle { .^name } as a buffer!";
    }
  }

  proto method read_until (|)
    is also<read-until>
  { * }

  multi method read_until (
    Str() $buffer,
    Str() $boundary,
    GCancellable() $cancellable    = GCancellable,
    CArray[Pointer[GError]] $error = gerror,
    :$all                          = False
  ) {
    samewith($buffer.encode, $boundary.encode, $cancellable, $error, :$all);
  }
  multi method read_until (
    @buffer,
    @boundary,
    GCancellable() $cancellable    = GCancellable,
    CArray[Pointer[GError]] $error = gerror,
    :$all                          = False
  ) {
    samewith(
      @buffer,
      @buffer.elems,
      @boundary,
      @boundary.elems,
      $,
      $,
      $cancellable,
      $error,
      :$all
    );
  }
  multi method read_until (
    Buf $buffer,
    Buf $boundary,
    GCancellable() $cancellable    = GCancellable,
    CArray[Pointer[GError]] $error = gerror,
    :$all                          = False
  ) {
    samewith(
      $buffer,
      $buffer.elems,
      $boundary,
      $boundary.elems,
      $,
      $,
      $cancellable,
      $error,
      :$all
    );
  }
  multi method read_until (
    $buffer,
    Int() $len,
    $boundary,
    Int() $boundary_len,
    $nread                         is rw,
    $got_boundary                  is rw,
    GCancellable() $cancellable    = GCancellable,
    CArray[Pointer[GError]] $error = gerror,
    :$all                          = False
  ) {
    my gsize ($l, $bl, $n) = ($len, $boundary_len, 0);
    my gboolean $g = 0;
    my Pointer ($buf, $bnd) = ($buffer, $boundary)».&handlePotentialBuffer;

    clear_error;
    my $rv = SoupSocketIOStatus(
      soup_socket_read_until(
        $!sock,
        $buf,
        $l,
        $bnd,
        $boundary_len,
        $n,
        $g,
        $cancellable,
        $error
      )
    );
    set_error($error);
    ($nread, $got_boundary) = ($n, $g);
    $all.not ?? $rv !! ($rv, $nread, $got_boundary);
  }

  method start_proxy_ssl (
    Str() $ssl_host,
    GCancellable() $cancellable = GCancellable
  )
    is also<start-proxy-ssl>
  {
    so soup_socket_start_proxy_ssl($!sock, $ssl_host, $cancellable);
  }

  method start_ssl (GCancellable() $cancellable = GCancellable)
    is also<start-ssl>
  {
    so soup_socket_start_ssl($!sock, $cancellable);
  }

  multi method write (
    Str() $buffer,
    GCancellable() $cancellable    = GCancellable,
    CArray[Pointer[GError]] $error = gerror,
    :$all                          = True
  ) {
    samewith($buffer.encode, $cancellable, $error, :$all);
  }
  multi method write (
    @buffer,
    GCancellable() $cancellable    = GCancellable,
    CArray[Pointer[GError]] $error = gerror,
    :$all                          = True
  ) {
    samewith(
      CArray[uint8].new(@buffer),
      @buffer.elems,
      $,
      $cancellable,
      $error,
      :$all
    );
  }
  multi method write (
    Buf $buffer,
    GCancellable() $cancellable    = GCancellable,
    CArray[Pointer[GError]] $error = gerror,
    :$all                          = True
  ) {
    samewith(
      CArray[uint8].new($buffer),
      $buffer.elems,
      $,
      $cancellable,
      $error,
      :$all
    );
  }
  multi method write (
    CArray[uint8] $buffer,
    Int() $len,
    GCancellable() $cancellable    = GCancellable,
    CArray[Pointer[GError]] $error = gerror,
    :$all                          = True
  ) {
    samewith(
      cast(Pointer, $buffer),
      $len,
      $,
      $cancellable,
      $error,
      :$all
    );
  }
  multi method write (
    gpointer $buffer,
    Int() $len,
    $nwrote                        is rw,
    GCancellable() $cancellable    = GCancellable,
    CArray[Pointer[GError]] $error = gerror,
    :$all                          = False
  ) {
    my gsize ($l, $n) = ($l, 0);

    clear_error;
    my $rv = SoupSocketIOStatusEnum(
      soup_socket_write($!sock, $buffer, $l, $n, $cancellable, $error)
    );
    set_error($error);
    $nwrote = $n;
    $all.not ?? $rv !! ($rv, $nwrote);
  }
}
