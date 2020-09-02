use v6.c;

use Method::Also;

use SOUP::Raw::Types;
use SOUP::Raw::CookieJar;

use GLib::Roles::Object;
use SOUP::Roles::SessionFeature;
use SOUP::Roles::Signals::CookieJar;

our subset SoupCookieJarAncestry is export of Mu
  where SoupCookieJar | SoupSessionFeature | GObject;

class SOUP::CookieJar {
  also does GLib::Roles::Object;
  also does SOUP::Roles::SessionFeature;
  also does SOUP::Roles::Signals::CookieJar;

  has SoupCookieJar $!scj;

  submethod BUILD (:$cookie-jar) {
    self.setSoupCookieJar($cookie-jar) if $cookie-jar;
  }

  method setSoupCookieJar (SoupCookieJarAncestry $_) {
    my $to-parent;

    $!scj = do {
      when SoupCookieJar {
        $to-parent = cast(GObject, $_);
        $_;
      }

      when SoupSessionFeature {
        $to-parent = cast(GObject, $_);
        $!sf = $_;
        cast(SoupCookieJar, $_);
      }

      default {
        $to-parent = $_;
        cast(SoupCookieJar, $_);
      }
    }
    self!setObject($to-parent);
    self.roleInit-SoupSessionFeature unless $!sf;
  }

  method SOUP::Raw::Definitions::SoupCookieJar
    is also<SoupCookieJar>
  { $!scj }

  multi method new (SoupCookieJarAncestry $cookie-jar) {
    $cookie-jar ?? self.bless( :$cookie-jar ) !! Nil;
  }
  multi method new {
    my $cookie-jar = soup_cookie_jar_new();

    $cookie-jar ?? self.bless( :$cookie-jar ) !! Nil;
  }

  # Type: SoupCookieJarAcceptPolicy
  method accept-policy is rw  is also<accept_policy> {
    Proxy.new:
      FETCH => -> $           { self.get_accept_policy },
      STORE => -> $, Int() $i { self.set_accept_policy($i) };
  }

  # Type: gboolean
  method read-only is rw  is also<read_only> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('read-only', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        warn 'read-only is a construct-only attribute'
      }
    );
  }

  # Is originally:
  # SoupCookieJar, SoupCookie, SoupCookie, gpointer --> void
  method changed {
    self.connect-changed($!scj);
  }

  method add_cookie (SoupCookie() $cookie) is also<add-cookie> {
    soup_cookie_jar_add_cookie($!scj, $cookie);
  }

  method add_cookie_full (
    SoupCookie() $cookie,
    SoupURI() $uri,
    SoupURI() $first_party
  )
    is also<add-cookie-full>
  {
    soup_cookie_jar_add_cookie_full($!scj, $cookie, $uri, $first_party);
  }

  method add_cookie_with_first_party (
    SoupURI() $first_party,
    SoupCookie() $cookie
  )
    is also<add-cookie-with-first-party>
  {
    soup_cookie_jar_add_cookie_with_first_party($!scj, $first_party, $cookie);
  }

  method all_cookies (:$glist = False, :$raw = False) is also<all-cookies> {
    my $cl = soup_cookie_jar_all_cookies($!scj);
    return Nil unless $cl;
    return $cl if $glist && $raw;

    # GSList...Using GList for compatibility
    $cl = GLib::GList.new($cl) but GLib::Roles::ListData[SoupCookie];
    return $cl if $glist;

    $raw ?? $cl.Array !! $cl.Array.map({ SOUP::Cookie.new($_) });
  }

  method delete_cookie (SoupCookie() $cookie) is also<delete-cookie> {
    soup_cookie_jar_delete_cookie($!scj, $cookie);
  }

  method get_accept_policy is also<get-accept-policy> {
    SoupCookieJarAcceptPolicyEnum( soup_cookie_jar_get_accept_policy($!scj) );
  }

  method get_cookie_list (
    SoupURI() $uri,
    Int() $for_http,
    :$glist = False,
    :$raw = False
  )
    is also<get-cookie-list>
  {
    my gboolean $f = $for_http.so.Int;

    my $cl = soup_cookie_jar_get_cookie_list($!scj, $uri, $f);
    return Nil unless $cl;
    return $cl if $glist && $raw;

    # GSList...Using GList for compatibility
    $cl = GLib::GList.new($cl) but GLib::Roles::ListData[SoupCookie];
    return $cl if $glist;

    $raw ?? $cl.Array !! $cl.Array.map({ SOUP::Cookie.new($_) });
  }

  method get_cookie_list_with_same_site_info (
    SoupURI() $uri,
    SoupURI() $top_level,
    SoupURI() $site_for_cookies,
    Int() $for_http,
    Int() $is_safe_method,
    Int() $is_top_level_navigation
  )
    is also<get-cookie-list-with-same-site-info>
  {
    my gboolean ($f, $is, $it) =
      ($for_http, $is_safe_method, $is_top_level_navigation).map( *.so.Int );

    soup_cookie_jar_get_cookie_list_with_same_site_info(
      $!scj,
      $uri,
      $top_level,
      $site_for_cookies,
      $f,
      $is,
      $it
    )
  }

  method get_cookies (SoupURI() $uri, Int() $for_http) is also<get-cookies> {
    my gboolean $f = $for_http.so.Int;

    soup_cookie_jar_get_cookies($!scj, $uri, $for_http);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_cookie_jar_get_type, $n, $t );
  }

  method is_persistent is also<is-persistent> {
    so soup_cookie_jar_is_persistent($!scj);
  }

  method save {
    soup_cookie_jar_save($!scj);
  }

  method set_accept_policy (Int() $policy) is also<set-accept-policy> {
    my SoupCookieJarAcceptPolicy $p = $policy;

    soup_cookie_jar_set_accept_policy($!scj, $p);
  }

  method set_cookie (SoupURI() $uri, Str() $cookie) is also<set-cookie> {
    soup_cookie_jar_set_cookie($!scj, $uri, $cookie);
  }

  method set_cookie_with_first_party (
    SoupURI() $uri,
    SoupURI() $first_party,
    Str() $cookie
  )
    is also<set-cookie-with-first-party>
  {
    soup_cookie_jar_set_cookie_with_first_party(
      $!scj,
      $uri,
      $first_party,
      $cookie
    );
  }

}
