use v6.c;

use Method::Also;

use NativeCall;

use SOUP::Raw::Types;
use SOUP::Raw::Request;

use SOUP::URI;

use GLib::Roles::Object;
use GIO::Roles::Initable;

our subset SoupRequestAncestry is export of Mu
  where SoupRequest | GInitable | GObject;

class SOUP::Request {
  also does GLib::Roles::Object;
  also does GIO::Roles::Initable;

  has SoupRequest $!sr is implementor;

  submethod BUILD (:$request) {
    self.setSoupRequest($request) if $request;
  }

  method setSoupRequest (SoupRequestAncestry $_) {
    my $to-parent;

    $!sr = do {
      when SoupRequest {
        $to-parent = cast(GObject, $_);
        $_;
      }

      when GInitable {
        $!i = $_;
        $to-parent = cast(GObject, $_);
        cast(SoupRequest, $_);
      }

      default {
        $to-parent = $_;
        cast(SoupRequest, $_);
      }
    }
    self.roleInit-Object;
    self.roleInit-Initable unless $!i;
  }

  method SOUP::Raw::Definitions::SoupRequest
    is also<SoupRequest>
  { $!sr }

  my %attributes;

  method attributes {
    # cw: Due to use of late-binding, %attibutes initialization must be
    #     delayed until run-time.
    unless %attributes {
      %attributes = (
        session => ::('SOUP::Session').get-type,
        uri     => SOUP::URI.get-type
      );
    }

    state %a = %attributes.Map;

    %a;
  }

  multi method new (SoupRequestAncestry $request) {
    $request ?? self.bless( :$request ) !! Nil;
  }

  method get_content_length
    is also<
      get-content-length
      content_length
      content-length
    >
  {
    soup_request_get_content_length($!sr);
  }

  method get_content_type
    is also<
      get-content-type
      content_type
      content-type
    >
  {
    soup_request_get_content_type($!sr);
  }

  method get_session (:$raw = False)
    is also<
      get-session
      session
    >
  {
    my $s = soup_request_get_session($!sr);

    $s ??
      ( $raw ?? $s !! ::('SOUP::Session').new($s) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_request_get_type, $n, $t );
  }

  method get_uri
    is also<
      get-uri
      uri
    >
  {
    soup_request_get_uri($!sr);
  }

  method send (
    GCancellable() $cancellable    = GCancellable,
    CArray[Pointer[GError]] $error = gerror,
    :$raw = False
  ) {
    clear_error;
    my $is = soup_request_send($!sr, $cancellable, $error);
    set_error($error);

    $is ??
      ( $raw ?? $is !! GIO::InputStream.new($is) )
      !!
      Nil;
  }

  proto method send_async (|)
      is also<send-async>
  { * }

  multi method send_async (
    &callback,
    GCancellable() $cancellable = GCancellable,
    gpointer $user_data = gpointer
  ) {
    samewith($cancellable, &callback, $user_data);
  }
  multi method send_async (
    GCancellable() $cancellable,
    &callback,
    gpointer $user_data = gpointer
  ) {
    soup_request_send_async($!sr, $cancellable, &callback, $user_data);
  }

  method send_finish (
    GAsyncResult() $result,
    CArray[Pointer[GError]] $error = gerror,
    :$raw = False
  )
    is also<send-finish>
  {
    clear_error;
    my $is = soup_request_send_finish($!sr, $result, $error);
    set_error($error);

    $is ??
      ( $raw ?? $is !! GIO::InputStream.new($is) )
      !!
      Nil;
  }

}
