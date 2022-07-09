use v6.c;

use NativeCall;
use Method::Also;

use SOUP::Raw::Types;
use SOUP::Raw::Test;
use GIO::Raw::TlsBackend;

use GLib::Env;
use GLib::Cond;
use GLib::Mutex;
use GLib::Source;
use GLib::Utils;
use SOUP::Buffer;
use SOUP::Server;
use SOUP::Session;

use GLib::Roles::StaticClass;

class SOUP::Test {
  has $.tls-backend;
  has $.tls-available;

  also does GLib::Roles::StaticClass;

  method apache_cleanup is also<apache-cleanup> {
    apache_cleanup();
  }

  method apache_init is also<apache-init> {
    apache_init();
  }

  method check_apache is also<check-apache> {
    check_apache();
  }

  method debug_printf (Int() $level, Str $message) is also<debug-printf> {
    my gint $l = $level;

    debug_printf($l, $message, Str);
  }

  # method assert (gboolean $expr, Str $fmt, ...) {
  #   soup_test_assert($expr, $fmt);
  # }

  method cleanup {
    test_cleanup();
  }

  method get_index (:$raw = False) is also<get-index> {
    my $b = soup_test_get_index();

    $b ??
      ( $raw ?? $b !! SOUP::Buffer.new($b) )
      !!
      Nil;
  }

  method init {
    GLib::Env.set(True,
      G_SETTINGS_BACKEND     => 'memory',
      GIO_USE_PROXY_RESOLVER => 'dummy',
      GIO_USE_VFS            => 'local'
    );

    # cw: Currently unused.
    # g_test_init (&argc, &argv, NULL);
    # g_test_set_nonfatal_assertions ();
    # g_test_bug_base ("https://bugzilla.gnome.org/");

    GLib::Utils.set-prgname($*PROGRAM.basename);
    $!tls-backend   = g_tls_backend_get_default();
    $!tls-available = g_tls_backend_supports_tls($!tls-backend);
  }

  method load_resource (
    Str() $name,
    CArray[Pointer[GError]] $error = gerror,
    :$raw = False
  )
    is also<load-resource>
  {
    clear_error;
    my $b = soup_test_load_resource($name, $error);
    set_error($error);

    $b ??
      ( $raw ?? $b !! SOUP::Buffer.new($b) )
      !!
      Nil;
  }

  method register_resources is also<register-resources> {
    soup_test_register_resources();
  }

}

class SOUP::Test::Request is SOUP::Request {

  method close_stream (
    GInputStream() $stream,
    GCancellable() $cancellable    = GCancellable,
    CArray[Pointer[GError]] $error = gerror
  )
    is also<close-stream>
  {
    clear_error;
    my $rv = so soup_test_request_close_stream(
      self.SoupRequest,
      $stream,
      $cancellable,
      $error
    );
    set_error($error);
    $rv;
  }

  method read_all (
    GInputStream() $stream,
    GCancellable() $cancellable    = GCancellable,
    CArray[Pointer[GError]] $error = gerror
  )
    is also<read-all>
  {
    clear_error;
    my $rv = soup_test_request_read_all($stream, $cancellable, $error);
    set_error($error);
    $rv;
  }

  proto method send (|)
  { * }

  multi method send (
    Int() $flags,
    CArray[Pointer[GError]] $error = gerror
  ) {
    samewith(GCancellable, $flags, $error);
  }
  multi method send (
    GCancellable() $cancellable,
    Int() $flags,
    CArray[Pointer[GError]] $error = gerror
  ) {
    my gint $f = $flags;

    soup_test_request_send(self.SoupRequest, $cancellable, $f, $error);
  }

}

class SOUP::Test::Server is SOUP::Server {
  has $!server;
  has $!server-start-mutex;
  has $!server-start-cond;

  my $server-start-mutex = GLib::Mutex.new;
  my $server-start-cond  = GLib::Cond.new;

  sub server-listen ($server) {
    $server.listen_local;
    if $ERROR {
      $*ERR.say: "Unable to create server: { $ERROR.message }";
      exit 1;
    }
  }

  sub run-server-thread ($server) {
    my $options = $server.get-data('options');

    my $context = GLib::MainContext.new;
    $context.push_thread_default;
    my $loop = GLib::MainLoop.new($context);
    $server.set-data('MainLoop', $loop);

    $server.&server-listen
      if ($options +& SOUP_TEST_SERVER_NO_DEFAULT_LISTENER).not;

    $server-start-mutex.lock;
    $server-start-cond.signal;
    $server-start-mutex.unlock;
    $loop.run;

    # cw: All this should automatically be done at GC....
    #     ...unless order is important.
    $loop.unref;
    $server.disconnect;
    $context.pop_thread_default;
    $context.unref;
  }

