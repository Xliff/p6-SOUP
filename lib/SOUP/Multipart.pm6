use v6.c;

use Method::Also;

use SOUP::Raw::Types;
use SOUP::Raw::Multipart;

# BOXED

class SOUP::Multipart {
  has SoupMultipart $!sm;

  submethod BUILD (:$multipart) {
    $!sm = $multipart;
  }

  method SOUP::Raw::Definitions::SoupMultipart
    is also<SoupMultipart>
  { $!sm }

  method new (Str() $mime_type) {
    my $multipart = soup_multipart_new($mime_type);

    $multipart ?? self.bless( :$multipart ) !! Nil;
  }

  method new_from_message (
    SoupMessageHeaders() $headers,
    SoupMessageBody() $body
  )
    is also<new-from-message>
  {
    my $multipart = soup_multipart_new_from_message($headers, $body);

    $multipart ?? self.bless( :$multipart ) !! Nil;
  }

  method append_form_file (
    Str() $control_name,
    Str() $filename,
    Str() $content_type,
    SoupBuffer() $body
  )
    is also<append-form-file>
  {
    soup_multipart_append_form_file(
      $!sm,
      $control_name,
      $filename,
      $content_type,
      $body
    );
  }

  method append_form_string (Str() $control_name, Str() $data)
    is also<append-form-string>
  {
    soup_multipart_append_form_string($!sm, $control_name, $data);
  }

  method append_part (SoupMessageHeaders() $headers, SoupBuffer() $body)
    is also<append-part>
  {
    soup_multipart_append_part($!sm, $headers, $body);
  }

  method free {
    soup_multipart_free($!sm);
  }

  method get_length
    is also<
      get-length
      elems
    >
  {
    soup_multipart_get_length($!sm);
  }

  method get_part (
    Int() $part,
    SoupMessageHeaders() $headers,
    SoupBuffer() $body
  )
    is also<get-part>
  {
    my gint $p = $part;

    so soup_multipart_get_part($!sm, $p, $headers, $body);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_multipart_get_type, $n, $t );
  }

  proto method to_message (|)
      is also<to-message>
  { * }

  multi method to_message (:$raw = False) {
    my ($h, $b) = (SoupMessageHeaders.new, SoupMessageBody.new);

    samewith($h, $b);
    return ($h, $b) if $raw;
    ( SOUP::MessageHeaders.new($h), SOUP::MessageBody.new($b) )
  }
  multi method to_message (
    SoupMessageHeaders() $dest_headers,
    SoupMessageBody() $dest_body
  ) {
    soup_multipart_to_message($!sm, $dest_headers, $dest_body);
  }

}
