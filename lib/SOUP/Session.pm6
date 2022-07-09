use v6.c;

use NativeCall;
use Method::Also;

use GLib::Raw::Traits;
use SOUP::Raw::Types;
use SOUP::Raw::Session;
use GLib::Raw::ExtendedTypes;

use GLib::Value;
use GIO::InputStream;
use GIO::Stream;
use SOUP::Address;
use SOUP::Request;
use SOUP::Request::HTTP;
use SOUP::WebsocketConnection;
use SOUP::URI;

use SOUP::Roles::SessionFeature;
use SOUP::Roles::Signals::Session;

our subset SoupSessionAncestry is export of Mu
  where SoupSession | GObject;

class SOUP::Session {
  also does GLib::Roles::Object;
  also does SOUP::Roles::Signals::Session;

  has SoupSession $!ss is implementor;

  submethod BUILD (:$session) {
    self.setSoupSession($session) if $session;
  }

  method setSoupSession (SoupSessionAncestry $_) {
    my $to-parent;

    $!ss = do {
      when SoupSession {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(SoupSession, $_);
      }
    }
    # cw: This is the old way, but we save a potential cast.
    self!setObject($to-parent);
  }

  method SOUP::Raw::Definitions::SoupSession
   is also<SoupSession>
  { $!ss }

  multi method new (SoupSessionAncestry $session) {
    $session ?? self.bless( :$session ) !! Nil;
  }
  multi method new {
    my $session = soup_session_new();

    $session ?? self.bless( :$session ) !! Nil;
  }

  proto method new_with_options (|)
    is also<new-with-options>
  { * }

