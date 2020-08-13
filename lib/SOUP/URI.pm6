use v6.c;

use Method::Also;

use SOUP::Raw::Types;
use SOUP::Raw::URI;

# BOXED

class SOUP::URI {
  has SoupURI $!su;

  submethod BUILD ( :uri(:$!su) )
  { }

  method SOUP::Raw::Definitions::SoupURI
    is also<SoupURI>
  { $!su }

  multi method new (SoupURI $uri) {
    $uri ?? self.bless( :$uri ) !! Nil;
  }
  multi method new (Str $uri-str) {
    my $uri = soup_uri_new($uri-str);

    $uri ?? self.bless( :$uri ) !! Nil;
  }

  multi method new (SoupURI() $b, Str() $uri_string, :$base is required) {
    SOUP::URI.new_with_base($b, $uri_string);
  }
  method new_with_base (SoupURI() $base, Str() $uri_string)
    is also<new-with-base>
  {
    my $uri = soup_uri_new_with_base($base, $uri_string);
    $uri ?? self.bless( :$uri ) !! Nil;
  }

  method copy (:$raw = False) {
    my $u = soup_uri_copy($!su);

    $u ??
      ($raw ?? $u !! SOUP::URI.new($u) )
      !!
      Nil;
  }

  method copy_host  (:$raw = False) is also<copy-host> {
    my $u = soup_uri_copy_host($!su);

    $u ??
      ($raw ?? $u !! SOUP::URI.new($u) )
      !!
      Nil;
  }

  method decode (SOUP::URI:U: Str() $part) {
    soup_uri_decode($part);
  }

  method encode (SOUP::URI:U: Str() $part, Str() $escape_extra) {
    soup_uri_encode($part, $escape_extra);
  }

  method equal (SoupURI() $uri2) {
    soup_uri_equal($!su, $uri2);
  }

  method free {
    soup_uri_free($!su);
  }

  method get_fragment is also<get-fragment> {
    soup_uri_get_fragment($!su);
  }

  method get_host is also<get-host> {
    soup_uri_get_host($!su);
  }

  method get_password is also<get-password> {
    soup_uri_get_password($!su);
  }

  method get_path is also<get-path> {
    soup_uri_get_path($!su);
  }

  method get_port is also<get-port> {
    soup_uri_get_port($!su);
  }

  method get_query is also<get-query> {
    soup_uri_get_query($!su);
  }

  method get_scheme is also<get-scheme> {
    soup_uri_get_scheme($!su);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_uri_get_type, $n, $t );
  }

  method get_user is also<get-user> {
    soup_uri_get_user($!su);
  }

  method host_equal (SoupURI() $v2) is also<host-equal> {
    soup_uri_host_equal($!su, $v2);
  }

  method host_hash is also<host-hash> {
    soup_uri_host_hash($!su);
  }

  method is_valid is also<is-valid> {
    $!su.scheme && $!su.port;
  }

  method valid_for_http {
    [&&](
      $!su.scheme-check(%SOUP-URI-SCHEME<http https>.any).so,
      $!su.host,
      $!su.path
    );
  }

  method normalize (
    SOUP::URI:U:
    Str() $part,
    Str() $unescape_extra
  ) {
    soup_uri_normalize($part, $unescape_extra);
  }

  method set_fragment (Str() $fragment) is also<set-fragment> {
    soup_uri_set_fragment($!su, $fragment);
  }

  method set_host (Str() $host) is also<set-host> {
    soup_uri_set_host($!su, $host);
  }

  method set_password (Str() $password) is also<set-password> {
    soup_uri_set_password($!su, $password);
  }

  method set_path (Str() $path) is also<set-path> {
    soup_uri_set_path($!su, $path);
  }

  method set_port (Int() $port) is also<set-port> {
    my guint $p = $port;

    soup_uri_set_port($!su, $p);
  }

  method set_query (Str() $query) is also<set-query> {
    soup_uri_set_query($!su, $query);
  }

  proto method set_query_from_fields (|)
      is also<set-query-from-fields>
  { * }

  multi method set_query_from_fields (%data) {
    samewith( %data.pairs.map({ .key, .value }).flat );
  }
  multi method set_query_from_fields (@data) {
    samewith(|@data);
  }
  multi method set_query_from_fields (*@data) {
    soup_uri_set_query_from_fields($!su, .[0], .[1], Str) for @data.rotor(2);
  }

  method set_query_from_form (GHashTable() $form) is also<set-query-from-form> {
    soup_uri_set_query_from_form($!su, $form);
  }

  method set_scheme (Str() $scheme) is also<set-scheme> {
    soup_uri_set_scheme($!su, $scheme);
  }

  method set_user (Str() $user) is also<set-user> {
    soup_uri_set_user($!su, $user);
  }

  method Str {
    self.to_string;
  }
  method to_string (Int() $just_path_and_query = False) is also<to-string> {
    my gboolean $j = $just_path_and_query.so.Int;

    soup_uri_to_string($!su, $j);
  }

  method uses_default_port is also<uses-default-port> {
    soup_uri_uses_default_port($!su);
  }

}
