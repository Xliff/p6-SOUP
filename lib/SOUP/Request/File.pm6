use v6.c;

use Method::Also;

use SOUP::Raw::Types;
use SOUP::Raw::Request;

use SOUP::Request;

use GIO::Roles::GFile;

our subset SoupRequestFileAncestry is export of Mu
  where SoupRequestFile | SoupRequestAncestry;

class SOUP::Request::File is SOUP::Request {
  has SoupRequestFile $!srf is implementor;

  submethod BUILD (:$request-data) {
    self.setSoupRequestFile($request-data) if $request-data;
  }

  method setSoupRequestFile (SoupRequestAncestry $_) {
    my $to-parent;
    $!srf = do {
      when SoupRequestFile {
        $to-parent = cast(SoupRequest, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(SoupRequestFile, $_);
      }
    }
    self.setSoupRequest($to-parent);
  }

  method SOUP::Raw::Definitions::SoupRequestFile
    is also<SoupRequestFile>
  { $!srf }

  method new (SoupRequestFileAncestry $request-data) {
    $request-data ?? self.bless( :$request-data ) !! Nil;
  }

  method get_file (:$raw = False)
    is also<
      get-file
      file
    >
  {
    my $f = soup_request_file_get_file($!srf);

    $f ??
      ( $raw ?? $f !! GIO::Roles::GFile.new-file-obj($f) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_request_file_get_type, $n, $t );
  }
}

### /usr/include/libsoup-2.4/libsoup/soup-request-file.h

sub soup_request_file_get_file (SoupRequestFile $file)
  returns GFile
  is native(soup)
  is export
{ * }

sub soup_request_file_get_type ()
  returns GType
  is native(soup)
  is export
{ * }
