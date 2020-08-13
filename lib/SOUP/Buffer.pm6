use v6.c;

use Method::Also;

use SOUP::Raw::Types;
use SOUP::Raw::MessageBody;

class SOUP::Buffer {
  has SoupBuffer $!sb handles<length>

  submethod BUILD ( :buffer(:$!sb) )
  { }

  method SOUP::Raw::Definitions::SoupBuffer
    is also<SoupBuffer>
  { $!sb }

  multi method new (SoupBuffer $buffer) {
    $buffer ?? self.bless( :$buffer ) !! Nil;
  }
  multi method new (Int() $use, GLib::Roles::TypedBuffer $data) {
    samewith($use, $data.p, $data.elems);
  }
  multi method new (Int() $use, Blob $b) {
    samewith($use, CArray[uint8].new($b), $b.elems);
  }
  multi method new (Int() $use, @data) {
    @data .= map({
      my $e = .Int if $_ !~ Int && .^lookup('Int');
      die '@data must only consist of uint8-compatible values!'
        if $e ~~ Int && $e ~~ 0 .. 256;
    });

    my $d = CArray[uint8].new(@data);

    samewith($use, $d, @data.elems);
  }
  multi method new (Int() $use, CArray[uint8] $data, $length?) {
    my $d = cast(Pointer, $data);
    my $l = $length // $data.elems;

    samewith($use, $d, $l);
  }
  multi method new (Int() $use, gpointer $data, Int() $length) {
    my gsize $l = $length;
    my SoupMemoryUse $u = $use;
    my $buffer = soup_buffer_new($u, $data, $l);

    $buffer ?? self.bless( :$buffer ) !! Nil;
  }

  method new_subbuffer (SoupBuffer() $buffer, Int() $offset, Int() $length)
    is also<new-subbuffer>
  {
    my gsize ($o, $l) = ($offset, $length);
    my $buffer = soup_buffer_new_subbuffer($buffer, $o, $l);

    $buffer ?? self.bless( :$buffer ) !! Nil;
  }


  proto method new_take (|)
    is also<new-take>
  { * }

  multi method new_take (GLib::Roles::TypedBuffer $data) {
    samewith($data, $data.elems);
  }
  multi method new_take (Blob $b) {
    samewith(CArray[uint8].new($b), $b.elems);
  }
  multi method new_take (@data) {
    samewith(CArray[uint8.new(@data, @data.elems);
  }
  multi method new_take (CArray[uint8] $data, $length?) {
    my $l = $length // $data.elems;

    samewith($data, $l);
  }
  multi method new_take (Pointer $data, Int() $length) {
    my gsize $l = $length;
    my $buffer = soup_buffer_new_take($data, $l);

    $buffer ?? self.bless( :$buffer ) !! Nil;
  }

  proto method new_with_owner (|)
      is also<new-with-owner>
  { * }

  method new_with_owner (
    GLib::Roles::TypedBuffer $data
    Int() $length,
    gpointer $owner,
    GDestroyNotify $owner_dnotify
  ) {
    samewith($data, $data.elems, $owner, $owner_dnotify);
  }
  method new_with_owner (
    Blob $b,
    gpointer $owner,
    GDestroyNotify $owner_dnotify
  ) {
    samewith( CArray[uint8].new($b), $b.elems, $owner, $owner_dnotify );
  )
  method new_with_owner (
    @data,
    gpointer $owner,
    GDestroyNotify $owner_dnotify
  ) {
    @data .= map({
      my $e = .Int if $_ !~ Int && .^lookup('Int');
      die '@data must only consist of uint8-compatible values!'
        if $e ~~ Int && $e ~~ 0 .. 256;
    });
    samewith( CArray[uint8].new(@data), @data.elems, $owner, $owner_dnotify );
  }
  method new_with_owner (
    CArray[uint8] $data,
    Int() $length,
    gpointer $owner,
    GDestroyNotify $owner_dnotify
  ) {
    samewith( cast(Pointer, $data), $length, $owner, $owner_dnotify )
  }
  method new_with_owner (
    Pointer $data,
    Int() $length,
    gpointer $owner,
    GDestroyNotify $owner_dnotify
  ) {
    my gsize $l = $length;
    my $buffer = soup_buffer_new_with_owner($data, $l, $owner, $owner_dnotify);

    $buffer ?? self.bless( :$buffer ) !! Nil;
  }

  method copy (:$raw = False) {
    my $c = soup_buffer_copy($!sb);

    $c ??
      ( $raw ?? $c !! Soup::Buffer.new($c) )
      !!
      Nil;
  }

  method free {
    soup_buffer_free($!sb);
  }

  method get_as_bytes (:$raw = False) is also<get-as-bytes> {
    my $b = soup_buffer_get_as_bytes($!sb);

    $b ??
      ( $raw ?? $b !! GLib::Bytes.new($b) )
      !!
      Nil;
  }

  proto method get_data (|)
      is also<get-data>
  { * }

  multi method get_data (:$raw = False) is also<data> {
    return $!sb.data if $raw;

    my $d = CArray[CArray[uint8]].new;
    $d[0] = CArray[uint8];
    my $l;

    samewith($d, $l);
    # Length is available via delegation!
    ppr($d);
  }
  multi method get_data (CArray[CArray[uint8]] $data, $length is rw) {
    my gsize $l = 0;;

    soup_buffer_get_data($!sb, $data, $l);
  }

  method get_owner is also<get-owner> {
    soup_buffer_get_owner($!sb);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_buffer_get_type, $n, $t );
  }
}