  multi method new_with_options (@options) {
    samewith(|@options);
  }
  multi method new_with_options (*@options) {
    my %options;
    for @options.rotor(2) {
      %options{ .[0] } = .[1];
    }
    SOUP::Session.new_with_options(|%options);
  }
  multi method new_with_options (%options) {
    samewith(|%options);
  }
  multi method new_with_options (*%options) {
    my %real-opts = %options.clone;

    # Handle use of constants as key.
    %real-opts{ ::("$_") } = %real-opts{$_}:delete
      for %real-opts.keys.grep( *.starts-with('SOUP_SESSION_') );

    # cw: Add more error checking options here!
    for <http-aliases http_aliases https-aliases https_aliases> {
      if %real-opts{$_} ~~ Positional {
        %real-opts{$_} = resolve-gstrv( %real-opts{$_} );
      } elsif %real-opts{$_} !~~ CArray[Str] {
        die "{$_} option must be a Str-Array compatible value!";
      }
    }

    # Defaults obtained from soup-session.c
    SOUP::Session.new(
      'accept-language',         %real-opts<accept-language>        // %real-opts<accept_language>         // Str,
      'accept-language-auto',    %real-opts<accept-language-auto>   // %real-opts<accept_language_auto>    // False,
      'add-feature',             %real-opts<add-feature>            // %real-opts<add_feature>             // SoupSessionFeature,
      'add-feature-by-type',     %real-opts<add-feature-by-type>    // %real-opts<add_feature_by_type>     // GObject;
      'async-context',           %real-opts<async-context>          // %real-opts<async_context>           // GMainContext,
      'http-aliases',            %real-opts<http-aliases>           // %real-opts<http_aliases>            // CArray[Str],
      'https-aliases',           %real-opts<https-aliases>          // %real-opts<https_aliases>           // CArray[Str],
      'idle-timeout',            %real-opts<idle-timeout>           // %real-opts<idle_timeout>            // 60,
      'local-address',           %real-opts<local-address>          // %real-opts><local_address>          // SoupAddress,
      'max-conns',               %real-opts<max-conns>              // %real-opts<max_conns>               // 1,
      'max-conns-per-host',      %real-opts<max-conns-per-host>     // %real-opts<max_conns_per_host>      // 1,
      'proxy-resolver',          %real-opts<proxy-resolver>         // %real-opts<proxy_resolver>          // GProxyResolver,
      'proxy-uri',               %real-opts<proxy-uri>              // %real-opts<proxy_uri>               // SoupURI,
      'remove-feature-by-type',  %real-opts<remove-feature-by-type> // %real-opts<remove_features_by_type> // GObject,
      'ssl-ca-file',             %real-opts<ssl-ca-file>            // %real-opts<ssl_ca_file>             // Str,
      'ssl-strict',              %real-opts<ssl-strict>             // %real-opts<ssl_strict>              // True,
      'ssl-use-system-ca-file',  %real-opts<ssl-use-system-ca-file> // %real-opts<ssl_use_system_ca_file>  // True,
      'timeout',                 %real-opts<timeout>                                                       // 0,
      'tls-database',            %real-opts<tls-database>           // %real-opts<tls_database>            // GTlsDatabase,
      'tls-interaction',         %real-opts<tls-interaction>        // %real-opts<tls_interaction>         // GTlsInteraction,
      'use-ntlm',                %real-opts<use-ntlm>               // %real-opts<use_ntlm>                // False,
      'use-thread-context',      %real-opts<use-thread-context>     // %real-opts<use_thread_context>      // False,
      'user-agent',              %real-opts<user-agent>             // %real-opts<user_agent>              // Str
    );
  }
  multi method new_with_options (
    'accept-language',         Str() $accept-language,
    'accept-language-auto',    Int() $accept-language-auto,
    'add-feature',             SoupSessionFeature() $add-feature,
    'add-feature-by-type',     GObject() $add-feature-by-type;
    'async-context',           GMainContext() $async-context,
    'http-aliases',            $http-aliases,
    'https-aliases',           $https-aliases,
    'idle-timeout',            Int() $idle-timeout,
    'local-address',           SoupAddress() $local-address,
    'max-conns',               Int() $max-conns,
    'max-conns-per-host',      Int() $max-conns-per-host,
    'proxy-resolver',          GProxyResolver() $proxy-resolver,
    'proxy-uri',               SoupURI() $proxy-uri,
    'remove-feature-by-type',  GObject() $remove-feature-by-type,
    'ssl-ca-file',             Str() $ssl-ca-file,
    'ssl-strict',              Int() $ssl-strict,
    'ssl-use-system-ca-file',  Int() $ssl-use-system-ca-file,
    'timeout',                 Int() $timeout,
    'tls-database',            GTlsDatabase() $tls-database,
    'tls-interaction',         GTlsInteraction() $tls-interaction,
    'use-ntlm',                Int() $use-ntlm,
    'use-thread-context',      Int() $use-thread-context,
    'user-agent',              Str() $user-agent
  ) {
    my $session = soup_session_new_with_options(
      'accept-language',        $accept-language,
      'accept-language-auto',   $accept-language-auto,
      'add-feature',            $add-feature,
      'add-feature-by-type',    $add-feature-by-type,
      'async-context',          $async-context,
      'http-aliases',           $http-aliases,
      'https-aliases',          $https-aliases,
      'idle-timeout',           $idle-timeout,
      'local-address',          $local-address,
      'max-conns',              $max-conns,
      'max-conns-per-host',     $max-conns-per-host,
      'proxy-resolver',         $proxy-resolver,
      'proxy-uri',              $proxy-uri,
      'remove-feature-by-type', $remove-feature-by-type,
      'ssl-ca-file',            $ssl-ca-file,
      'ssl-strict',             $ssl-strict,
      'ssl-use-system-ca-file', $ssl-use-system-ca-file,
      'timeout',                $timeout,
      'tls-database',           $tls-database,
      'tls-interaction',        $tls-interaction,
      'use-ntlm',               $use-ntlm,
      'use-thread-context',     $use-thread-context,
      'user-agent',             $user-agent
    );

    $session ?? self.bless( :$session ) !! Nil;
  }


