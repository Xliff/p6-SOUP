use v6.c;

use Method::Also;

use SOUP::Raw::Types;

use GLib::Roles::Object;
use SOUP::Roles::SessionFeature;

our subset SoupContentDecoderAncestry is export of Mu
  where SoupContentDecoder | SoupSessionFeature | GObject;

class SOUP::ContentDecoder {
  also does GLib::Roles::Object;
  also does SOUP::Roles::SessionFeature;

  has SoupContentDecoder $!scd;

  submethod BUILD (:$content-decoder) {
    self.setSoupContentDecoder($content-decoder) if $content-decoder;
  }

  method setSoupContentDecoder (SoupContentDecoderAncestry $_) {
    my $to-parent;

    $!scd = do {
      when SoupContentDecoder {
        $to-parent = cast(GObject, $_);
        $_;
      }

      when SoupSessionFeature {
        $to-parent = cast(GObject, $_);
        $!sf = $_;
        cast(SoupContentDecoder, $_);
      }

      default {
        $to-parent = $_;
        cast(SoupContentDecoder, $_);
      }
    }
    self!setObject($to-parent);
    self.roleInit-SoupSessionFeature unless $!sf;
  }

  method SOUP::Raw::Definitions::SoupContentDecoder
    is also<SoupContentDecoder>
  { $!scd }

  method new (SoupContentDecoderAncestry $content-decoder) {
    $content-decoder ?? self.bless( :$content-decoder ) !! Nil;
  }

}

### /usr/include/libsoup-2.4/libsoup/soup-content-decoder.h

sub soup_content_decoder_get_type ()
  returns GType
  is native(soup)
  is export
{ * }
