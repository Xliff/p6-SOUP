use v6.c;

use Method::Also;
use NativeCall;

use SOUP::Raw::Types;
use SOUP::Raw::MessageHeaders;

# BOXED

class SOUP::MessageHeaders {
  has SoupMessageHeaders $!smh;

  submethod BUILD (:$headers) {
    $!smh = $headers;
  }

  method SOUP::Raw::Definitions::SoupMessageHeaders
  { $!smh }

  multi method new (SoupMessageHeaders $headers) {
    $headers ?? self.bless( :$headers ) !! Nil;
  }
  multi method new (Int() $type) {
    my SoupMessageHeadersType $t = $type;
    my $headers = soup_message_headers_new($t);

    $headers ?? self.bless( :$headers ) !! Nil;
  }

  method append (Str() $name, Str() $value) {
    soup_message_headers_append($!smh, $name, $value);
  }

  method clean_connection_headers is also<clean-connection-headers> {
    soup_message_headers_clean_connection_headers($!smh);
  }

  method clear {
    soup_message_headers_clear($!smh);
  }

  method foreach (&func, gpointer $user_data = gpointer) {
    soup_message_headers_foreach($!smh, &func, $user_data);
  }

  method free {
    soup_message_headers_free($!smh);
  }

  method free_ranges (SoupRange() $ranges) is also<free-ranges> {
    soup_message_headers_free_ranges($!smh, $ranges);
  }

  method get (Str() $name) {
    soup_message_headers_get($!smh, $name);
  }

  method get_content_disposition (Str() $disposition, GHashTable() $params)
    is also<get-content-disposition>
  {
    soup_message_headers_get_content_disposition($!smh, $disposition, $params);
  }

  method get_content_length is also<get-content-length> {
    soup_message_headers_get_content_length($!smh);
  }

  proto method get_content_range (|)
      is also<get-content-range>
  { * }

  multi method get_content_range {
    my $rv = samewith($, $, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method get_content_range (
    $start        is rw,
    $end          is rw,
    $total_length is rw,
    :$all = False
  ) {
    my goffset ($s, $e, $l) = ($start, $end, $total_length);

    my $rv = so soup_message_headers_get_content_range($!smh, $s, $e, $l);
    ($start, $end, $total_length) = ($s, $e, $l);

    $all.not ?? $rv !! ($rv, $start, $end, $total_length);
  }

  method get_content_type (GHashTable() $params) is also<get-content-type> {
    soup_message_headers_get_content_type($!smh, $params);
  }

  method get_encoding is also<get-encoding> {
    SoupEncoding( soup_message_headers_get_encoding($!smh) );
  }

  method get_expectations is also<get-expectations> {
    SoupExpectation( soup_message_headers_get_expectations($!smh) );
  }

  method get_headers_type is also<get-headers-type> {
    SoupMessageHeadersType( soup_message_headers_get_headers_type($!smh) );
  }

  method get_iter
    is also<
      get-iter
      iter
    >
  {
    SOUP::MessageHeaders::Iter.new(self);
  }

  method get_list (Str() $name) is also<get-list> {
    soup_message_headers_get_list($!smh, $name);
  }

  method get_one (Str() $name) is also<get-one> {
    soup_message_headers_get_one($!smh, $name);
  }

  proto method get_ranges (|)
      is also<get-ranges>
  { * }

  multi method get_ranges (Int() $total_length, :$raw = False) {
    my $r = CArray[Pointer[SoupRange]].new;
    $r[0] = Pointer[SoupRange];

    my $rv = samewith($total_length, $, $, :all, :$raw);
    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_ranges (
    Int() $total_length,
    CArray[Pointer[SoupRange]] $ranges,
    $length is rw,
    :$all = False,
    :$raw = False
  ) {
    my goffset $tl = $total_length;
    my gint $l = 0;

    my $rv = so soup_message_headers_get_ranges($!smh, $tl, $ranges, $l);
    $length = $l;

    my $r = $ranges[0] ?? $ranges[0] but GLib::Roles::TypedBuffer[SoupRange]
                       !! Nil;
    $r.setSize($length, :forced) if $r && $raw.not;

    $all.not ?? $rv !! ($rv, $raw ?? $r !! $r.Array);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_message_headers_get_type, $n, $t );
  }

  method header_contains (Str() $name, Str() $token) is also<header-contains> {
    soup_message_headers_header_contains($!smh, $name, $token);
  }

  method header_equals (Str() $name, Str() $value) is also<header-equals> {
    soup_message_headers_header_equals($!smh, $name, $value);
  }

  method remove (Str $name) {
    soup_message_headers_remove($!smh, $name);
  }

  method replace (Str $name, Str $value) {
    soup_message_headers_replace($!smh, $name, $value);
  }

  method set_content_disposition (Str() $disposition, GHashTable() $params)
    is also<set-content-disposition>
  {
    soup_message_headers_set_content_disposition($!smh, $disposition, $params);
  }

  method set_content_length (Int() $content_length) is also<set-content-length> {
    my goffset $c = $content_length;

    soup_message_headers_set_content_length($!smh, $c);
  }

  method set_content_range (Int() $start, Int() $end, Int() $total_length)
    is also<set-content-range>
  {
    my goffset ($s, $e, $l) = ($start, $end, $total_length);

    soup_message_headers_set_content_range($!smh, $s, $e, $l);
  }

  method set_content_type (Str() $content_type, GHashTable() $params)
    is also<set-content-type>
  {
    soup_message_headers_set_content_type($!smh, $content_type, $params);
  }

  method set_encoding (SoupEncoding() $encoding) is also<set-encoding> {
    soup_message_headers_set_encoding($!smh, $encoding);
  }

  method set_expectations (Int() $expectations) is also<set-expectations> {
    my SoupExpectation $e = $expectations;

    soup_message_headers_set_expectations($!smh, $e);
  }

  method set_range (Int() $start, Int() $end) is also<set-range> {
    my goffset ($s, $e) = ($start, $end);

    soup_message_headers_set_range($!smh, $s, $e);
  }

  proto method set_ranges (|)
      is also<set-ranges>
  { * }

  multi method set_ranges (@ranges) {
    samewith(
      GLib::Roles::TypedBuffer[SoupRange].new(@ranges).p,
      @ranges.elems
    );
  }
  multi method set_ranges (Pointer $ranges, Int() $length) {
    my gint $l = $length;

    soup_message_headers_set_ranges($!smh, $ranges, $l);
  }

}

class SOUP::MessageHeader::Iter {
  has SoupMessageHeadersIter $!smhi;

  multi method new (SoupMessageHeadersIter $iter) {
    $iter ?? self.bless( :$iter ) !! Nil;
  }
  multi method new (SoupMessageHeaders() $hdrs) {
    my $iter = SoupMessageHeadersIter.new;
    self.init($iter, $hdrs);

    $iter ?? self.bless( :$iter ) !! Nil;
  }

  method SOUP::Raw::Definitions::MessageHeaderIter
  { $!smhi }

  method init (
    SOUP::MessageHeader::Iter:U:
    SoupMessageHeadersIter $iter,
    SoupMessageHeaders $hdrs
  ) {
    soup_message_headers_iter_init($iter, $hdrs);
  }

  multi method next {
    my $rv = samewith($, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method next ($name is rw, $value is rw, :$all = False) {
    my $n = CArray[Str].new;
    my $v = CArray[Str].new;
    ($n, $v)».[0] = Str xx 2;

    my $rv = so soup_message_headers_iter_next($!smhi, $name, $value);

    ($name, $value) = ppr($n, $v);
    $all.not ?? $rv !! ($rv, $name, $value);
  }
}
