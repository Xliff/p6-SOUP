use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use SOUP::Raw::Definitions;
use SOUP::Raw::Enums;

unit package SOUP::Raw::Cookie;


### /usr/include/libsoup-2.4/libsoup/soup-cookie.h

sub soup_cookie_applies_to_uri (SoupCookie $cookie, SoupURI $uri)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_cookie_copy (SoupCookie $cookie)
  returns SoupCookie
  is native(soup)
  is export
{ * }

sub soup_cookie_domain_matches (SoupCookie $cookie, Str $host)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_cookie_equal (SoupCookie $cookie1, SoupCookie $cookie2)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_cookie_free (SoupCookie $cookie)
  is native(soup)
  is export
{ * }

sub soup_cookie_get_domain (SoupCookie $cookie)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_cookie_get_expires (SoupCookie $cookie)
  returns SoupDate
  is native(soup)
  is export
{ * }

sub soup_cookie_get_http_only (SoupCookie $cookie)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_cookie_get_name (SoupCookie $cookie)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_cookie_get_path (SoupCookie $cookie)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_cookie_get_same_site_policy (SoupCookie $cookie)
  returns SoupSameSitePolicy
  is native(soup)
  is export
{ * }

sub soup_cookie_get_secure (SoupCookie $cookie)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_cookie_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_cookie_get_value (SoupCookie $cookie)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_cookie_new (
  Str $name,
  Str $value,
  Str $domain,
  Str $path,
  gint $max_age
)
  returns SoupCookie
  is native(soup)
  is export
{ * }

sub soup_cookie_parse (Str $header, SoupURI $origin)
  returns SoupCookie
  is native(soup)
  is export
{ * }

sub soup_cookie_set_domain (SoupCookie $cookie, Str $domain)
  is native(soup)
  is export
{ * }

sub soup_cookie_set_expires (SoupCookie $cookie, SoupDate $expires)
  is native(soup)
  is export
{ * }

sub soup_cookie_set_http_only (SoupCookie $cookie, gboolean $http_only)
  is native(soup)
  is export
{ * }

sub soup_cookie_set_max_age (SoupCookie $cookie, gint $max_age)
  is native(soup)
  is export
{ * }

sub soup_cookie_set_name (SoupCookie $cookie, Str $name)
  is native(soup)
  is export
{ * }

sub soup_cookie_set_path (SoupCookie $cookie, Str $path)
  is native(soup)
  is export
{ * }

sub soup_cookie_set_same_site_policy (
  SoupCookie $cookie,
  SoupSameSitePolicy $policy
)
  is native(soup)
  is export
{ * }

sub soup_cookie_set_secure (SoupCookie $cookie, gboolean $secure)
  is native(soup)
  is export
{ * }

sub soup_cookie_set_value (SoupCookie $cookie, Str $value)
  is native(soup)
  is export
{ * }

sub soup_cookie_to_cookie_header (SoupCookie $cookie)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_cookie_to_set_cookie_header (SoupCookie $cookie)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_cookies_free (GSList $cookies)
  is native(soup)
  is export
{ * }

sub soup_cookies_from_request (SoupMessage $msg)
  returns GSList
  is native(soup)
  is export
{ * }

sub soup_cookies_from_response (SoupMessage $msg)
  returns GSList
  is native(soup)
  is export
{ * }

sub soup_cookies_to_cookie_header (GSList $cookies)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_cookies_to_request (GSList $cookies, SoupMessage $msg)
  is native(soup)
  is export
{ * }

sub soup_cookies_to_response (GSList $cookies, SoupMessage $msg)
  is native(soup)
  is export
{ * }
