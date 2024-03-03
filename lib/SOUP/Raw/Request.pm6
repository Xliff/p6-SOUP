use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GIO::Raw::Definitions;
use GIO::Raw::Structs;
use SOUP::Raw::Definitions;

unit package SOUP::Raw::Request;

### /usr/include/libsoup-2.4/libsoup/soup-request.h

sub soup_request_get_content_length (SoupRequest $request)
  returns goffset
  is native(soup)
  is export
{ * }

sub soup_request_get_content_type (SoupRequest $request)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_request_get_session (SoupRequest $request)
  returns SoupSession
  is native(soup)
  is export
{ * }

sub soup_request_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_request_get_uri (SoupRequest $request)
  returns SoupURI
  is native(soup)
  is export
{ * }

sub soup_request_send (
  SoupRequest $request,
  GCancellable $cancellable,
  CArray[Pointer[GError]] $error
)
  returns GInputStream
  is native(soup)
  is export
{ * }

sub soup_request_send_async (
  SoupRequest $request,
  GCancellable $cancellable,
  GAsyncReadyCallback $callback,
  gpointer $user_data
)
  is native(soup)
  is export
{ * }

sub soup_request_send_finish (
  SoupRequest $request,
  GAsyncResult $result,
  CArray[Pointer[GError]] $error
)
  returns GInputStream
  is native(soup)
  is export
{ * }
