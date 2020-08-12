use v6.c;

use SOUP::Raw::Types;

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
    $!sm = do {
      when SoupMessage { $_                    }
      default          { cast(SoupMessage, $_) }
    }
    self.roleInit-Object;
  }

  method SOUP::Raw::Definitions::SoupMessage
  { $!sm }

  multi method new (SoupMessageAncestry $message) {
    $message ?? self.bless( :$message ) !! Nil;
  }
  multi method new (Str() $uri_string) {
    my $message = soup_message_new($!sm, $uri_string);

    $message ?? self.bless( :$message ) !! Nil;
  }

  multi method new (Str() $method, SoupURI() $uri, :$uri is required) {
    SOUP::Message.new_from_uri($method, $uri);
  }
  method new_from_uri (Str() $method, SoupURI() $uri) {
    my $message = soup_message_new_from_uri($!sm, $method, $uri);

    $message ?? self.bless( :$message ) !! Nil;
  }

  # Type: SoupURI
  method first-party (:$raw = False) is rw  {
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
  method http-version is rw  {
    my $gv = GLib::Value.new( GLib::Value.gtypeFromType(SoupHTTPVersion) );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('http-version', $gv)
        );
        SoupHTTPType( $gv.valueFromType(SoupHTTPType) )
      },
      STORE => -> $, Int() $val is copy {
        $gv.valueFromType(SoupHTTPType) = $val;
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
  method reason-phrase is rw  {
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
  method request-body (:$raw = False) is rw  {
    my $gv = GLib::Value.new( SOUP::MessageBody.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('request-body', $gv)
        );

        my $o = $gv.object;
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
  method request-body-data (:$raw = False) is rw  {
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
  method request-headers (:$raw = False) is rw  {
    my $gv = GLib::Value.new( SOUP::MessageHeaders.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('request-headers', $gv)
        );

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(SoupMessageHeaders, $o);
        return $o unless if $raw;

        SOUP::MessageHeaders.new($o);
      },
      STORE => -> $, $val is copy {
        warn 'request-headers does not allow writing'
      }
    );
  }

  # Type: SoupMessageBody
  method response-body (:$raw = False) is rw  {
    my $gv = GLib::Value.new( SOUP::MessageBody.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('response-body', $gv)
        );

        my $o = $gv.object;
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
  method response-body-data (:$raw = False) is rw  {
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
  method response-headers (:$raw = False) is rw {
    my $gv = GLib::Value.new( -type- );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('response-headers', $gv)
        );

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(SoupMessageHeaders, $o);
        return $o if $raw;

        SOUP::MessageHeaders.new($o);
      },
      STORE => -> $, $val is copy {
        warn 'response-headers does not allow writing'
      }
    );
  }

  # Type: gboolean
  method server-side is rw  {
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
  method status-code is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('status-code', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('status-code', $gv);
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
      STORE => -> $, GTlsCertificate() $val is copy {
        $gv.object = $val;
        self.prop_set('tls-certificate', $gv);
      }
    );
  }

  # Type: GTlsCertificateFlags
  method tls-errors is rw  {
    my $gv = GLib::Value.new( GLib::Value.gtypeFromType(GTlsCertificateFlags) );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('tls-errors', $gv)
        );
        $gv.valueFromType(GTlsCertificateFlags;
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

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(SoupURI, $o);
        return $o if $raw;

        SOUP::URI.new($o);
      },
      STORE => -> $, SoupURI() $val is copy {
        $gv.object = $val;
        self.prop_set('uri', $gv);
      }
    );
  }

  # Is originally:
  # SoupMessage, gchar, GHashTable, gpointer --> void
  method content-sniffed {
    self.connect-content-sniffed($!w);
  }

  # Is originally:
  # SoupMessage, gpointer --> void
  method finished {
    self.connect($!w, 'finished');
  }

  # Is originally:
  # SoupMessage, gpointer --> void
  method got-body {
    self.connect($!w, 'got-body');
  }

  # Is originally:
  # SoupMessage, SoupBuffer, gpointer --> void
  method got-chunk {
    self.connect-got-chunk($!w);
  }

  # Is originally:
  # SoupMessage, gpointer --> void
  method got-headers {
    self.connect($!w, 'got-headers');
  }

  # Is originally:
  # SoupMessage, gpointer --> void
  method got-informational {
    self.connect($!w, 'got-informational');
  }

  # Is originally:
  # SoupMessage, GSocketClientEvent, GIOStream, gpointer --> void
  method network-event {
    self.connect-network-event($!w);
  }

  # Is originally:
  # SoupMessage, gpointer --> void
  method restarted {
    self.connect($!w, 'restarted');
  }

  # Is originally:
  # SoupMessage, gpointer --> void
  method starting {
    self.connect($!w, 'starting');
  }

  # Is originally:
  # SoupMessage, gpointer --> void
  method wrote-body {
    self.connect($!w, 'wrote-body');
  }

  # Is originally:
  # SoupMessage, SoupBuffer, gpointer --> void
  method wrote-body-data {
    self.connect-wrote-body-data($!w);
  }

  # Is originally:
  # SoupMessage, gpointer --> void
  method wrote-chunk {
    self.connect($!w, 'wrote-chunk');
  }

  # Is originally:
  # SoupMessage, gpointer --> void
  method wrote-headers {
    self.connect($!w, 'wrote-headers');
  }

  # Is originally:
  # SoupMessage, gpointer --> void
  method wrote-informational {
    self.connect($!w, 'wrote-informational');
  }

  method add_header_handler (
    Str() $signal,
    Str() $header,
    GCallback $callback,
    gpointer $user_data
  ) {
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
  ) {
    my guint $sc = $status_code;

    soup_message_add_status_code_handler(
      $!sm,
      $signal,
      $status_code,
      $callback,
      $user_data
    );
  }

  method content_sniffed (Str() $content_type, GHashTable() $params) {
    soup_message_content_sniffed($!sm, $content_type, $params);
  }

  method disable_feature (Int() $feature_type) {
    my GType $ft = $feature_type;

    soup_message_disable_feature($!sm, $ft);
  }

  method finished {
    soup_message_finished($!sm);
  }

  method get_address {
    soup_message_get_address($!sm);
  }

  method get_first_party {
    soup_message_get_first_party($!sm);
  }

  method get_flags {
    soup_message_get_flags($!sm);
  }

  method get_http_version {
    soup_message_get_http_version($!sm);
  }

  method get_https_status (
    GTlsCertificate() $certificate,
    Int() $errors
  ) {
    my GTlsCertificateFlags $e = $errors;

    soup_message_get_https_status($!sm, $certificate, $errors);
  }

  method get_is_top_level_navigation {
    soup_message_get_is_top_level_navigation($!sm);
  }

  method get_priority {
    soup_message_get_priority($!sm);
  }

  method get_site_for_cookies {
    soup_message_get_site_for_cookies($!sm);
  }

  method get_soup_request {
    soup_message_get_soup_request($!sm);
  }

  method get_type {
    state ($n, $t);

    unstable_get_tyepe( self.^name, &soup_message_get_type, $n, $t );
  }

  method get_uri {
    soup_message_get_uri($!sm);
  }

  method got_body {
    soup_message_got_body($!sm);
  }

  method got_chunk (SoupBuffer() $chunk) {
    soup_message_got_chunk($!sm, $chunk);
  }

  method got_headers {
    soup_message_got_headers($!sm);
  }

  method got_informational {
    soup_message_got_informational($!sm);
  }

  method is_keepalive {
    soup_message_is_keepalive($!sm);
  }

  method restarted {
    soup_message_restarted($!sm);
  }

  method set_chunk_allocator (
    SoupChunkAllocator $allocator,
    gpointer $user_data            = gpointer,
    GDestroyNotify $destroy_notify = GDestroyNotify
  ) {
    soup_message_set_chunk_allocator(
      $!sm,
      $allocator,
      $user_data,
      $destroy_notify
    );
  }

  method set_first_party (SoupURI() $first_party) {
    soup_message_set_first_party($!sm, $first_party);
  }

  method set_flags (Int() $flags) {
    my SoupMessageFlags $f = $flags;

    soup_message_set_flags($!sm, $f);
  }

  method set_http_version (Int() $version) {
    my SoupHTTPVersion $v = $version;

    soup_message_set_http_version($!sm, $v);
  }

  method set_is_top_level_navigation (Int() $is_top_level_navigation) {
    my gboolean $i = $is_top_level_navigation.so.Int;

    soup_message_set_is_top_level_navigation($!sm, $i);
  }

  method set_priority (Int() $priority) {
    my SoupMessagePriority $p = $priority;

    soup_message_set_priority($!sm, $p);
  }

  method set_redirect (Int() $status_code, Str() $redirect_uri) {
    my guint $s = $status_code;

    soup_message_set_redirect($!sm, $sc, $redirect_uri);
  }

  method set_request (
    Str() $content_type,
    Int() $req_use,
    Str() $req_body,
    Int() $req_length
  ) {
    my SoupMemoryUse $ru = $resp_use;
    my gsize $rl = $resp_length;

    soup_message_set_request($!sm, $content_type, $req_use, $req_body, $req_length);
  }

  method set_response (
    Str() $content_type,
    Int() $resp_use,
    Str() $resp_body,
    Int() $resp_length
  ) {
    my SoupMemoryUse $ru = $resp_use;
    my gsize $rl = $resp_length;

    soup_message_set_response($!sm, $content_type, $ru, $resp_body, $rl);
  }

  method set_site_for_cookies (SoupURI() $site_for_cookies) {
    soup_message_set_site_for_cookies($!sm, $site_for_cookies);
  }

  method set_status (Int() $status_code) {
    my guint $s = $status_code;

    soup_message_set_status($!sm, $sc);
  }

  method set_status_full (Int() $status_code, Str() $reason_phrase) {
    my guint $s = $status_code;

    soup_message_set_status_full($!sm, $sc, $reason_phrase);
  }

  method set_uri (SoupURI() $uri) {
    soup_message_set_uri($!sm, $uri);
  }

  method starting {
    soup_message_starting($!sm);
  }

  method wrote_body {
    soup_message_wrote_body($!sm);
  }

  method wrote_body_data (SoupBuffer() $chunk) {
    soup_message_wrote_body_data($!sm, $chunk);
  }

  method wrote_chunk {
    soup_message_wrote_chunk($!sm);
  }

  method wrote_headers {
    soup_message_wrote_headers($!sm);
  }

  method wrote_informational {
    soup_message_wrote_informational($!sm);
  }

}
