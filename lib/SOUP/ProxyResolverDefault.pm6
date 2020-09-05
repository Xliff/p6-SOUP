use v6.c;

use Method::Also;

use SOUP::Raw::Types;

use GLib::Roles::Object;
use GIO::Roles::ProxyResolver;
use SOUP::Roles::SessionFeature;

our subset SoupProxyResolverDefaultAncestry is export of Mu
  where SoupProxyResolverDefault | SoupSessionFeature | GObject;

class SOUP::ProxyResolverDefault {
  also does GLib::Roles::Object;
  also does SOUP::Roles::SessionFeature;

  has SoupProxyResolverDefault $!scd;

  submethod BUILD (:$proxy-resolver-default) {
    self.setSoupProxyResolverDefault($proxy-resolver-default)
      if $proxy-resolver-default;
  }

  method setSoupProxyResolverDefault (SoupProxyResolverDefaultAncestry $_) {
    my $to-parent;

    $!scd = do {
      when SoupProxyResolverDefault {
        $to-parent = cast(GObject, $_);
        $_;
      }

      when SoupSessionFeature {
        $to-parent = cast(GObject, $_);
        $!sf = $_;
        cast(SoupProxyResolverDefault, $_);
      }

      default {
        $to-parent = $_;
        cast(SoupProxyResolverDefault, $_);
      }
    }
    self!setObject($to-parent);
    self.roleInit-SoupSessionFeature unless $!sf;
  }

  method SOUP::Raw::Definitions::SoupProxyResolverDefault
    is also<SoupProxyResolverDefault>
  { $!scd }

  method new (SoupProxyResolverDefaultAncestry $proxy-resolver-default) {
    $proxy-resolver-default ?? self.bless( :$proxy-resolver-default ) !! Nil;
  }

  # Type: GProxyResolver
  method gproxy-resolver is rw  {
    my $gv = GLib::Value.new( GIO::ProxyResolver.get-proxyresolver-type );
    Proxy.new(
      FETCH => sub ($) {
        warn 'gproxy-resolver does not allow reading' if $DEBUG;
        Nil;
      },
      STORE => -> $, GProxyResolver() $val is copy {
        $gv.object = $val;
        self.prop_set('gproxy-resolver', $gv);
      }
    );
  }

  method get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &soup_proxy_resolver_default_get_type,
      $n,
      $t
    );
  }

}

### /usr/include/libsoup-2.4/libsoup/soup-proxy-resolver-default.h

sub soup_proxy_resolver_default_get_type ()
  returns GType
  is native(soup)
  is export
{ * }
