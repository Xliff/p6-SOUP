use v6.c;

use Method::Also;

use SOUP::Raw::Types;

use GLib::Roles::Object;
use SOUP::Roles::SessionFeature;

our subset SoupContentSnifferAncestry is export of Mu
  where SoupContentSniffer | SoupSessionFeature | GObject;

class SOUP::ContentSniffer {
  also does GLib::Roles::Object;
  also does SOUP::Roles::SessionFeature;

  has SoupContentSniffer $!scs;

  submethod BUILD (:$content-sniffer) {
    self.setSoupContentSniffer($content-sniffer) if $content-sniffer;
  }

  method setSoupContentSniffer (SoupContentSnifferAncestry $_) {
    my $to-parent;

    $!scs = do {
      when SoupContentSniffer {
        $to-parent = cast(GObject, $_);
        $_;
      }

      when SoupSessionFeature {
        $to-parent = cast(GObject, $_);
        $!sf = $_;
        cast(SoupContentSniffer, $_);
      }

      default {
        $to-parent = $_;
        cast(SoupContentSniffer, $_);
      }
    }
    self!setObject($to-parent);
    self.roleInit-SoupSessionFeature unless $!sf;
  }

  method SOUP::Raw::Definitions::SoupContentSniffer
    is also<SoupContentSniffer>
  { $!scs }

  multi method new (SoupContentSnifferAncestry $content-sniffer) {
    $content-sniffer ?? self.bless( :$content-sniffer ) !! Nil;
  }
  multi method new {
    my $content-sniffer = soup_content_sniffer_new();

    $content-sniffer ?? self.bless( :$content-sniffer ) !! Nil;
  }

  method get_buffer_size {
    soup_content_sniffer_get_buffer_size($!scs);
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_content_sniffer_get_type, $n, $t );
  }

  method sniff (
    SoupMessage() $msg,
    SoupBuffer() $buffer,
    GHashTable() $params
  ) {
    soup_content_sniffer_sniff($!scs, $msg, $buffer, $params);
  }

}


### /usr/include/libsoup-2.4/libsoup/soup-content-sniffer.h

sub soup_content_sniffer_get_buffer_size (SoupContentSniffer $sniffer)
  returns gsize
  is native(soup)
  is export
{ * }

sub soup_content_sniffer_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_content_sniffer_new ()
  returns SoupContentSniffer
  is native(soup)
  is export
{ * }

sub soup_content_sniffer_sniff (
  SoupContentSniffer $sniffer,
  SoupMessage $msg,
  SoupBuffer $buffer,
  GHashTable $params
)
  returns Str
  is native(soup)
  is export
{ * }
