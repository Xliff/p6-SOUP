use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use SOUP::Raw::Definitions;
use SOUP::Raw::Enums;

unit package SOUP::Raw::Logger;

### /usr/include/libsoup-2.4/libsoup/soup-logger.h

sub soup_logger_attach (SoupLogger $logger, SoupSession $session)
  is native(soup)
  is export
{ * }

sub soup_logger_detach (SoupLogger $logger, SoupSession $session)
  is native(soup)
  is export
{ * }

sub soup_logger_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_logger_new (SoupLoggerLogLevel $level, gint $max_body_size)
  returns SoupLogger
  is native(soup)
  is export
{ * }

sub soup_logger_set_printer (
  SoupLogger $logger,
  &printer (SoupLogger, SoupLoggerLogLevel, uint8, Str, gpointer),
  gpointer $printer_data,
  GDestroyNotify $destroy
)
  is native(soup)
  is export
{ * }

sub soup_logger_set_request_filter (
  SoupLogger $logger,
  &request_filter (SoupLogger, SoupMessage, gpointer --> SoupLoggerLogLevel),
  gpointer $filter_data,
  GDestroyNotify $destroy)
  is native(soup)
  is export
{ * }

sub soup_logger_set_response_filter (
  SoupLogger $logger,
  &response_filter (SoupLogger, SoupMessage, gpointer --> SoupLoggerLogLevel),
  gpointer $filter_data,
  GDestroyNotify $destroy
)
  is native(soup)
  is export
{ * }
