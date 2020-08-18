use v6.c;

use Method::Also;

use SOUP::Raw::Types;
use SOUP::Raw::SessionFeature;

use SOUP::Raw::Types;

# cw: This role is primarily used for identification purposes.

# Known implementations:
#  SoupAuthManager,
#  SoupCache,
#  SoupContentDecoder,
#  SoupContentSniffer,
#  SoupCookieJar,
#  SoupCookieJarDB,
#  SoupCookieJarText,
#  SoupLogger
#  SoupProxyResolverDefault.

role SOUP::Roles::SessionFeature {
  has SoupSessionFeature $!sf;

  submethod BUILD (:$session-feature) {
    $!sf = $session-feature if $session-feature;
  }

  method roleInit-SessionFeature {
    my \i = findProperImplementor(self.^attributes);
    my $o = i.get_value(self);

    $!sf = cast(SoupSessionFeature, $o);
  }

  method SOUP::Raw::Definitions::SoupSessionFeature
    is also<SoupSessionFeature>
  { $!sf }

  method new-sessionfeature-object (SoupSessionFeature $session-feature) {
    $session-feature ?? self.bless( :$session-feature ) !! Nil;
  }

  method add_feature (Int() $type) {
    my GType $t = $type;

    soup_session_feature_add_feature($!sf, $t);
  }

  method attach (SoupSession() $session) {
    soup_session_feature_attach($!sf, $session);
  }

  method detach (SoupSession() $session) {
    soup_session_feature_detach($!sf, $session);
  }

  method get_sessionfeature_type  {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_session_feature_get_type, $n, $t );
  }

  method has_feature (Int() $type) {
    my GType $t = $type;

    so soup_session_feature_has_feature($!sf, $t);
  }

  method remove_feature (GType $type) {
    my GType $t = $type;

    so soup_session_feature_remove_feature($!sf, $t);
  }

}
