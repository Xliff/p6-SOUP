use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use SOUP::Raw::Definitions;

unit package SOUP::Raw::AuthDomain;

### /usr/include/libsoup-2.4/libsoup/soup-auth-domain.h

sub sprintf-auth-domain-filter (
  Blob,
  Str,
  & (SoupAuthDomain, SoupMessage, gpointer --> boolean)
)
  returns int64
  is export
  is native
  is symbol('sprintf')
{ * }

sub sprintf-auth-domain-generic-auth-callback (
  Blob,
  Str,
  & (SoupAuthDomain, SoupMessage, Str, gpointer --> boolean)
)
  returns int64
  is export
  is native
  is symbol('sprintf')
{ * }

sub soup_auth_domain_accepts (SoupAuthDomain $domain, SoupMessage $msg)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_auth_domain_add_path (SoupAuthDomain $domain, Str $path)
  is native(soup)
  is export
{ * }

sub soup_auth_domain_challenge (SoupAuthDomain $domain, SoupMessage $msg)
  is native(soup)
  is export
{ * }

sub soup_auth_domain_check_password (
  SoupAuthDomain $domain,
  SoupMessage $msg,
  Str $username,
  Str $password
)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_auth_domain_covers (SoupAuthDomain $domain, SoupMessage $msg)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_auth_domain_get_realm (SoupAuthDomain $domain)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_auth_domain_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_auth_domain_remove_path (SoupAuthDomain $domain, Str $path)
  is native(soup)
  is export
{ * }

sub soup_auth_domain_set_filter (
  SoupAuthDomain $domain,
  &filter (SoupAuthDomain, SoupMessage, pointer --> gboolean),
  gpointer $filter_data,
  GDestroyNotify $dnotify
)
  is native(soup)
  is export
{ * }

sub soup_auth_domain_set_generic_auth_callback (
  SoupAuthDomain $domain,
  &auth_callback (SoupAuthDomain, SoupMessage, Str, gpointer --> boolean),
  gpointer $auth_data,
  GDestroyNotify $dnotify
)
  is native(soup)
  is export
{ * }

sub soup_auth_domain_try_generic_auth_callback (
  SoupAuthDomain $domain,
  SoupMessage $msg,
  Str $username
)
  returns uint32
  is native(soup)
  is export
{ * }
