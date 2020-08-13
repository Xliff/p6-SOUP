use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use SOUP::Raw::Definitions;

unit package SOUP::Raw::URI;


### /usr/include/libsoup-2.4/libsoup/soup-uri.h

sub soup_uri_copy (SoupURI $uri)
  returns SoupURI
  is native(soup)
  is export
{ * }

sub soup_uri_copy_host (SoupURI $uri)
  returns SoupURI
  is native(soup)
  is export
{ * }

sub soup_uri_decode (Str $part)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_uri_encode (Str $part, Str $escape_extra)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_uri_equal (SoupURI $uri1, SoupURI $uri2)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_uri_free (SoupURI $uri)
  is native(soup)
  is export
{ * }

sub soup_uri_get_fragment (SoupURI $uri)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_uri_get_host (SoupURI $uri)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_uri_get_password (SoupURI $uri)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_uri_get_path (SoupURI $uri)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_uri_get_port (SoupURI $uri)
  returns guint
  is native(soup)
  is export
{ * }

sub soup_uri_get_query (SoupURI $uri)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_uri_get_scheme (SoupURI $uri)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_uri_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_uri_get_user (SoupURI $uri)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_uri_host_equal (SoupURI $v1, SoupURI $v2)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_uri_host_hash (SoupURI $key)
  returns guint
  is native(soup)
  is export
{ * }

sub soup_uri_new (Str $uri_string)
  returns SoupURI
  is native(soup)
  is export
{ * }

sub soup_uri_new_with_base (SoupURI $base, Str $uri_string)
  returns SoupURI
  is native(soup)
  is export
{ * }

sub soup_uri_normalize (Str $part, Str $unescape_extra)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_uri_set_fragment (SoupURI $uri, Str $fragment)
  is native(soup)
  is export
{ * }

sub soup_uri_set_host (SoupURI $uri, Str $host)
  is native(soup)
  is export
{ * }

sub soup_uri_set_password (SoupURI $uri, Str $password)
  is native(soup)
  is export
{ * }

sub soup_uri_set_path (SoupURI $uri, Str $path)
  is native(soup)
  is export
{ * }

sub soup_uri_set_port (SoupURI $uri, guint $port)
  is native(soup)
  is export
{ * }

sub soup_uri_set_query (SoupURI $uri, Str $query)
  is native(soup)
  is export
{ * }

sub soup_uri_set_query_from_fields (SoupURI $uri, Str $first_field, Str)
  is native(soup)
  is export
{ * }

sub soup_uri_set_query_from_form (SoupURI $uri, GHashTable $form)
  is native(soup)
  is export
{ * }

sub soup_uri_set_scheme (SoupURI $uri, Str $scheme)
  is native(soup)
  is export
{ * }

sub soup_uri_set_user (SoupURI $uri, Str $user)
  is native(soup)
  is export
{ * }

sub soup_uri_to_string (SoupURI $uri, gboolean $just_path_and_query)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_uri_uses_default_port (SoupURI $uri)
  returns uint32
  is native(soup)
  is export
{ * }
