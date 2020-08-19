use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use SOUP::Raw::Definitions;
use SOUP::Raw::Enums;

unit package SOUP::Raw::Cache;

### /usr/include/libsoup-2.4/libsoup/soup-cache.h

sub soup_cache_clear (SoupCache $cache)
  is native(soup)
  is export
{ * }

sub soup_cache_dump (SoupCache $cache)
  is native(soup)
  is export
{ * }

sub soup_cache_flush (SoupCache $cache)
  is native(soup)
  is export
{ * }

sub soup_cache_get_max_size (SoupCache $cache)
  returns guint
  is native(soup)
  is export
{ * }

sub soup_cache_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_cache_load (SoupCache $cache)
  is native(soup)
  is export
{ * }

sub soup_cache_new (Str $cache_dir, SoupCacheType $cache_type)
  returns SoupCache
  is native(soup)
  is export
{ * }

sub soup_cache_set_max_size (SoupCache $cache, guint $max_size)
  is native(soup)
  is export
{ * }
