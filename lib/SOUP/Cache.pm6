use v6.c;

use SOUP::Raw::Types;
use SOUP::Raw::Cache;

# cw: See:
# https://developer.gnome.org/libsoup/stable/SoupSessionFeature.html#SoupSessionFeatureInterface
#
# - At time of this writing, the documentation was incomplete

use SOUP::Roles::SessionFeature;

our subset SoupCacheAncestry is export of Mu
  where SoupCache | GObject;

class SOUP::Cache {
  also does SOUP::Roles::SessionFeature;

  has SoupCache $!sc;

  submethod BUILD (:$cache) {
    $!sc = $cache;
  }

  method new (Str() $cache_dir, Int() $cache_type) {
    my SoupCacheType $c = $cache_type;
    my $cache = soup_cache_new($cache_dir, $c);

    $cache ?? self.bless( :$cache ) !! Nil;
  }

  # Type: gchar
  method cache-dir is rw  {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('cache-dir', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'cache-dir is a construct-only attribute'
      }
    );
  }

  # Type: SoupCacheType
  method cache-type is rw  {
    my $gv = GLib::Value.new( GLib::Value.gtypeFromEnum(SoupCacheType) );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('cache-type', $gv)
        );
        SoupCacheTypeEnum( $gv.valueFromEnum(SoupCacheType) );
      },
      STORE => -> $,  $val is copy {
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

  method get_max_size {
    soup_cache_get_max_size($!sc);
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_cache_get_type, $n, $t );
  }

  method load {
    soup_cache_load($!sc);
  }

  method set_max_size (Int() $max_size) {
    my guint $m = $max_size;

    soup_cache_set_max_size($!sc, $m);
  }

}
