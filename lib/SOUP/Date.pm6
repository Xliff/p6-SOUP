use v6.c;

use Method::Also;

use SOUP::Raw::Types;
use SOUP::Raw::Date;

use GLib::GList;

use GLib::Roles::ListData;

class SOUP::Date {
  has SoupDate $!sd handles <
    year  month   day
    hour  minute  second
    utc   offset
  >;

  submethod BUILD (:$date) {
    $!sd = $date;
  }

  multi method new (SoupDate $date) {
    $date ?? self.bles( :$date ) !! Nil;
  }
  multi method new (DateTime $date) {
    SOUP::Date.new_from_time_t($date.posix);
  }
  multi method new (
    Int() $month,
    Int() $day,
    Int() $hour,
    Int() $minute,
    Int() $second
  ) {
    my gint ($m, $d, $y, $hh, $mm, $ss) =
      ($month, $day, $hour, $minute, $second);
    my $date = soup_date_new($$m, $d, $y, $hh, $mm, $ss);

    $date ?? self.bless( :$date ) !! Nil;
  }
  multi method new (Int() $offset, :$now is required) {
    SOUP::Date.new_from_now($offset);
  }
  multi method new (Str() $s, :str(:$string) is required) {
    SOUP::Date.new_from_string($s);
  }
  multi method new (
    Int() $t,
    :time(
      :time_t(
        :epoch(
          :unix(:$posix)
        )
      )
    ) is required
  ) {
    SOUP::Date.new_from_time_t($t);
  }

  method new_from_now (Int() $offset_seconds) is also<new-from-now> {
    my gint $o = $offset_seconds;
    my $date = soup_date_new_from_now($o);

    $date ?? self.bless( :$date ) !! Nil;
  }

  method new_from_string (Str() $date_string) is also<new-from-string> {
    my $date = soup_date_new_from_string($date_string);

    $date ?? self.bless( :$date ) !! Nil;
  }

  method new_from_time_t (Int() $when) is also<new-from-time-t> {
    my time_t $w = $when;
    my $date = soup_date_new_from_time_t($when);

    $date ?? self.bless( :$date ) !! Nil;
  }

  multi method copy (:$raw = False) {
    SOUP::Date.copy($!sd, :$raw);
  }
  multi method copy (SOUP::Date:U: $to-copy, :$raw = False) {
    my $copy = soup_date_copy($to-copy);

    $copy ??
      ( $raw ?? $copy !! SOUP::Date.new($copy) )
      !!
      Nil;
  }

  method free {
    soup_date_free($!sd);
  }

  method get_day is also<get-day> {
    soup_date_get_day($!sd);
  }

  method get_hour is also<get-hour> {
    soup_date_get_hour($!sd);
  }

  method get_minute is also<get-minute> {
    soup_date_get_minute($!sd);
  }

  method get_month is also<get-month> {
    soup_date_get_month($!sd);
  }

  method get_offset is also<get-offset> {
    soup_date_get_offset($!sd);
  }

  method get_second is also<get-second> {
    soup_date_get_second($!sd);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_date_get_type, $n, $t );
  }

  method get_utc is also<get-utc> {
    so soup_date_get_utc($!sd);
  }

  method get_year is also<get-year> {
    soup_date_get_year($!sd);
  }

  method is_past is also<is-past> {
    so soup_date_is_past($!sd);
  }

  method Str {
    # cw: This one is sortable.
    self.to_string(SOUP_DATE_ISO8601_FULL)
  }
  method to_string (Int() $format) is also<to-string> {
    my SoupDateFormat $f = $format;

    soup_date_to_string($!sd, $f);
  }

  method to_time_t
    is also<
      to-time-t
      epoch
      posix
      Int
    >
  {
    soup_date_to_time_t($!sd);
  }

  proto method to_timeval (|)
      is also<to-timeval>
  { * }

  multi method to_timeval {
    samewith($);
  }
  multi method to_timeval ($time is rw) {
    my $tv = GTimeVal.new;

    soup_date_to_timeval($!sd, $time);
    $time = $tv;
  }

}
