use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use SOUP::Raw::Definitions;

unit package SOUP::Raw::Multipart;

### /usr/include/libsoup-2.4/libsoup/soup-multipart.h

sub soup_multipart_append_form_file (
  SoupMultipart $multipart,
  Str $control_name,
  Str $filename,
  Str $content_type,
  SoupBuffer $body
)
  is native(soup)
  is export
{ * }

sub soup_multipart_append_form_string (
  SoupMultipart $multipart,
  Str $control_name,
  Str $data
)
  is native(soup)
  is export
{ * }

sub soup_multipart_append_part (
  SoupMultipart $multipart,
  SoupMessageHeaders $headers,
  SoupBuffer $body
)
  is native(soup)
  is export
{ * }

sub soup_multipart_free (SoupMultipart $multipart)
  is native(soup)
  is export
{ * }

sub soup_multipart_get_length (SoupMultipart $multipart)
  returns gint
  is native(soup)
  is export
{ * }

sub soup_multipart_get_part (
  SoupMultipart $multipart,
  gint $part,
  SoupMessageHeaders $headers,
  SoupBuffer $body
)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_multipart_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_multipart_new (Str $mime_type)
  returns SoupMultipart
  is native(soup)
  is export
{ * }

sub soup_multipart_new_from_message (
  SoupMessageHeaders $headers,
  SoupMessageBody $body
)
  returns SoupMultipart
  is native(soup)
  is export
{ * }

sub soup_multipart_to_message (
  SoupMultipart $multipart,
  SoupMessageHeaders $dest_headers,
  SoupMessageBody $dest_body
)
  is native(soup)
  is export
{ * }
