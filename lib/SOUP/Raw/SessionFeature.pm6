use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use SOUP::Raw::Definitions;

### /usr/include/libsoup-2.4/libsoup/soup-session-feature.h

sub soup_session_feature_add_feature (
  SoupSessionFeature $feature,
  GType              $type
)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_session_feature_attach (
  SoupSessionFeature $feature,
  SoupSession        $session
)
  is native(soup)
  is export
{ * }

sub soup_session_feature_detach (
  SoupSessionFeature $feature,
  SoupSession        $session
)
  is native(soup)
  is export
{ * }

sub soup_session_feature_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_session_feature_has_feature (
  SoupSessionFeature $feature,
  GType              $type
)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_session_feature_remove_feature (
  SoupSessionFeature $feature,
  GType              $type
)
  returns uint32
  is native(soup)
  is export
{ * }
