use v6.c;

use Method::Also;

use SOUP::Raw::Types;
use SOUP::Raw::Server::Message;

use GLib::URI;
use GIO::Socket;
use GIO::SocketAddress;
use GIO::Stream;
use GIO::TlsCertificate;
use SOUP::MessageBody;
use SOUP::MessageHeaders;

use GLib::Roles::Implementor;
use GLib::Roles::Object;

our subset SoupServerMessageAncestry is export of Mu
  where SoupServerMessage | GObject;

class SOUP::Server::Message {
  also does GLib::Roles::Object;

  has SoupServerMessage $!ssm is implementor;

  submethod BUILD ( :$soup-server-msg ) {
    self.setSoupServerMessage($soup-server-msg) if $soup-server-msg
  }

  method setSoupServerMessage (SoupServerMessageAncestry $_) {
    my $to-parent;

    $!ssm = do {
      when SoupServerMessage {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(SoupServerMessage, $_);
      }
    }
    self!setObject($to-parent);
  }

  method SOUP::Raw::Definitions::SoupServerMessage
    is also<SoupServerMessage>
  { $!ssm }

  multi method new (
     $soup-server-msg where * ~~ SoupServerMessageAncestry,

    :$ref = True
  ) {
    return unless $soup-server-msg;

    my $o = self.bless( :$soup-server-msg );
    $o.ref if $ref;
    $o;
  }

  # Type: GTlsCertificate
  method tls-peer-certificate ( :$raw = False )
    is rw
    is g-property
    is also<tls_peer_certificate>
  {
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
    is also<tls_peer_certificate_errors>
  {
    my $gv = GLib::Value.typeFromEnum( GTlsCertificateFlags );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('tls-peer-certificate-errors', $gv);
        my $f = $gv.flags;
        return $f unless $flags;
        getFlags(GTlsCertificateFlagsEnum, $f);
      },
      STORE => -> $,  $val is copy {
        warn 'tls-peer-certificate-errors does not allow writing'
      }
    );
  }

  method get_http_version ( :$enum = True ) is also<get-http-version> {
    my $e = soup_server_message_get_http_version($!ssm);
    return $e unless $enum;
    SoupHTTPVersionEnum($e);
  }

  method get_local_address ( :$raw = False ) is also<get-local-address> {
    propReturnObject(
      soup_server_message_get_local_address($!ssm),
      $raw,
      |GIO::SocketAddress.getTypePair
    )
  }

  method get_method is also<get-method> {
    soup_server_message_get_method($!ssm);
  }

  method get_reason_phrase is also<get-reason-phrase> {
    soup_server_message_get_reason_phrase($!ssm);
  }

  method get_remote_address ( :$raw = False ) is also<get-remote-address> {
    propReturnObject(
      soup_server_message_get_remote_address($!ssm),
      $raw,
      |GIO::SocketAddress.getTypePair
    );
  }

  method get_remote_host is also<get-remote-host> {
    soup_server_message_get_remote_host($!ssm);
  }

  method get_request_body ( :$raw = False ) is also<get-request-body> {
    propReturnObject(
      soup_server_message_get_request_body($!ssm),
      $raw,
      |SOUP::MessageBody.getTypePair
    );
  }

  method get_request_headers ( :$raw = False ) is also<get-request-headers> {
    propReturnObject(
      soup_server_message_get_request_headers($!ssm),
      $raw,
      |SOUP::MessageHeaders.getTypePair
    );
  }

  method get_response_body ( :$raw = False ) is also<get-response-body> {
    propReturnObject(
      soup_server_message_get_response_body($!ssm),
      $raw,
      |SOUP::MessageBody.getTypePair
    );
  }

  method get_response_headers ( :$raw = False )
    is also<get-response-headers>
  {
    propReturnObject(
      soup_server_message_get_response_headers($!ssm),
      $raw,
      |SOUP::MessageHeaders.getTypePair
    );
  }

  method get_socket ( :$raw = False )  is also<get-socket> {
    propReturnObject(
      soup_server_message_get_socket($!ssm),
      $raw,
      |GIO::Socket.getTypePair
    );
  }

  method get_status is also<get-status> {
    soup_server_message_get_status($!ssm);
  }

  method get_tls_peer_certificate ( :$raw = False )
    is also<get-tls-peer-certificate>
  {
    propReturnObject(
      soup_server_message_get_tls_peer_certificate($!ssm),
      $raw,
      |GIO::TlsCertificate.getTypePair
    );
  }

  method get_tls_peer_certificate_errors ( :$enum = True )
    is also<get-tls-peer-certificate-errors>
  {
    my $e = soup_server_message_get_tls_peer_certificate_errors($!ssm);
    return $e unless $enum;
    GTlsCertificateFlagsEnum($e);
  }

  method get_uri ( :$raw = False ) is also<get-uri> {
    propReturnObject(
      soup_server_message_get_uri($!ssm),
      $raw,
      |GLib::URI.getTypePair
    );
  }

  method is_options_ping is also<is-options-ping> {
    so soup_server_message_is_options_ping($!ssm);
  }

  method pause {
    soup_server_message_pause($!ssm);
  }

  method set_http_version (Int() $version) is also<set-http-version> {
    my SoupHTTPVersion $v = $version;

    soup_server_message_set_http_version($!ssm, $v);
  }

  method set_redirect (Int() $status_code, Str() $redirect_uri)
    is also<set-redirect>
  {
    my guint $s = $status_code;

    soup_server_message_set_redirect($!ssm, $status_code, $redirect_uri);
  }

  method set_response (
    Str() $content_type,
    Int() $resp_use,
    Str() $resp_body,
    Int() $resp_length
  )
    is also<set-response>
  {
    my SoupMemoryUse $ru = $resp_use;
    my gsize         $rl = $resp_length;

    soup_server_message_set_response(
      $!ssm,
      $content_type,
      $ru,
      $resp_body,
      $rl
    );
  }

  method set_status (Int() $status_code, Str() $reason_phrase)
    is also<set-status>
  {
    my guint $s = $status_code;

    soup_server_message_set_status($!ssm, $s, $reason_phrase);
  }

  method steal_connection ( :$raw = False ) is also<steal-connection> {
    propReturnObject(
      soup_server_message_steal_connection($!ssm),
      $raw,
      |GIO::Stream.getTypePair
    );
  }

  method unpause {
    soup_server_message_unpause($!ssm);
  }

}