  submethod BUILD (:$server) {
    $!server = $server;
  }

  method new (Int() $options = SOUP_TEST_SERVER_DEFAULT, :$raw = False) {
    # my SoupTestServerOptions $o = $options;
    # my $ss = soup_test_server_new($options);
    #
    # $ss ??
    #   ( $raw ?? $ss !! SOUP::Server.new($ss) )
    #   !!
    #   Nil;

    # Ported from test-utils.c
    my $cert = GTlsCertificate;
    if SOUP::Test.tls-available {
      my $ssl-cert-file = $*CWD.add('test-cert.pem').absolute;
      my $ssl-key-file  = $*CWD.add('test-cert.key').absolute;

      $cert = GIO::TlsCertificate.new-from-files(
        $ssl-cert-file,
        $ssl-key-file
      );
      if $ERROR {
        $*ERR.say: "Unable to create server: { $ERROR.message }";
        exit 1;
      }
    }

    my $server = SOUP::Server.new( tls-certificate => $cert );
    $server.set-data('options', $options);
    if $options +& SOUP_TEST_SERVER_IN_THREAD {
      $!server-start-mutex.lock();

      my $thread = GLib::Thread.new(
        'server_thread',
        sub { run-server-thread($server) },
      );

      $!server-start-cond.wait($!server-start-mutex);
      $!server-start-mutex.unlock;
      $server.set-data('thread', $thread);
    } elsif ($options +& SOUP_TEST_SERVER_NO_DEFAULT_LISTENER).not {
      $server.&server-listen;
    }

    $server ?? self.bless( :$server ) !! Nil;
  }

  method new_with_options (|c) {
    die 'Cannot call .new_with_options on a SOUP::Test::Server object';
  }

  method find_server_uri (Str() $scheme, Str() $host = Str) {
    for $!server.get-uris {
      next if $scheme && $scheme ne .scheme;
      next if $host   && $host   ne .scheme;
      return .copy;
    }
    False;
  }

  method add_listener (Str() $scheme, Str() $host) {
    my $options = 0;

    $options +|= SOUP_SERVER_LISTEN_HTTPS     if $scheme eq 'https';
    $options +|= SOUP_SERVER_LISTEN_IPV4_ONLY if $host   eq '127.0.0.1';
    $options +|= SOUP_SERVER_LISTEN_IPV6_ONLY if $host   eq '::1';

    $!server.listen_local(0, $options);
    return $ERROR if $ERROR;

    self.find_server_uri($scheme, $host);
  }

  method get_uri (Str() $scheme, Str() $host) is also<get-uri> {
    # soup_test_server_get_uri(self.SoupServer, $scheme, $host);

    my $uri;
    return $uri if $uri = self.find_server_uri($scheme, $host);

    if $!server.get-data('MainLoop') -> $loop {
      my ($context, $m, $c) = ($loop.context, GLib::Mutex.new, GLib::Cond.new);

      $m.lock;
      my $s = self;
      SOUP::Source.add_completion($context, -> $ --> gboolean {
        $uri = $s.add_listener($scheme, $host);
        $m.lock;
        $c.signal;
        $m.unlock;
        0;
      });

      $c.wait($m) while $uri.not;
      $m.unlock;
      $m.clear;
      $c.clear;
    } else {
      $uri = self.add_listener($scheme, $host);
    }

    $uri;
  }

  method disconnect_and_wait (GLib::MainContext $context = GLib::MainContext) {
    my $done = False;

    my $source = GLib::Source::Idle.new;
    $source.set_priority(G_PRIORITY_LOW);
    $source.set_callback(-> $ --> gboolean { $done = True; 0 });
    $source.attach($context // GMainContext);
    $source.unref;
    $!server.disconnect;

    $context.iteration while $done.not;
  }

  method quit_unref is also<quit-unref> {
    # soup_test_server_quit_unref(self.SoupServer);

    if $!server.get-data('thread') -> $thread {
      my $loop    = $!server.get-data('MainLoop');
      my $context = $loop.context;

      $context.ref;
      my $s = self;
      SOUP::Source.add_completion($context, -> $ --> gboolean {
        $s.disconnect_and_wait($context);
        $loop.quit;
        0;
      });
      $context.unref;
      $thread.join;
    } else {
      self.disconnect_and_wait;
    }

    my $s-rc = $!server.ref_count;
    $!server.unref;
    $s-rc;
  }

}

class SOUP::Test::Session is SOUP::Session {

  proto method new (|)
  { * }

