use v6.c;

use Method::Also;

use SOUP::Raw::Types;
use SOUP::Raw::Cookie;

use GLib::GList;
use SOUP::Date;

use GLib::Roles::ListData;
use GLib::Roles::StaticClass;

# BOXED

class SOUP::Cookie {
  has SoupCookie $!sc;

  submethod BUILD (:$cookie) {
    $!sc = $cookie;
  }

  method SOUP::Raw::Definitions::SoupCookie
    is also<SoupCookie>
  { $!sc }

  multi method new (SOUP::Cookie:U: SoupCookie $cookie) {
    $cookie ?? self.bless( :$cookie ) !! Nil;
  }
  multi method new (SOUP::Cookie:U:
    Str() $value,
    Str() $domain,
    Str() $path,
    Int() $max_age
  ) {
    my gint $m = $max_age;
    my $cookie = soup_cookie_new($value, $domain, $path, $m);

    $cookie ?? self.bless( :$cookie ) !! Nil;
  }
  multi method new (Str() $header, SoupURI() $origin, :$parse is required) {
    SOUP::Cookie.parse($header, $origin);
  }

  method parse (SOUP::Cookie:U: Str() $header, SoupURI() $origin) {
    my $cookie = soup_cookie_parse($header, $origin);

    $cookie ?? self.bless( :$cookie ) !! Nil;
  }

  method domain is rw {
    Proxy.new:
      FETCH => -> $                { self.get_domain    },
      STORE => -> $, Str() \d,     { self.set_domain(d) };
  }

  method expires (:$raw = False) is rw {
    Proxy.new:
      FETCH => -> $                { self.get_expires(:$raw) },
      STORE => -> $, SoupDate() \d { self.set_date(d)        };
  }
  method http_only is rw is also<http-only> {
    Proxy.new:
      FETCH => -> $                { self.get_http_only    },
      STORE => -> $, Int() \h      { self.set_http_only(h) };
  }

  method max_age is rw is also<max-age> {
    Proxy.new:
      FETCH => -> $                { self.get_max_age    },
      STORE => -> $, Int() \mx     { self.set_max_age(mx) };
  }
  method name is rw {
    Proxy.new:
      FETCH => -> $                { self.get_name    },
      STORE => -> $, Str() \n      { self.set_name(n) };
  }

  method path is rw {
    Proxy.new:
      FETCH => -> $                { self.get_path    },
      STORE => -> $, Str() \p      { self.set_path(p) };
  }
  method same_site_policy is rw is also<same-site-policy> {
    Proxy.new:
      FETCH => -> $                { self.get_same_site_policy    },
      STORE => -> $, Int() \p      { self.set_same_site_policy(p) };
  }

  method secure is rw {
    Proxy.new:
      FETCH => -> $                { self.get_secure    },
      STORE => -> $, Int() \s      { self.set_secure(s) };
  }

  method value is rw {
    Proxy.new:
      FETCH => -> $                { self.get_value    },
      STORE => -> $, Str() \v      { self.set_value(v) };
  }

  method applies_to_uri (SoupURI() $uri) is also<applies-to-uri> {
    so soup_cookie_applies_to_uri($!sc, $uri);
  }

  multi method copy (:$raw = False) {
    SOUP::Cookie.copy($!sc, :$raw);
  }
  multi method copy (SOUP::Cookie:U: $to-copy, :$raw = False) {
    my $copy = soup_cookie_copy($to-copy);

    $copy ??
       ( $raw ?? $copy !! SOUP::Cookie.new($copy) )
       !!
       Nil;
  }

  method domain_matches (Str() $host) is also<domain-matches> {
    so soup_cookie_domain_matches($!sc, $host);
  }

  method equal (SoupCookie() $cookie2) {
    so soup_cookie_equal($!sc, $cookie2);
  }

  method free {
    soup_cookie_free($!sc);
  }

  method get_domain is also<get-domain> {
    soup_cookie_get_domain($!sc);
  }

