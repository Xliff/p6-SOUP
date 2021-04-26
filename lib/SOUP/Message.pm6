use v6.c;

use NativeCall;
use Method::Also;

use SOUP::Raw::Types;
use SOUP::Raw::Message;

use GLib::Roles::Object;

use GLib::Bytes;
use GLib::Value;
use SOUP::MessageBody;
use SOUP::MessageHeaders;
use SOUP::URI;

our subset SoupMessageAncestry is export of Mu
  where SoupMessage | GObject;

class SOUP::Message {
  also does GLib::Roles::Object;

  has SoupMessage $!sm is implementor;

  submethod BUILD (:$message) {
    self.setSoupMessage($message) if $message;
  }

  method setSoupMessage (SoupMessageAncestry $_) {
    my $to-parent;
    $!sm = do {
      when SoupMessage {
        $to-parent = cast(GObject, $_);
        $_
      }

      default {
        $to-parent = $_;
        cast(SoupMessage, $_)
      }
    }
    self!setObject($to-parent);
  }

  method SOUP::Raw::Definitions::SoupMessage
    is also<SoupMessage>
  { $!sm }

  multi method new (SoupMessageAncestry $message) {
    $message ?? self.bless( :$message ) !! Nil;
  }
  multi method new (Str() $method, Str() $uri_string) {
    my $message = soup_message_new($method, $uri_string);

    $message ?? self.bless( :$message ) !! Nil;
  }

  multi method new (Str() $method, SoupURI() $u, :$uri is required) {
    SOUP::Message.new_from_uri($method, $u);
  }
  method new_from_uri (Str() $method, SoupURI() $uri) is also<new-from-uri> {
    my $message = soup_message_new_from_uri($method, $uri);

    $message ?? self.bless( :$message ) !! Nil;
  }