  multi method new (SoupSessionAncestry $session) {
    $session ?? self.bless( :$session ) !! Nil;
  }
  multi method new (@options) {
    samewith( |@options );
  }
  multi method new (*@options) {
    my %options;
    for @options.rotor(2) {
      %options{ .[0] } = .[1];
    }
    SOUP::Session.new_with_options(|%options);
  }
  multi method new (%options) {
    samewith(|%options);
  }
  multi method new (*%options) {
    my %real-opts = %options.clone;

    # cw: Add more error checking options here!
    for <http-aliases http_aliases https-aliases https_aliases> {
      if %real-opts{$_} ~~ Positional {
        %real-opts{$_} = resolve-gstrv( %real-opts{$_} );
      } elsif %real-opts{$_} !~~ CArray[Str] {
        die "{$_} option must be a Str-Array compatible value!";
      }
    }

    SOUP::Test::Session.new(
      'accept-language',         %real-opts<accept-language>        // %real-opts<accept_language>         // Str,
      'accept-language-auto',    %real-opts<accept-language-auto>   // %real-opts<accept_language_auto>    // False,
      'add-feature',             %real-opts<add-feature>            // %real-opts<add_feature>             // SoupSessionFeature,
      'add-feature-by-type',     %real-opts<add-feature-by-type>    // %real-opts<add_feature_by_type>     // CArray[GType];
      'async-context',           %real-opts<async-context>          // %real-opts<async_context>           // GMainContext,
      'http-aliases',            %real-opts<http-aliases>           // %real-opts<http_aliases>            // CArray[Str],
      'https-aliases',           %real-opts<https-aliases>          // %real-opts<https_aliases>           // CArray[Str],
      'idle-timeout',            %real-opts<idle-timeout>           // %real-opts<idle_timeout>            // 0,
      'local-address',           %real-opts<local-address>          // %real-opts><local_address>          // SoupAddress,
      'max-conns',               %real-opts<max-conns>              // %real-opts<max_conns>               // 0,
      'max-conns-per-host',      %real-opts<max-conns-per-host>     // %real-opts<max_conns_per_host>      // 0,
      'proxy-resolver',          %real-opts<proxy-resolver>         // %real-opts<proxy_resolver>          // GProxyResolver,
      'proxy-uri',               %real-opts<proxy-uri>              // %real-opts<proxy_uri>               // SoupURI,
      'remove-feature-by-type',  %real-opts<remove-feature-by-type> // %real-opts<remove_features_by_type> // CArray[GType],
      'ssl-ca-file',             %real-opts<ssl-ca-file>            // %real-opts<ssl_ca_file>             // Str,
      'ssl-strict',              %real-opts<ssl-strict>             // %real-opts<ssl_strict>              // False,
      'ssl-use-system-ca-file',  %real-opts<ssl-use-system-ca-file> // %real-opts<ssl_use_system_ca_file>  // False,
      'timeout',                 %real-opts<timeout>                                                       // 0,
      'tls-database',            %real-opts<tls-database>           // %real-opts<tls_database>            // GTlsDatabase,
      'tls-interaction',         %real-opts<tls-interaction>        // %real-opts<tls_interaction>         // GTlsInteraction,
      'use-ntlm',                %real-opts<use-ntlm>               // %real-opts<use_ntlm>                // False,
      'use-thread-context',      %real-opts<use-thread-context>     // %real-opts<use_thread_context>      // False,
      'user-agent',              %real-opts<user-agent>             // %real-opts<user_agent>              // Str
    );
  }
  multi method new (
    'accept-language',         Str()                $accept-language,
    'accept-language-auto',    Int()                $accept-language-auto,
    'add-feature',             SoupSessionFeature() $add-feature,
    'add-feature-by-type',                          $add-feature-by-type;
    'async-context',           GMainContext()       $async-context,
    'http-aliases',                                 $http-aliases,
    'https-aliases',                                $https-aliases,
    'idle-timeout',            Int()                $idle-timeout,
    'local-address',           SoupAddress()        $local-address,
    'max-conns',               Int()                $max-conns,
    'max-conns-per-host',      Int()                $max-conns-per-host,
    'proxy-resolver',          GProxyResolver()     $proxy-resolver,
    'proxy-uri',               SoupURI()            $proxy-uri,
    'remove-feature-by-type',                       $remove-feature-by-type,
    'ssl-ca-file',             Str()                $ssl-ca-file,
    'ssl-strict',              Int()                $ssl-strict,
    'ssl-use-system-ca-file',  Int()                $ssl-use-system-ca-file,
    'timeout',                 Int()                $timeout,
    'tls-database',            GTlsDatabase()       $tls-database,
    'tls-interaction',         GTlsInteraction()    $tls-interaction,
    'use-ntlm',                Int()                $use-ntlm,
    'use-thread-context',      Int()                $use-thread-context,
    'user-agent',              Str()                $user-agent
  ) {
    my $session = soup_test_session_new(
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

  method abort_unref (SoupSession() $session) is also<abort-unref> {
    soup_test_session_abort_unref($session);
  }
}