  method get_expires (:$raw = False) is also<get-expires> {
    my $d = soup_cookie_get_expires($!sc);

    $d ??
      ( $raw ?? $d !! SOUP::Date.new($d) )
      !!
      Nil
  }

  method get_http_only is also<get-http-only> {
    so soup_cookie_get_http_only($!sc);
  }

  method get_name is also<get-name> {
    soup_cookie_get_name($!sc);
  }

  method get_path is also<get-path> {
    soup_cookie_get_path($!sc);
  }

  method get_same_site_policy is also<get-same-site-policy> {
    SoupSameSitePolicyEnum( soup_cookie_get_same_site_policy($!sc) );
  }

  method get_secure is also<get-secure> {
    so soup_cookie_get_secure($!sc);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_cookie_get_type, $n, $t );
  }

  method get_value is also<get-value> {
    soup_cookie_get_value($!sc);
  }

  method set_domain (Str() $domain) is also<set-domain> {
    soup_cookie_set_domain($!sc, $domain);
  }

  method set_expires (SoupDate() $expires) is also<set-expires> {
    soup_cookie_set_expires($!sc, $expires);
  }

  method set_http_only (Int() $http_only) is also<set-http-only> {
    my gboolean $h = $http_only.so.Int;

    soup_cookie_set_http_only($!sc, $h);
  }

  method set_max_age (Int() $max_age) is also<set-max-age> {
    my gint $m = $max_age;

    soup_cookie_set_max_age($!sc, $m);
  }

  method set_name (Str() $name) is also<set-name> {
    soup_cookie_set_name($!sc, $name);
  }

  method set_path (Str() $path) is also<set-path> {
    soup_cookie_set_path($!sc, $path);
  }

  method set_same_site_policy (Int() $policy) is also<set-same-site-policy> {
    my SoupSameSitePolicy $p = $policy;

    soup_cookie_set_same_site_policy($!sc, $p);
  }

  method set_secure (Int() $secure) is also<set-secure> {
    my gboolean $s = $secure.so.Int;

    soup_cookie_set_secure($!sc, $s);
  }

  method set_value (Str() $value) is also<set-value> {
    soup_cookie_set_value($!sc, $value);
  }

  method to_cookie_header is also<to-cookie-header> {
    soup_cookie_to_cookie_header($!sc);
  }

  method to_set_cookie_header is also<to-set-cookie-header> {
    soup_cookie_to_set_cookie_header($!sc);
  }

}

class SOUP::Cookies {
  also does GLib::Roles::StaticClass;

  method free (GSList() $cookies) {
    soup_cookies_free($cookies);
  }

  method from_request (SoupMessage() $msg, :$glist = False, :$raw = False)
    is also<from-request>
  {
    my $cl = soup_cookies_from_request($msg);

    return Nil unless $cl;
    return $cl if $glist && $raw;

    # Currently must use GList for retrieval.
    $cl = GLib::GList.new($cl) but GLib::Roles::ListData[SoupCookie];

    return $cl if $glist;

    $raw ?? $cl.Array !! $cl.Array.map({ SOUP::Cookie.new($_) });
  }

  method from_response (SoupMessage() $msg, :$glist = False, :$raw = False)
    is also<from-response>
  {
    my $cl = soup_cookies_from_response($msg);

    return Nil unless $cl;
    return $cl if $glist && $raw;

    # Currently must use GList for retrieval.
    $cl = GLib::GList.new($cl) but GLib::Roles::ListData[SoupCookie];

    return $cl if $glist;

    $raw ?? $cl.Array !! $cl.Array.map({ SOUP::Cookie.new($_) });
  }

  method to_cookie_header (GSList() $cookies) is also<to-cookie-header> {
    soup_cookies_to_cookie_header($cookies);
  }

  method to_request (GSList() $cookies, SoupMessage() $msg)
    is also<to-request>
  {
    soup_cookies_to_request($cookies, $msg);
  }

  method to_response (GSList() $cookies, SoupMessage() $msg)
    is also<to-response>
  {
    soup_cookies_to_response($cookies, $msg);
  }
}
