use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use SOUP::Raw::Definitions;
use SOUP::Raw::Enums;

unit package SOUP::Raw::Date;

### /usr/include/libsoup-2.4/libsoup/soup-date.h

sub soup_date_copy (SoupDate $date)
  returns SoupDate
  is native(soup)
  is export
{ * }

sub soup_date_free (SoupDate $date)
  is native(soup)
  is export
{ * }

sub soup_date_get_day (SoupDate $date)
  returns gint
  is native(soup)
  is export
{ * }

sub soup_date_get_hour (SoupDate $date)
  returns gint
  is native(soup)
  is export
{ * }

sub soup_date_get_minute (SoupDate $date)
  returns gint
  is native(soup)
  is export
{ * }

sub soup_date_get_month (SoupDate $date)
  returns gint
  is native(soup)
  is export
{ * }

sub soup_date_get_offset (SoupDate $date)
  returns gint
  is native(soup)
  is export
{ * }

sub soup_date_get_second (SoupDate $date)
  returns gint
  is native(soup)
  is export
{ * }

sub soup_date_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_date_get_utc (SoupDate $date)
  returns gint
  is native(soup)
  is export
{ * }

sub soup_date_get_year (SoupDate $date)
  returns gint
  is native(soup)
  is export
{ * }

sub soup_date_is_past (SoupDate $date)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_date_new (
  gint $year,
  gint $month,
  gint $day,
  gint $hour,
  gint $minute,
  gint $second
)
  returns SoupDate
  is native(soup)
  is export
{ * }

sub soup_date_new_from_now (gint $offset_seconds)
  returns SoupDate
  is native(soup)
  is export
{ * }

sub soup_date_new_from_string (Str $date_string)
  returns SoupDate
  is native(soup)
  is export
{ * }

sub soup_date_new_from_time_t (time_t $when)
  returns SoupDate
  is native(soup)
  is export
{ * }

sub soup_date_to_string (SoupDate $date, SoupDateFormat $format)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_date_to_time_t (SoupDate $date)
  returns time_t
  is native(soup)
  is export
{ * }

sub soup_date_to_timeval (SoupDate $date, GTimeVal $time)
  is native(soup)
  is export
{ * }
