use v6.c;

use Method::Also;

use SOUP::Raw::Types;
use SOUP::Raw::Request;

use SOUP::Request;

our subset SoupRequestDataAncestry is export of Mu
  where SoupRequestData | SoupRequestAncestry;

class SOUP::Request::Data is SOUP::Request {
  has SoupRequestData $!srd is implementor;

  submethod BUILD (:$request-data) {
    self.setSoupRequestData($request-data) if $request-data;
  }

  method setSoupRequestData (SoupRequestDataAncestry $_) {
    my $to-parent;
    $!srd = do {
      when SoupRequestData {
        $to-parent = cast(SoupRequest, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(SoupRequestData, $_);
      }
    }
    self.setSoupRequest($to-parent);
  }

  method SOUP::Raw::Definitions::SoupRequestData
    is also<SoupRequestData>
  { $!srd }

  method new (SoupRequestAncestry $request-data) {
    $request-data ?? self.bless( :$request-data ) !! Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_request_data_get_type, $n, $t );
  }
}

### /usr/include/libsoup-2.4/libsoup/soup-request-data.h

sub soup_request_data_get_type ()
  returns GType
  is native(soup)
  is export
{ * }
