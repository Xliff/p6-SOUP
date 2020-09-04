use v6.c;

use Method::Also;

use SOUP::Raw::Types;
use SOUP::Raw::Cache;

# cw: See:
# https://developer.gnome.org/libsoup/stable/SoupSessionFeature.html#SoupSessionFeatureInterface
#
# - At time of this writing, the documentation was incomplete

use GLib::Roles::Object;
use SOUP::Roles::SessionFeature;

our subset SoupCacheAncestry is export of Mu
  where SoupCache | SoupSessionFeature | GObject;

class SOUP::Cache {
  also does GLib::Roles::Object;
  also does SOUP::Roles::SessionFeature;

  has SoupCache $!sc;

  submethod BUILD (:$cache) {
    self.setSoupCache($cache) if $cache;
  }

  method setSoupCache (SoupCacheAncestry $_) {
    my $to-parent;

    $!sc = do {
      when SoupCache {
        $to-parent = cast(GObject, $_);
        $_;
      }

      when SoupSessionFeature {
        $to-parent = cast(GObject, $_);
        $!sf = $_;
        cast(SoupCache, $_);
      }

      default {
        $to-parent = $_;
        cast(SoupCache, $_);
      }
    }
    self!setObject($to-parent);
    self.roleInit-SoupSessionFeature unless $!sf;
  }

  method SOUP::Raw::Definitions::SoupCache
    is also<SoupCache>
  { $!sc }

  multi method new (SoupCacheAncestry $auth-manager) {
    $auth-manager ?? self.bless( :$auth-manager ) !! Nil;
  }
  multi method new (Str() $cache_dir, Int() $cache_type) {
    my SoupCacheType $c = $cache_type;
    my $cache = soup_cache_new($cache_dir, $c);

    $cache ?? self.bless( :$cache ) !! Nil;
  }

  # Type: gchar
  method cache-dir is rw  is also<cache_dir> {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('cache-dir', $gv)
        );
        $gv.string;
      },
      STORE => -> $, $val is copy {
        warn 'cache-dir is a construct-only attribute'
      }
    );
  }

  # Type: SoupCacheType
  method cache-type is rw  is also<cache_type> {
    my $gv = GLib::Value.new( GLib::Value.gtypeFromEnum(SoupCacheType) );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('cache-type', $gv)
        );
        #SoupCacheTypeEnum( $gv.valueFromEnum(SoupCacheType) );
        SoupCacheTypeEnum( $gv.enum );
      },
      STORE => -> $, $val is copy {
        warn 'cache-type is a construct-only attribute'
      }
    );
  }

  method clear {
    soup_cache_clear($!sc);
  }

  method dump {
    soup_cache_dump($!sc);
  }

  method flush {
    soup_cache_flush($!sc);
  }

  method get_max_size is also<get-max-size> {
    soup_cache_get_max_size($!sc);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_cache_get_type, $n, $t );
  }

  method load {
    soup_cache_load($!sc);
  }

  method set_max_size (Int() $max_size) is also<set-max-size> {
    my guint $m = $max_size;

    soup_cache_set_max_size($!sc, $m);
  }

}
