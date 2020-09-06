use v6.c;

use GLib::Raw::Definitions;
use GLib::Raw::Enums;
use SOUP::Raw::Definitions;

unit package SOUP::Raw::Misc;

### /usr/include/libsoup-2.4/libsoup/soup-misc.h

sub soup_add_completion (
  GMainContext $async_context,
  &function (gpointer --> gboolean),
  gpointer $data
)
  returns GSource
  is native(soup)
  is export
{ * }

sub soup_add_idle (
  GMainContext $async_context,
  &function (gpointer --> gboolean),
  gpointer $data
)
  returns GSource
  is native(soup)
  is export
{ * }

sub soup_add_io_watch (
  GMainContext $async_context,
  GIOChannel $chan,
  GIOCondition $condition,
  &func (GIOChannel, GIOCondition, gpointer --> gboolean),
  gpointer $data
)
  returns GSource
  is native(soup)
  is export
{ * }

sub soup_add_timeout (
  GMainContext $async_context,
  guint $interval,
  &function (gpointer --> gboolean),
  gpointer $data
)
  returns GSource
  is native(soup)
  is export
{ * }

sub soup_str_case_equal (Str $v1, Str $v2)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_str_case_hash (Str $key)
  returns guint
  is native(soup)
  is export
{ * }