  # Type: gchar
  method accept-language is rw is also<accept_language> {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('accept-language', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('accept-language', $gv);
      }
    );
  }

  # Type: gboolean
  method accept-language-auto is rw is also<accept_language_auto> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('accept-language-auto', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('accept-language-auto', $gv);
      }
    );
  }

  # Type: SoupSessionFeature
  method add-feature (:$raw = False) is rw is also<add_feature> {
    my $gv = GLib::Value.new(
      SOUP::Roles::SessionFeature.get_sessionfeaturea_type
    );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('add-feature', $gv)
        );

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(SoupSessionFeature, $o);
        return $o if $raw;

        SOUP::Roles::SessionFeature.new-sessionfeature-obj($o);
      },
      STORE => -> $, SoupSessionFeature() $val is copy {
        $gv.object = $val;
        self.prop_set('add-feature', $gv);
      }
    );
  }

  # Type: GType
  method add-feature-by-type is rw is also<add_feature_by_type> {
    my $gv = GLib::Value.new( GLib::Value.typeFromEnum(GTypeEnum) );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('add-feature-by-type', $gv)
        );
        $gv.valueFromEnum(GTypeEnum);
      },
      STORE => -> $, Int() $val is copy {
        $gv.valueFromEnum(GTypeEnum) = $val;
        self.prop_set('add-feature-by-type', $gv);
      }
    );
  }

  # Type: gpointer
  method async-context is rw is also<async_context> {
    my $gv = GLib::Value.new( G_TYPE_POINTER );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('async-context', $gv)
        );

        my $p = $gv.pointer;
        return Nil unless $p;

        $p;
      },
      STORE => -> $, $val is copy {
        warn 'async-context is a construct-only attribute'
      }
    );
  }

  # Type: GStrv
  method http-aliases (:$raw = False) is rw is also<http_aliases> {
    my $gv = GLib::Value.new( $G_TYPE_STRV );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('http-aliases', $gv)
        );

        my $sv = $gv.pointer;
        return Nil unless $sv;

        $sv = cast(CArray[Str], $gv.pointer);
        return $sv if $raw;

        CStringArrayToArray($sv);
      },
      STORE => -> $,  $val is copy {
        die 'Must .http-aliases will only accept GStrv-compatible values!'
          unless $val ~~ (Positional, CArray[Str]).any;

        $val = resolve-gstrv($val);

        $gv.pointer = cast(Pointer, $val);
        self.prop_set('http-aliases', $gv);
      }
    );
  }

  # Type: GStrv
  method https-aliases (:$raw = False) is rw is also<https_aliases> {
    my $gv = GLib::Value.new( $G_TYPE_STRV );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('https-aliases', $gv)
        );

        my $sv = $gv.pointer;
        return Nil unless $sv;

        $sv = cast(CArray[Str], $gv.pointer);
        return $sv if $raw;

        CStringArrayToArray($sv);
      },
      STORE => -> $, $val is copy {
        die 'Must .https-aliases will only accept GStrv-compatible values!'
          unless $val ~~ (Positional, CArray[Str]).any;

        $val = resolve-gstrv($val);

        $gv.pointer = cast(Pointer, $val);
        self.prop_set('https-aliases', $gv);
      }
    );
  }

  # Type: guint
  method idle-timeout is rw is also<idle_timeout> {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('idle-timeout', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('idle-timeout', $gv);
      }
    );
  }

  # Type: SoupAddress
  method local-address (:$raw = False) is rw is also<local_address> {
    my $gv = GLib::Value.new( SOUP::Address.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('local-address', $gv)
        );

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(SoupAddress, $o);
        return $o if $raw;

        SOUP::Address.new($o);
      },
      STORE => -> $,  $val is copy {
        warn 'local-address is a construct-only attribute'
      }
    );
  }

  # Type: gint
  method max-conns is rw is also<max_conns> {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('max-conns', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('max-conns', $gv);
      }
    );
  }

  # Type: gint
  method max-conns-per-host is rw is also<max_conns_per_host> {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('max-conns-per-host', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('max-conns-per-host', $gv);
      }
    );
  }

  # Type: GProxyResolver
  method proxy-resolver (:$raw = False) is rw is also<proxy_resolver> {
    my $gv = GLib::Value.new(
      GIO::Roles::ProxyResolver.get_proxyresolver_type
    );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('proxy-resolver', $gv)
        );

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(GProxyResolver, $o);
        return $o if $raw;

        GIO::Roles::ProxyResolver.new-proxyresolver-obj($o);
      },
      STORE => -> $, GProxyResolver() $val is copy {
        $gv.object = $val;
        self.prop_set('proxy-resolver', $gv);
      }
    );
  }

  # Type: SoupURI
  method proxy-uri (:$raw = False) is rw is also<proxy_uri> {
    my $gv = GLib::Value.new( SOUP::URI.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('proxy-uri', $gv)
        );

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(SoupURI, $o);
        return $o if $raw;

        SOUP::URI.new($o);
      },
      STORE => -> $, SoupURI() $val is copy {
        $gv.object = $val;
        self.prop_set('proxy-uri', $gv);
      }
    );
  }

  # Type: GType
  method remove-feature-by-type is rw is also<remove_feature_by_type> {
    my $gv = GLib::Value.new( GLib::Value.typeFromEnum(GTypeEnum) );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('remove-feature-by-type', $gv)
        );
        $gv.valueFromEnum(GTypeEnum);
      },
      STORE => -> $, Int() $val is copy {
        $gv.valueFromEnum(GTypeEnum) = $val;
        self.prop_set('remove-feature-by-type', $gv);
      }
    );
  }

  # Type: gchar
  method ssl-ca-file is rw is DEPRECATED is also<ssl_ca_file> {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('ssl-ca-file', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('ssl-ca-file', $gv);
      }
    );
  }

  # Type: gboolean
  method ssl-strict is rw is also<ssl_strict> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('ssl-strict', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('ssl-strict', $gv);
      }
    );
  }

  # Type: gboolean
  method ssl-use-system-ca-file is rw is also<ssl_use_system_ca_file> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('ssl-use-system-ca-file', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('ssl-use-system-ca-file', $gv);
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

  # Type: GTlsDatabase
  method tls-database (:$raw = False) is rw is also<tls_database> {
    my $gv = GLib::Value.new( GIO::TlsDatabase.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('tls-database', $gv)
        );

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(GTlsDatabase, $o);
        return $o if $raw;

        GIO::TlsDatabase.new($o);
      },
      STORE => -> $, GTlsDatabase() $val is copy {
        $gv.object = $val;
        self.prop_set('tls-database', $gv);
      }
    );
  }

  # Type: GTlsInteraction
  method tls-interaction (:$raw = False) is rw is also<tls_interaction> {
    my $gv = GLib::Value.new( GIO::GTlsInteraction.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('tls-interaction', $gv)
        );

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(GTlsInteraction, $o);
        return $o if $raw;

        GIO::TlsInteraction.new($o);
      },
      STORE => -> $, GTlsInteraction() $val is copy {
        $gv.object = $val;
        self.prop_set('tls-interaction', $gv);
      }
    );
  }

  # Type: gboolean
  method use-ntlm is rw is DEPRECATED is also<use_ntlm> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('use-ntlm', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('use-ntlm', $gv);
      }
    );
  }

  # Type: gboolean
  method use-thread-context is rw is also<use_thread_context> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('use-thread-context', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('use-thread-context', $gv);
      }
    );
  }

  # Type: gchar
  method user-agent is rw is also<user_agent> {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('user-agent', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('user-agent', $gv);
      }
    );
  }

  # Is originally:
  # SoupSession, SoupMessage, SoupAuth, gboolean, gpointer --> void
  method authenticate {
    self.connect-authenticate($!ss);
  }

  # Is originally:
  # SoupSession, GObject, gpointer --> void
  method connection-created is also<connection_created> {
    self.connect-object($!ss, 'connection-created');
  }

  # Is originally:
  # SoupSession, SoupMessage, gpointer --> void
  method request-queued is also<request_queued> {
    self.connect-request-queue($!ss, 'request-queued');
  }

  # Is originally:
  # SoupSession, SoupMessage, SoupSocket, gpointer --> void
  method request-started is also<request_started> {
    self.connect-request-started($!ss);
  }

  # Is originally:
  # SoupSession, SoupMessage, gpointer --> void
  method request-unqueued is also<request_unqueued> {
    self.connect-request-queue($!ss, 'request-unqueued');
  }

  # Is originally:
  # SoupSession, GObject, gpointer --> void
  method tunneling {
    self.connect-object($!ss, 'tunneling');
  }

  method abort {
    soup_session_abort($!ss);
  }

  method do_add_feature (SoupSessionFeature() $feature)
    is also<do-add-feature>
  {
    soup_session_add_feature($!ss, $feature);
  }

  method do_add_feature_by_type (Int() $feature_type)
    is also<do-add-feature-by-type>
  {
    my GType $f = $feature_type;

    soup_session_add_feature_by_type($!ss, $f);
  }

  method cancel_message (SoupMessage $msg, guint $status_code)
    is also<cancel-message>
  {
    soup_session_cancel_message($!ss, $msg, $status_code);
  }

  # method connect_async (
  #   SoupURI() $uri,
  #   GCancellable() $cancellable,
  #   &progress_callback,
  #   &callback,
  #   gpointer $user_data
  # ) {
  #   soup_session_connect_async(
  #     $!ss,
  #     $uri,
  #     $cancellable,
  #     &progress_callback,
  #     &callback,
  #     $user_data
  #   );
  # }

  # method connect_finish (
  #   GAsyncResult() $result,
  #   CArray[Pointer[GError]] $error = gerror
  # ) {
  #   clear_error
  #   soup_session_connect_finish($!ss, $result, $error);
  # }

  method get_async_context (:$raw = False) is also<get-async-context> {
    my $c = soup_session_get_async_context($!ss);

    $c ??
      ( $raw ?? $c !! GLib::MainContext.new($c) )
      !!
      Nil;
  }

  method get_feature (Int() $feature_type) is also<get-feature> {
    my GType $f = $feature_type;

    soup_session_get_feature($!ss, $f);
  }

  method get_feature_for_message (Int() $feature_type, SoupMessage() $msg)
    is also<get-feature-for-message>
  {
    my GType $f = $feature_type;

    # No object representation due to lack of methods.
    soup_session_get_feature_for_message($!ss, $f, $msg);
  }

  method get_features (Int() $feature_type, :$glist = False, :$raw = False)
    is also<get-features>
  {
    my GType $f = $feature_type;
    my $fl = soup_session_get_features($!ss, $feature_type);

    return Nil unless $fl;
    return $fl if $glist && $raw;

    # cw: Use GList until GSList is fixed!
    $fl = GLib::GList.new($fl) but GLib::Roles::ListData[SoupSessionFeature];
    return $fl if $glist;

    # No object representation due to lack of methods.
    $fl.Array;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_session_get_type, $n, $t );
  }

  method has_feature (Int() $feature_type) is also<has-feature> {
    my GType $f = $feature_type;

    so soup_session_has_feature($!ss, $f);
  }

  method pause_message (SoupMessage() $msg) is also<pause-message> {
    soup_session_pause_message($!ss, $msg);
  }

  proto method prefetch_dns (|)
     is also<prefetch-dns>
  { * }

  multi method prefetch_dns (
    Str()          $hostname,
                   &callback,
    gpointer       $user_data   = gpointer,
    GCancellable() $cancellable = GCancellable
  ) {
    samewith($hostname, $cancellable, &callback, $user_data);
  }
  multi method prefetch_dns (
    Str()          $hostname,
    GCancellable() $cancellable,
                   &callback,
    gpointer       $user_data    = gpointer
  ) {
    soup_session_prefetch_dns(
      $!ss,
      $hostname,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method prepare_for_uri (SoupURI() $uri)
    is DEPRECATED<prefetch_dns>
    is also<prepare-for-uri>
  {
    soup_session_prepare_for_uri($!ss, $uri);
  }

  method queue_message (
    SoupMessage() $msg,
                  &callback,
    gpointer      $user_data = gpointer
  )
    is also<queue-message>
  {
    soup_session_queue_message($!ss, $msg, &callback, $user_data);
  }

  method redirect_message (SoupMessage() $msg) is also<redirect-message> {
    so soup_session_redirect_message($!ss, $msg);
  }

  method do_remove_feature (SoupSessionFeature() $feature)
    is also<do-remove-feature>
  {
    soup_session_remove_feature($!ss, $feature);
  }

  method do_remove_feature_by_type (Int() $feature_type)
    is also<do-remove-feature-by-type>
  {
    my GType $ft = $feature_type;

    soup_session_remove_feature_by_type($!ss, $ft);
  }

  method request (
    Str() $uri_string,
    CArray[Pointer[GError]] $error = gerror,
    :$raw = False
  ) {
    clear_error;
    my $r = soup_session_request($!ss, $uri_string, $error);
    set_error($error);

    $r ??
      ( $raw ?? $r !! SOUP::Request.new($r) )
      !!
      Nil;
  }

  method request_http (
    Str() $method,
    Str() $uri_string,
    CArray[Pointer[GError]] $error = gerror,
    :$raw = False
  )
    is also<request-http>
  {
    clear_error;
    my $r = soup_session_request_http($!ss, $method, $uri_string, $error);
    set_error($error);

    $r ??
      ( $raw ?? $r !! SOUP::Request::HTTP.new($r) )
      !!
      Nil;
  }

  method request_http_uri (
    Str() $method,
    SoupURI() $uri,
    CArray[Pointer[GError]] $error = gerror,
    :$raw = False
  )
    is also<request-http-uri>
  {
    clear_error;
    my $r = soup_session_request_http_uri($!ss, $method, $uri, $error);
    set_error($error);

    $r ??
      ( $raw ?? $r !! SOUP::Request::HTTP.new($r) )
      !!
      Nil;
  }

  method request_uri (
    SoupURI() $uri,
    CArray[Pointer[GError]] $error,
    :$raw = False
  )
    is also<request-uri>
  {
    clear_error;
    my $r = soup_session_request_uri($!ss, $uri, $error);
    set_error($error);

    $r ??
      ( $raw ?? $r !! SOUP::Request.new($r) )
      !!
      Nil;
  }

  method requeue_message (SoupMessage() $msg) is also<requeue-message> {
    soup_session_requeue_message($!ss, $msg);
  }

  method send (
    SoupMessage()            $msg,
    GCancellable()           $cancellable = GCancellable,
    CArray[Pointer[GError]]  $error       = gerror,
                            :$raw = False
  ) {
    clear_error;
    my $is = soup_session_send($!ss, $msg, $cancellable, $error);
    set_error($error);

    propReturnObject($is, $raw, |GIO::InputStream.getTypePair);
  }

  proto method send_async (|)
     is also<send-async>
  { * }

  multi method send_async (
    SoupMessage() $msg,
    &callback,
    gpointer $user_data         = gpointer,
    GCancellable() $cancellable = GCancellable
  ) {
    samewith($msg, $cancellable, &callback, $user_data);
  }
  multi method send_async (
    SoupMessage()  $msg,
    GCancellable() $cancellable,
                   &callback,
    gpointer       $user_data    = gpointer
  ) {
    soup_session_send_async($!ss, $msg, $cancellable, &callback, $user_data);
  }

  method send_finish (
    GAsyncResult()           $result,
    CArray[Pointer[GError]]  $error   = gerror,
                            :$raw     = False
  )
    is also<send-finish>
  {
    clear_error;
    my $is = soup_session_send_finish($!ss, $result, $error);
    set_error($error);

    propReturnObject($raw, $is, |GIO::InputStream.getTypePair);
  }

  method send_message (SoupMessage() $msg) is also<send-message> {
    soup_session_send_message($!ss, $msg);
  }

  method soup_request_error_quark
    is static
    is also<soup-request-error-quark>
  {
    soup_request_error_quark();
  }

  method steal_connection (SoupMessage() $msg, :$raw = False)
    is also<steal-connection>
  {
    my $ios = soup_session_steal_connection($!ss, $msg);

    $ios ??
      ( $raw ?? $ios !! GIO::Stream.new($ios) )
      !!
      Nil;
  }

  method unpause_message (SoupMessage() $msg) is also<unpause-message> {
    soup_session_unpause_message($!ss, $msg);
  }

  proto method websocket_connect_async (|)
     is also<websocket-connect-async>
  { * }

  multi method websocket_connect_async (
    SoupMessage()  $msg,
    Str()          $origin,
    Str()          $protocols,
                   &callback,
    gpointer       $user_data   = gpointer,
    GCancellable() $cancellable = GCancellable
  ) {
    samewith($msg, $origin, $protocols, $cancellable, &callback, $user_data);
  }
  multi method websocket_connect_async (
    SoupMessage()  $msg,
    Str()          $origin,
    Str()          $protocols,
    GCancellable() $cancellable,
                   &callback,
    gpointer       $user_data    = gpointer
  ) {
    soup_session_websocket_connect_async(
      $!ss,
      $msg,
      $origin,
      $protocols,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method websocket_connect_finish (
    GAsyncResult()           $result,
    CArray[Pointer[GError]]  $error   = gerror,
                            :$raw     = False
  )
    is also<websocket-connect-finish>
  {
    clear_error;
    my $wsc = soup_session_websocket_connect_finish($!ss, $result, $error);
    set_error($error);

    $wsc ??
      ( $raw ?? $wsc !! SOUP::WebsocketConnection.new($wsc) )
      !!
      Nil;
  }

  method would_redirect (SoupMessage() $msg) is also<would-redirect> {
    so soup_session_would_redirect($!ss, $msg);
  }

}
