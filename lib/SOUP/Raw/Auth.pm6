use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use SOUP::Raw::Definitions;

unit package SOUP::Raw::Auth;

### /usr/include/libsoup-2.4/libsoup/soup-auth.h

sub soup_auth_authenticate (SoupAuth $auth, Str $username, Str $password)
  is native(soup)
  is export
{ * }

sub soup_auth_basic_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_auth_can_authenticate (SoupAuth $auth)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_auth_digest_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_auth_free_protection_space (SoupAuth $auth, GSList $space)
  is native(soup)
  is export
{ * }

sub soup_auth_get_authorization (SoupAuth $auth, SoupMessage $msg)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_auth_get_host (SoupAuth $auth)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_auth_get_info (SoupAuth $auth)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_auth_get_protection_space (SoupAuth $auth, SoupURI $source_uri)
  returns GList # GSList
  is native(soup)
  is export
{ * }

sub soup_auth_get_realm (SoupAuth $auth)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_auth_get_saved_password (SoupAuth $auth, Str $user)
  returns Str
  is DEPRECATED
  is native(soup)
  is export
{ * }

sub soup_auth_get_saved_users (SoupAuth $auth)
  returns GList # GSList
  is DEPRECATED
  is native(soup)
  is export
{ * }

sub soup_auth_get_scheme_name (SoupAuth $auth)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_auth_has_saved_password (
  SoupAuth $auth,
  Str $username,
  Str $password
)
  is DEPRECATED
  is native(soup)
  is export
{ * }

sub soup_auth_is_authenticated (SoupAuth $auth)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_auth_is_for_proxy (SoupAuth $auth)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_auth_is_ready (SoupAuth $auth, SoupMessage $msg)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_auth_negotiate_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_auth_negotiate_supported ()
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_auth_new (GType $type, SoupMessage $msg, Str $auth_header)
  returns SoupAuth
  is native(soup)
  is export
{ * }

sub soup_auth_ntlm_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_auth_save_password (SoupAuth $auth, Str $username, Str $password)
  is DEPRECATED
  is native(soup)
  is export
{ * }

sub soup_auth_update (SoupAuth $auth, SoupMessage $msg, Str $auth_header)
  returns uint32
  is native(soup)
  is export
{ * }
