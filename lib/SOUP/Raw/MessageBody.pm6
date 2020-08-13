use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use SOUP::Raw::Definitions;
use SOUP::Raw::Enums;

unit package SOUP::Raw::MessageBody;

### /usr/include/libsoup-2.4/libsoup/soup-message-body.h

sub soup_message_body_append (
  SoupMessageBody $body,
  SoupMemoryUse $use,
  Pointer $data,
  gsize $length
)
  is native(soup)
  is export
{ * }

sub soup_message_body_append_buffer (
  SoupMessageBody $body,
  SoupBuffer $buffer
)
  is native(soup)
  is export
{ * }

sub soup_message_body_append_take (
  SoupMessageBody $body,
  Pointer $data,
  gsize $length
)
  is native(soup)
  is export
{ * }

sub soup_message_body_complete (SoupMessageBody $body)
  is native(soup)
  is export
{ * }

sub soup_message_body_flatten (SoupMessageBody $body)
  returns SoupBuffer
  is native(soup)
  is export
{ * }

sub soup_message_body_free (SoupMessageBody $body)
  is native(soup)
  is export
{ * }

sub soup_message_body_get_accumulate (SoupMessageBody $body)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_message_body_get_chunk (SoupMessageBody $body, goffset $offset)
  returns SoupBuffer
  is native(soup)
  is export
{ * }

sub soup_message_body_got_chunk (SoupMessageBody $body, SoupBuffer $chunk)
  is native(soup)
  is export
{ * }

sub soup_message_body_new ()
  returns SoupMessageBody
  is native(soup)
  is export
{ * }

sub soup_message_body_set_accumulate (
  SoupMessageBody $body,
  gboolean $accumulate
)
  is native(soup)
  is export
{ * }

sub soup_buffer_copy (SoupBuffer $buffer)
  returns SoupBuffer
  is native(soup)
  is export
{ * }

sub soup_buffer_free (SoupBuffer $buffer)
  is native(soup)
  is export
{ * }

sub soup_buffer_get_as_bytes (SoupBuffer $buffer)
  returns GBytes
  is native(soup)
  is export
{ * }

sub soup_buffer_get_data (
  SoupBuffer $buffer,
  CArray[CArray[uint8]] $data,
  gsize $length is rw
)
  is native(soup)
  is export
{ * }

sub soup_buffer_get_owner (SoupBuffer $buffer)
  returns Pointer
  is native(soup)
  is export
{ * }

sub soup_buffer_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_buffer_new (SoupMemoryUse $use, Pointer $data, gsize $length)
  returns SoupBuffer
  is native(soup)
  is export
{ * }

sub soup_buffer_new_subbuffer (
  SoupBuffer $parent,
  gsize $offset,
  gsize $length
)
  returns SoupBuffer
  is native(soup)
  is export
{ * }

sub soup_buffer_new_take (Pointer $data, gsize $length)
  returns SoupBuffer
  is native(soup)
  is export
{ * }

sub soup_buffer_new_with_owner (
  Pointer $data,
  gsize $length,
  gpointer $owner,
  GDestroyNotify $owner_dnotify
)
  returns SoupBuffer
  is native(soup)
  is export
{ * }

sub soup_message_body_truncate (SoupMessageBody $body)
  is native(soup)
  is export
{ * }

sub soup_message_body_wrote_chunk (SoupMessageBody $body, SoupBuffer $chunk)
  is native(soup)
  is export
{ * }