  # Type: SoupURI
  method first-party (:$raw = False) is rw  is also<first_party> {
    my $gv = GLib::Value.new( SOUP::URI.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('first-party', $gv)
        );

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(SoupURI, $o);
        return $o if $raw;

        SOUP::URI.new($o)
      },
      STORE => -> $, SoupURI() $val is copy {
        $gv.object = $val;
        self.prop_set('first-party', $gv);
      }
    );
  }

  # Type: SoupMessageFlags
  method flags is rw  {
    my $gv = GLib::Value.new( GLib::Value.gtypeFromType(SoupMessageFlags) );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('flags', $gv)
        );
        $gv.valueFromType(SoupMessageFlags);
      },
      STORE => -> $, Int() $val is copy {
        $gv.vauleFromType(SoupMessageFlags) = $val;
        self.prop_set('flags', $gv);
      }
    );
  }

  # Type: SoupHTTPVersion
  method http-version is rw  is also<http_version> {
    my $gv = GLib::Value.new( GLib::Value.gtypeFromType(SoupHTTPVersion) );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('http-version', $gv)
        );
        SoupHTTPVersionEnum( $gv.enum )
      },
      STORE => -> $, Int() $val is copy {
        $gv.valueFromType(SoupHTTPVersion) = $val;
        self.prop_set('http-version', $gv);
      }
    );
  }

  # Type: gchar
  method method is rw  {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('method', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('method', $gv);
      }
    );
  }

  # Type: SoupMessagePriority
  method priority is rw  {
    my $gv = GLib::Value.new( GLib::Value.gtypeFromType(SoupMessagePriority) );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('priority', $gv)
        );
        SoupMessagePriority( $gv.valueFromType(SoupMessagePriority) )
      },
      STORE => -> $, Int() $val is copy {
        $gv.valueFromType(SoupMessagePriority) = $val;
        self.prop_set('priority', $gv);
      }
    );
  }

  # Type: gchar
  method reason-phrase is rw  is also<reason_phrase> {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('reason-phrase', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('reason-phrase', $gv);
      }
    );
  }

  # Type: SoupMessageBody
  method request-body (:$raw = False) is rw  is also<request_body> {
    my $gv = GLib::Value.new( SOUP::MessageBody.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('request-body', $gv)
        );

        my $o = $gv.boxed;
        return Nil unless $o;

        $o = cast(SoupMessageBody, $o);
        return $o if $raw;

        SOUP::MessageBody.new($o);
      },
      STORE => -> $, $val is copy {
        warn 'request-body does not allow writing'
      }
    );
  }

  # Type: GBytes
  method request-body-data (:$raw = False) is rw  is also<request_body_data> {
    my $gv = GLib::Value.new( GLib::Bytes.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('request-body-data', $gv)
        );

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(GBytes, $o);
        return $o if $raw;

        GLib::Bytes.new($o);
      },
      STORE => -> $, $val is copy {
        warn 'request-body-data does not allow writing'
      }
    );
  }

  # Type: SoupMessageHeaders
  method request-headers (:$raw = False) is rw  is also<request_headers> {
    my $gv = GLib::Value.new( SOUP::MessageHeaders.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('request-headers', $gv)
        );

        propReturnObject(
          $gv.boxed,
          $raw,
          SoupMessageHeaders,
          SOUP::MessageHeaders,
          :ref
        );
      },
      STORE => -> $, $val is copy {
        warn 'request-headers does not allow writing'
      }
    );
  }

  # Type: SoupMessageBody
  method response-body (:$raw = False) is rw  is also<response_body> {
    my $gv = GLib::Value.new( SOUP::MessageBody.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('response-body', $gv)
        );

        my $o = $gv.boxed;
        return Nil unless $o;

        $o = cast(SoupMessageBody, $o);
        return $o if $raw;

        SOUP::MessageBody.new($o);
      },
      STORE => -> $, $val is copy {
        warn 'response-body does not allow writing'
      }
    );
  }

  # Type: GBytes
  method response-body-data (:$raw = False) is rw is also<response_body_data> {
    my $gv = GLib::Value.new( GLib::Bytes.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('response-body-data', $gv)
        );

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(GBytes, $o);
        return $o if $raw;

        GLib::Bytes.new($o);
      },
      STORE => -> $, $val is copy {
        warn 'response-body-data does not allow writing'
      }
    );
  }

  # Type: SoupMessageHeaders
  method response-headers (:$raw = False) is rw is also<response_headers> {
    my $gv = GLib::Value.new( SOUP::MessageHeaders.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('response-headers', $gv)
        );

        propReturnObject(
          $gv.boxed,
          $raw,
          SoupMessageHeaders,
          SOUP::MessageHeaders,
          :ref
        );
      },
      STORE => -> $, $val is copy {
        warn 'response-headers does not allow writing'
      }
    );
  }

  # Type: gboolean
  method server-side is rw  is also<server_side> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('server-side', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, $val is copy {
        warn 'server-side is a construct-only attribute'
      }
    );
  }

  # Type: guint
  method status-code is rw  is also<status_code> {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('status-code', $gv)
        );
        SoupStatusEnum( $gv.uint );
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('status-code', $gv);
      }
    );
  }

  # Type: GTlsCertificate
  method tls-certificate (:$raw = False) is rw  is also<tls_certificate> {
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
      STORE => -> $, GTlsCertificate() $val is copy {
        $gv.object = $val;
        self.prop_set('tls-certificate', $gv);
      }
    );
  }

  # Type: GTlsCertificateFlags
  method tls-errors is rw  is also<tls_errors> {
    my $gv = GLib::Value.new( GLib::Value.gtypeFromType(GTlsCertificateFlags) );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('tls-errors', $gv)
        );
        $gv.valueFromType(GTlsCertificateFlags);
      },
      STORE => -> $, Int() $val is copy {
        $gv.valueFromType(GTlsCertificateFlags) = $val;
        self.prop_set('tls-errors', $gv);
      }
    );
  }

  # Type: SoupURI
  method uri (:$raw = False) is rw  {
    my $gv = GLib::Value.new( SOUP::URI.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('uri', $gv)
        );

        propReturnObject(
          $gv.boxed,
          $raw,
          SoupURI,
          SOUP::URI
        );
      },
      STORE => -> $, SoupURI() $val is copy {
        $gv.object = $val;
        self.prop_set('uri', $gv);
      }
    );
  }

  # Is originally:
  # SoupMessage, gchar, GHashTable, gpointer --> void
  method content-sniffed is also<content_sniffed> {
    self.connect-content-sniffed($!sm);
  }

  # Is originally:
  # SoupMessage, gpointer --> void
  method finished {
    self.connect($!sm, 'finished');
  }

  # Is originally:
  # SoupMessage, gpointer --> void
  method got-body is also<got_body> {
    self.connect($!sm, 'got-body');
  }

  # Is originally:
  # SoupMessage, SoupBuffer, gpointer --> void
  method got-chunk is also<got_chunk> {
    self.connect-got-chunk($!sm);
  }

  # Is originally:
  # SoupMessage, gpointer --> void
  method got-headers is also<got_headers> {
    self.connect($!sm, 'got-headers');
  }

  # Is originally:
  # SoupMessage, gpointer --> void
  method got-informational is also<got_informational> {
    self.connect($!sm, 'got-informational');
  }

  # Is originally:
  # SoupMessage, GSocketClientEvent, GIOStream, gpointer --> void
  method network-event is also<network_event> {
    self.connect-network-event($!sm);
  }

  # Is originally:
  # SoupMessage, gpointer --> void
  method restarted {
    self.connect($!sm, 'restarted');
  }

  # Is originally:
  # SoupMessage, gpointer --> void
  method starting {
    self.connect($!sm, 'starting');
  }

  # Is originally:
  # SoupMessage, gpointer --> void
  method wrote-body is also<wrote_body> {
    self.connect($!sm, 'wrote-body');
  }

  # Is originally:
  # SoupMessage, SoupBuffer, gpointer --> void
  method wrote-body-data is also<wrote_body_data> {
    self.connect-wrote-body-data($!sm);
  }

  # Is originally:
  # SoupMessage, gpointer --> void
  method wrote-chunk is also<wrote_chunk> {
    self.connect($!sm, 'wrote-chunk');
  }

  # Is originally:
  # SoupMessage, gpointer --> void
  method wrote-headers is also<wrote_headers> {
    self.connect($!sm, 'wrote-headers');
  }

  # Is originally:
  # SoupMessage, gpointer --> void
  method wrote-informational is also<wrote_informational> {
    self.connect($!sm, 'wrote-informational');
  }

  method add_header_handler (
    Str() $signal,
    Str() $header,
    GCallback $callback,
    gpointer $user_data
  )
    is also<add-header-handler>
  {
    soup_message_add_header_handler(
      $!sm,
      $signal,
      $header,
      $callback,
      $user_data
    );
  }

  method add_status_code_handler (
    Str() $signal,
    Int() $status_code,
    GCallback $callback,
    gpointer $user_data
  )
    is also<add-status-code-handler>
  {
    my guint $sc = $status_code;

    soup_message_add_status_code_handler(
      $!sm,
      $signal,
      $status_code,
      $callback,
      $user_data
    );
  }

  method emit_content_sniffed (Str() $content_type, GHashTable() $params)
    is also<emit-content-sniffed>
  {
    soup_message_content_sniffed($!sm, $content_type, $params);
  }

  method disable_feature (Int() $feature_type) is also<disable-feature> {
    my GType $ft = $feature_type;

    soup_message_disable_feature($!sm, $ft);
  }

  method emit-finished is also<emit_finished> {
    soup_message_finished($!sm);
  }

  method get_address is also<get-address> {
    soup_message_get_address($!sm);
  }

  method get_first_party is also<get-first-party> {
    soup_message_get_first_party($!sm);
  }

  method get_flags is also<get-flags> {
    soup_message_get_flags($!sm);
  }

  method get_http_version is also<get-http-version> {
    soup_message_get_http_version($!sm);
  }

  method get_https_status (
    GTlsCertificate() $certificate,
    Int() $errors
  )
    is also<get-https-status>
  {
    my GTlsCertificateFlags $e = $errors;

    soup_message_get_https_status($!sm, $certificate, $errors);
  }

  method get_is_top_level_navigation is also<get-is-top-level-navigation> {
    soup_message_get_is_top_level_navigation($!sm);
  }

  method get_priority is also<get-priority> {
    soup_message_get_priority($!sm);
  }

  method get_site_for_cookies is also<get-site-for-cookies> {
    soup_message_get_site_for_cookies($!sm);
  }

  method get_soup_request is also<get-soup-request> {
    soup_message_get_soup_request($!sm);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_message_get_type, $n, $t );
  }

  method get_uri is also<get-uri> {
    soup_message_get_uri($!sm);
  }

  method emit_got_body is also<emit-got-body> {
    soup_message_got_body($!sm);
  }

  method emit_got_chunk (SoupBuffer() $chunk) is also<emit-got-chunk> {
    soup_message_got_chunk($!sm, $chunk);
  }

  method emit_got_headers is also<emit-got-headers> {
    soup_message_got_headers($!sm);
  }

  method emit_got_informational is also<emit-got-informational> {
    soup_message_got_informational($!sm);
  }

  method is_keepalive is also<is-keepalive> {
    soup_message_is_keepalive($!sm);
  }

  method emit-restarted is also<emit_restarted> {
    soup_message_restarted($!sm);
  }

  method set_chunk_allocator (
    &allocator,
    gpointer $user_data            = gpointer,
    GDestroyNotify $destroy_notify = GDestroyNotify
  )
    is also<set-chunk-allocator>
  {
    soup_message_set_chunk_allocator(
      $!sm,
      &allocator,
      $user_data,
      $destroy_notify
    );
  }

  method set_first_party (SoupURI() $first_party) is also<set-first-party> {
    soup_message_set_first_party($!sm, $first_party);
  }

  method set_flags (Int() $flags) is also<set-flags> {
    my SoupMessageFlags $f = $flags;

    soup_message_set_flags($!sm, $f);
  }

  method set_http_version (Int() $version) is also<set-http-version> {
    my SoupHTTPVersion $v = $version;

    soup_message_set_http_version($!sm, $v);
  }

  method set_is_top_level_navigation (Int() $is_top_level_navigation)
    is also<set-is-top-level-navigation>
  {
    my gboolean $i = $is_top_level_navigation.so.Int;

    soup_message_set_is_top_level_navigation($!sm, $i);
  }

  method set_priority (Int() $priority) is also<set-priority> {
    my SoupMessagePriority $p = $priority;

    soup_message_set_priority($!sm, $p);
  }

  method set_redirect (Int() $status_code, Str() $redirect_uri)
    is also<set-redirect>
  {
    my guint $s = $status_code;

    soup_message_set_redirect($!sm, $s, $redirect_uri);
  }

  method set_request (
    Str() $content_type,
    Int() $req_use,
    Str() $req_body,
    Int() $req_length = -1
  )
    is also<set-request>
  {
    my SoupMemoryUse $ru = $req_use;
    my gsize $rl = $req_length;

    soup_message_set_request($!sm, $content_type, $ru, $req_body, $rl);
  }

  method set_response (
    Str() $content_type,
    Int() $resp_use,
    Str() $resp_body,
    Int() $resp_length = -1
  )
    is also<set-response>
  {
    my SoupMemoryUse $ru = $resp_use;
    my gsize $rl = $resp_length;

    soup_message_set_response(
      $!sm,
      $content_type,
      $ru,
      explicitly-manage($resp_body),
      $rl
    );
  }

  method set_site_for_cookies (SoupURI() $site_for_cookies)
    is also<set-site-for-cookies>
  {
    soup_message_set_site_for_cookies($!sm, $site_for_cookies);
  }

  method set_status (Int() $status_code) is also<set-status> {
    my guint $s = $status_code;

    soup_message_set_status($!sm, $s);
  }

  method set_status_full (Int() $status_code, Str() $reason_phrase)
    is also<set-status-full>
  {
    my guint $s = $status_code;

    soup_message_set_status_full($!sm, $s, $reason_phrase);
  }

  method set_uri (SoupURI() $uri) is also<set-uri> {
    soup_message_set_uri($!sm, $uri);
  }

  method emit_starting is also<emit-starting> {
    soup_message_starting($!sm);
  }

  method emit_wrote_body is also<emit-wrote-body> {
    soup_message_wrote_body($!sm);
  }

  method emit_wrote_body_data (SoupBuffer() $chunk)
    is also<emit-wrote-body-data>
  {
    soup_message_wrote_body_data($!sm, $chunk);
  }

  method emit_wrote_chunk is also<emit-wrote-chunk> {
    soup_message_wrote_chunk($!sm);
  }

  method emit_wrote_headers is also<emit-wrote-headers> {
    soup_message_wrote_headers($!sm);
  }

  method emit_wrote_informational is also<emit-wrote-informational> {
    soup_message_wrote_informational($!sm);
  }

}
