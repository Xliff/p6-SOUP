use v6.c;

use NativeCall;

use SOUP::Raw::Types;

use GLib::HashTable;

use GLib::Roles::StaticClass;

class SOUP::Form {
  also does GLib::Roles::StaticClass;

  method decode (Str() $data, :$raw) {
    propReturnObject(
      soup_form_decode($data),
      $raw,
      |GLib::HashTable.getTypePair
    );
  }

  proto method decode_multipart (|)
  { * }

  multi method decode_multipart (
    SoupMultipart()   $multipart,
    Str()             $file_control_name,
                      @filename,
                      @content_type,
                      $file
  ) {
    my $f = do given $file -> $_ is rw {
      when Str           {  $_ = .IO;                   proceed }
      when IO            {  $_ = .slurp.decode;         proceed }
      when Buf | Array   {  $_ = CArray[uint8].new($_); proceed }
      when CArray[uint8] {  $_ = GLib::Bytes.new($_);           }
    }

    samewith(
      $multipart,
      $file_control_name,
      newCArray(Str, @filename),
      newCArray(Str, @content_type),
      $f
    );
  }
  multi method decode_multipart (
    SoupMultipart()   $multipart,
    Str()             $file_control_name,
    CArray[Str]       $filename,
    CArray[Str]       $content_type,
    CArray[GBytes]    $file,
                     :$raw                = False
  ) {
    propReturnObject(
      soup_form_decode_multipart(
        $multipart,
        $file_control_name,
        $filename,
        $content_type,
        $file
      ),
      $raw,
      |GLib::HashTable.getTypePair
    );
  }

  method encode_datalist (GData() $data) {
    soup_form_encode_datalist($data);
  }

  proto method encode_hash (|)
  { * }

  multi method encode_hash (%hashtable) {
    samewith( GLib::HashTable.new(%hashtable) );
  }
  multi method encode_hash (GHashTable() $hashtable) {
    soup_form_encode_hash($hashtable);
  }
}

### /usr/src/libsoup/libsoup/soup-form.h

sub soup_form_decode (Str $encoded_form)
  returns GHashTable
  is      native(soup)
  is      export
{ * }

sub soup_form_decode_multipart (
  SoupMultipart  $multipart,
  Str            $file_control_name,
  CArray[Str]    $filename,
  CArray[Str]    $content_type,
  CArray[GBytes] $file
)
  returns GHashTable
  is      native(soup)
  is      export
{ * }

sub soup_form_encode_datalist (CArray[GData] $form_data_set)
  returns Str
  is      native(soup)
  is      export
{ * }

sub soup_form_encode_hash (GHashTable $form_data_set)
  returns Str
  is      native(soup)
  is      export
{ * }
