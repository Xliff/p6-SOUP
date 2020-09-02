use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use SOUP::Raw::Definitions;
use SOUP::Raw::Enums;

unit package SOUP::Raw::CookieJar;

### /usr/include/libsoup-2.4/libsoup/soup-cookie-jar.h

sub soup_cookie_jar_add_cookie (SoupCookieJar $jar, SoupCookie $cookie)
  is native(soup)
  is export
{ * }

sub soup_cookie_jar_add_cookie_full (
  SoupCookieJar $jar,
  SoupCookie $cookie,
  SoupURI $uri,
  SoupURI $first_party
)
  is native(soup)
  is export
{ * }

sub soup_cookie_jar_add_cookie_with_first_party (
  SoupCookieJar $jar,
  SoupURI $first_party,
  SoupCookie $cookie
)
  is native(soup)
  is export
{ * }

sub soup_cookie_jar_all_cookies (SoupCookieJar $jar)
  returns GSList
  is native(soup)
  is export
{ * }

sub soup_cookie_jar_delete_cookie (SoupCookieJar $jar, SoupCookie $cookie)
  is native(soup)
  is export
{ * }

sub soup_cookie_jar_get_accept_policy (SoupCookieJar $jar)
  returns SoupCookieJarAcceptPolicy
  is native(soup)
  is export
{ * }

sub soup_cookie_jar_get_cookie_list (
  SoupCookieJar $jar,
  SoupURI $uri,
  gboolean $for_http
)
  returns GSList
  is native(soup)
  is export
{ * }

sub soup_cookie_jar_get_cookie_list_with_same_site_info (
  SoupCookieJar $jar,
  SoupURI $uri,
  SoupURI $top_level,
  SoupURI $site_for_cookies,
  gboolean $for_http,
  gboolean $is_safe_method,
  gboolean $is_top_level_navigation
)
  returns GSList
  is native(soup)
  is export
{ * }

sub soup_cookie_jar_get_cookies (
  SoupCookieJar $jar,
  SoupURI $uri,
  gboolean $for_http
)
  returns gchar
  is native(soup)
  is export
{ * }

sub soup_cookie_jar_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_cookie_jar_is_persistent (SoupCookieJar $jar)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_cookie_jar_new ()
  returns SoupCookieJar
  is native(soup)
  is export
{ * }

sub soup_cookie_jar_save (SoupCookieJar $jar)
  is native(soup)
  is export
{ * }

sub soup_cookie_jar_set_accept_policy (
  SoupCookieJar $jar,
  SoupCookieJarAcceptPolicy $policy
)
  is native(soup)
  is export
{ * }

sub soup_cookie_jar_set_cookie (SoupCookieJar $jar, SoupURI $uri, Str $cookie)
  is native(soup)
  is export
{ * }

sub soup_cookie_jar_set_cookie_with_first_party (
  SoupCookieJar $jar,
  SoupURI $uri,
  SoupURI $first_party,
  Str $cookie
)
  is native(soup)
  is export
{ * }
