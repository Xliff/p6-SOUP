use v6.c;

use Method::Also;
use NativeCall;

use SOUP::Raw::Types;
use SOUP::Raw::MultipartInputStream;

use GIO::FilterInputStream;
use GIO::InputStream;
use SOUP::Message;
use SOUP::MessageHeaders;

use GIO::Roles::PollableInputStream;

our subset SoupMultipartInputStreamAncestry is export of Mu
  where SoupMultipartInputStream    | GPollableInputStream |
        GFilterInputStreamAncestry;

class SOUP::MultipartInputStream is GIO::FilterInputStream {
  also does GIO::Roles::PollableInputStream;

  has SoupMultipartInputStream $!smis is implementor;

  submethod BUILD (:$multipart-input-stream) {
    self.setSoupMultipartInputStream($multipart-input-stream)
      if $multipart-input-stream;
  }

  method setSoupMultipartInputStream (SoupMultipartInputStreamAncestry $_) {
    my $to-parent;

    $!smis = do {
      when SoupMultipartInputStream {
        $to-parent = cast(GFilterInputStream, $_);
        $_;
      }

      when GPollableInputStream {
        $!pis = $_;
        $to-parent = cast(GFilterInputStream, $_);
        cast(SoupMultipartInputStream, $_);
      }

      default {
        $to-parent = $_;
        cast(SoupMultipartInputStream, $_);
      }
    }
    self.setGFilterInputStream($to-parent);
    self.roleInit-PollableInputStream unless $!pis;
  }

  method SOUP::Raw::Definitions::SoupMultipartInputStream
    is also<SoupMultipartInputStream>
  { $!smis }

  multi method new (SoupMultipartInputStreamAncestry $multipart-input-stream) {
    $multipart-input-stream ?? self.bless( :$multipart-input-stream ) !! Nil;
  }
  multi method new (SoupMessage() $msg, GInputStream() $base_stream) {
    my $multipart-input-stream = soup_multipart_input_stream_new(
      $msg,
      $base_stream
    );

    $multipart-input-stream ?? self.bless( :$multipart-input-stream ) !! Nil;
  }

  # Type: SoupMessage
  method message (:$raw = False) is rw  {
    my $gv = GLib::Value.new( SOUP::Message.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('message', $gv)
        );

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(SoupMessage, $o);
        return $o if $raw;

        SOUP::Message.new($o);
      },
      STORE => -> $, $val is copy {
        warn '.message is a construct-only attribute'
      }
    );
  }

  method get_headers (:$raw = False) is also<get-headers> {
    my $h = soup_multipart_input_stream_get_headers($!smis);

    $h ??
      ( $raw ?? $h !! SOUP::MessageHeaders.new($h) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &soup_multipart_input_stream_get_type,
      $n,
      $t
    );
  }

  method next_part (
    GCancellable() $cancellable,
    CArray[Pointer[GError]] $error = gerror,
    :$raw = False
  )
    is also<next-part>
  {
    clear_error;
    my $is = soup_multipart_input_stream_next_part($!smis, $cancellable, $error);
    set_error($error);

    $is ??
      ( $raw ?? $is !! GIO::InputStream.new($is) )
      !!
      Nil;
  }

  proto method next_part_async (|)
      is also<next-part-async>
  { * }

  multi method next_part_async (
    Int() $io_priority,
    &callback,
    gpointer $user_data         = gpointer,
    GCancellable() $cancellable = GCancellable
  ) {
    samewith($io_priority, $cancellable, &callback, $user_data);
  }
  multi method next_part_async (
    Int() $io_priority,
    GCancellable() $cancellable,
    &callback,
    gpointer $user_data = gpointer
  ) {
    my gint $i = $io_priority;

    soup_multipart_input_stream_next_part_async(
      $!smis,
      $io_priority,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method next_part_finish (
    GAsyncResult() $result,
    CArray[Pointer[GError]] $error = gerror,
    :$raw = False
  )
    is also<next-part-finish>
  {
    clear_error;
    my $is = soup_multipart_input_stream_next_part_finish(
      $!smis,
      $result,
      $error
    );
    set_error($error);

    $is ??
      ( $raw ?? $is !! GIO::InputStream.new($is) )
      !!
      Nil;
  }

}
