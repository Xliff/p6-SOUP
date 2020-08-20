use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GIO::Raw::Definitions;
use SOUP::Raw::Definitions;

### /usr/include/libsoup-2.4/libsoup/soup-multipart-input-stream.h

unit package SOUP::Raw::MultipartInputStream;

sub soup_multipart_input_stream_get_headers (
  SoupMultipartInputStream $multipart
)
  returns SoupMessageHeaders
  is native(soup)
  is export
{ * }

sub soup_multipart_input_stream_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_multipart_input_stream_new (
  SoupMessage $msg,
  GInputStream $base_stream
)
  returns SoupMultipartInputStream
  is native(soup)
  is export
{ * }

sub soup_multipart_input_stream_next_part (
  SoupMultipartInputStream $multipart,
  GCancellable $cancellable,
  CArray[Pointer[GError]] $error
)
  returns GInputStream
  is native(soup)
  is export
{ * }

sub soup_multipart_input_stream_next_part_async (
  SoupMultipartInputStream $multipart,
  gint $io_priority,
  GCancellable $cancellable,
  GAsyncReadyCallback $callback,
  gpointer $data
)
  is native(soup)
  is export
{ * }

sub soup_multipart_input_stream_next_part_finish (
  SoupMultipartInputStream $multipart,
  GAsyncResult $result,
  CArray[Pointer[GError]] $error
)
  returns GInputStream
  is native(soup)
  is export
{ * }
