use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use SOUP::Raw::Definitions;
use SOUP::Raw::Enums;

unit package SOUP::Raw::MessageHeaders;

### /usr/include/libsoup-2.4/libsoup/soup-message-headers.h

sub soup_message_headers_append (
  SoupMessageHeaders $hdrs,
  Str $name,
  Str $value
)
  is native(soup)
  is export
{ * }

sub soup_message_headers_clean_connection_headers (SoupMessageHeaders $hdrs)
  is native(soup)
  is export
{ * }

sub soup_message_headers_clear (SoupMessageHeaders $hdrs)
  is native(soup)
  is export
{ * }

sub soup_message_headers_foreach (
  SoupMessageHeaders $hdrs,
  &func (Str, Str, gpointer),
  gpointer $user_data
)
  is native(soup)
  is export
{ * }

sub soup_message_headers_free (SoupMessageHeaders $hdrs)
  is native(soup)
  is export
{ * }

sub soup_message_headers_free_ranges (
  SoupMessageHeaders $hdrs,
  SoupRange $ranges
)
  is native(soup)
  is export
{ * }

sub soup_message_headers_get (SoupMessageHeaders $hdrs, Str $name)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_message_headers_get_content_disposition (
  SoupMessageHeaders $hdrs,
  Str $disposition,
  GHashTable $params
)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_message_headers_get_content_length (SoupMessageHeaders $hdrs)
  returns goffset
  is native(soup)
  is export
{ * }

sub soup_message_headers_get_content_range (
  SoupMessageHeaders $hdrs,
  goffset $start,
  goffset $end,
  goffset $total_length
)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_message_headers_get_content_type (
  SoupMessageHeaders $hdrs,
  GHashTable $params
)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_message_headers_get_encoding (SoupMessageHeaders $hdrs)
  returns SoupEncoding
  is native(soup)
  is export
{ * }

sub soup_message_headers_get_expectations (SoupMessageHeaders $hdrs)
  returns SoupExpectation
  is native(soup)
  is export
{ * }

sub soup_message_headers_get_headers_type (SoupMessageHeaders $hdrs)
  returns SoupMessageHeadersType
  is native(soup)
  is export
{ * }

sub soup_message_headers_get_list (SoupMessageHeaders $hdrs, Str $name)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_message_headers_get_one (SoupMessageHeaders $hdrs, Str $name)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_message_headers_get_ranges (
  SoupMessageHeaders $hdrs,
  goffset $total_length,
  CArray[Pointer[SoupRange]] $ranges,
  gint $length is rw
)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_message_headers_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_message_headers_header_contains (
  SoupMessageHeaders $hdrs,
  Str $name,
  Str $token
)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_message_headers_header_equals (
  SoupMessageHeaders $hdrs,
  Str $name,
  Str $value
)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_message_headers_iter_init (
  SoupMessageHeadersIter $iter,
  SoupMessageHeaders $hdrs
)
  is native(soup)
  is export
{ * }

sub soup_message_headers_iter_next (
  SoupMessageHeadersIter $iter,
  CArray[Str] $name,
  CArray[Str] $value
)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_message_headers_new (SoupMessageHeadersType $type)
  returns SoupMessageHeaders
  is native(soup)
  is export
{ * }

sub soup_message_headers_remove (SoupMessageHeaders $hdrs, Str $name)
  is native(soup)
  is export
{ * }

sub soup_message_headers_replace (
  SoupMessageHeaders $hdrs,
  Str $name,
  Str $value
)
  is native(soup)
  is export
{ * }

sub soup_message_headers_set_content_disposition (
  SoupMessageHeaders $hdrs,
  Str $disposition,
  GHashTable $params
)
  is native(soup)
  is export
{ * }

sub soup_message_headers_set_content_length (
  SoupMessageHeaders $hdrs,
  goffset $content_length
)
  is native(soup)
  is export
{ * }

sub soup_message_headers_set_content_range (
  SoupMessageHeaders $hdrs,
  goffset $start,
  goffset $end,
  goffset $total_length
)
  is native(soup)
  is export
{ * }

sub soup_message_headers_set_content_type (
  SoupMessageHeaders $hdrs,
  Str $content_type,
  GHashTable $params
)
  is native(soup)
  is export
{ * }

sub soup_message_headers_set_encoding (
  SoupMessageHeaders $hdrs,
  SoupEncoding $encoding
)
  is native(soup)
  is export
{ * }

sub soup_message_headers_set_expectations (
  SoupMessageHeaders $hdrs,
  SoupExpectation $expectations
)
  is native(soup)
  is export
{ * }

sub soup_message_headers_set_range (
  SoupMessageHeaders $hdrs,
  goffset $start,
  goffset $end
)
  is native(soup)
  is export
{ * }

sub soup_message_headers_set_ranges (
  SoupMessageHeaders $hdrs,
  Pointer $ranges,  # Array of SoupRange
  gint $length
)
  is native(soup)
  is export
{ * }
