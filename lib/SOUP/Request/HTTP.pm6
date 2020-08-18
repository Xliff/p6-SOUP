use v6.c;

use Method::Also;

use SOUP::Raw::Types;
use SOUP::Raw::Request;

use SOUP::Message;
use SOUP::Request;

our subset SoupRequestHTTPAncestry is export of Mu
  where SoupRequestHTTP | SoupRequestAncestry;

class SOUP::Request::HTTP is SOUP::Request {
  has SoupRequestHTTP $!srh is implementor;

  submethod BUILD (:$request-data) {
    self.setSoupRequestHTTP($request-data) if $request-data;
  }

  method setSoupRequestHTTP (SoupRequestHTTPAncestry $_) {
    my $to-parent;
    $!srh = do {
      when SoupRequestHTTP {
        $to-parent = cast(SoupRequest, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(SoupRequestHTTP, $_);
      }
    }
    self.setSoupRequest($to-parent);
  }

  method SOUP::Raw::Definitions::SoupRequestHTTP
    is also<SoupRequestHTTP>
  { $!srh }

  method new (SoupRequestHTTPAncestry $request-data) {
    $request-data ?? self.bless( :$request-data ) !! Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_request_http_get_type, $n, $t );
  }

  method get_message (:$raw = False)
    is also<
      get-message
      message
    >
  {
    my $m = soup_request_http_get_message($!srh);

    $m ??
      ( $raw ?? $m !! SOUP::Message.new($m) )
      !!
      Nil;
  }

}


### /usr/include/libsoup-2.4/libsoup/soup-request-http.h

sub soup_request_http_get_message (SoupRequestHTTP $http)
  returns SoupMessage
  is native(soup)
  is export
{ * }

sub soup_request_http_get_type ()
  returns GType
  is native(soup)
  is export
{ * }
