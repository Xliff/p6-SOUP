use v6.c;

use Method::Also;

use SOUP::Raw::Types;
use SOUP::Raw::MessageBody;

class SOUP::MessageBody {
  has SoupMessageBody $!smb;

  submethod BUILD ( :body(:$!smb) )
  { }

  method SOUP::Raw::Definitions::SoupMessageBody
    is also<SoupMessageBody>
  { $!smb }

  multi method new (SoupMessageBody $body) {
    $body ?? self.bless( :$body ) !! Nil;
  }
  multi method new {
    my $body = soup_message_body_new();

    $body ?? self.bless( :$body ) !! Nil;
  }

  method accumulate is rw {
    Proxy.new:
      FETCH => -> $           { self.get_accumulate    },
      STORE => -> $, Int() \a { self.set_accumulate(a) };
  }

  multi method append (Int() $use, GLib::Roles::TypedBuffer $data) {
    samewith($use, $data.p, $data.elems);
  }
  multi method append (Int() $use, Blob $b) {
    samewith($use, CArray[uint8].new($b), $b.elems);
  }
  multi method append (Int() $use, @data) {
    samewith($use, CArray[uint8].new(@data), @data.elems);
  }
  multi method append (Int() $use, CArray[uint8] $data, $length?) {
    my $l = $length // $data.elems;

    samewith($use, cast(Pointer, $data), $l);
  }
  multi method append (Int() $use, gpointer $data, Int() $length) {
    my SoupMemoryUse $u = $use;
    my gsize $l = $length;

    soup_message_body_append($!smb, $u, $data, $l);
  }

  method append_buffer (SoupBuffer() $buffer) is also<append-buffer> {
    soup_message_body_append_buffer($!smb, $buffer);
  }

  proto method append_take (|)
      is also<append-take>
  { * }

  multi method append_take (GLib::Roles::TypedBuffer $data) {
    samewith( $data.p, $data.elems );
  }
  multi method append_take (Blob $b) {
    samewith( CArray[uint8].new($b), $b.elems );
  }
  multi method append_take (@data) {
    samewith( CArray[uint8].new(@data), @data.elems );
  }
  multi method append_take (CArray[uint8] $data, $length?) {
    my $l = $length // $data.elems;

    samewith( cast(Pointer, $data), $l );
  }
  method append_take (gpointer $data, Int() $length) {
    my gsize $l = $length;

    soup_message_body_append_take($!smb, $data, $l);
  }

  method complete {
    soup_message_body_complete($!smb);
  }

  method flatten (:$rawm = False) {
    my $b = soup_message_body_flatten($!smb);

    $b ??
      ( $raw ?? $b !! Soup::Buffer.new($b) )
      !!
      Nil;
  }

  method free {
    soup_message_body_free($!smb);
  }

  method get_accumulate is also<get-accumulate> {
    so soup_message_body_get_accumulate($!smb);
  }

  method get_chunk (Int() $offset, :$raw = False) is also<get-chunk> {
    my goffset $o = $offset;

    my $b = soup_message_body_get_chunk($!smb, $offset);

    $b ??
      ( $raw ?? $b !! Soup::Buffer.new($b) )
      !!
      Nil;
  }

  method got_chunk (SoupBuffer() $chunk) is also<got-chunk> {
    soup_message_body_got_chunk($!smb, $chunk);
  }

  method set_accumulate (Int() $accumulate) is also<set-accumulate> {
    my gboolean $a = $accumulate.so.Int;

    soup_message_body_set_accumulate($!smb, $a);
  }

  method truncate {
    soup_message_body_truncate($!smb);
  }

  method wrote_chunk (SoupBuffer() $chunk) is also<wrote-chunk> {
    soup_message_body_wrote_chunk($!smb, $chunk);
  }

}
