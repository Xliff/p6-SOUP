use v6.c;

use Method::Also;

use NativeCall;

use SOUP::Raw::Types;

use GLib::Roles::Object;
use SOUP::Roles::SessionFeature;

our subset SoupAuthManagerAncestry is export of Mu
  where SoupAuthManager | SoupSessionFeature | GObject;

class SOUP::AuthManager {
  also does GLib::Roles::Object;
  also does SOUP::Roles::SessionFeature;

  has SoupAuthManager $!sam;

  submethod BUILD (:$auth-manager) {
    self.setSoupAuthManager($auth-manager) if $auth-manager;
  }

  method setSoupAuthManager (SoupAuthManagerAncestry $_) {
    my $to-parent;

    $!sam = do {
      when SoupAuthManager {
        $to-parent = cast(GObject, $_);
        $_;
      }

      when SoupSessionFeature {
        $to-parent = cast(GObject, $_);
        $!sf = $_;
        cast(SoupAuthManager, $_);
      }

      default {
        $to-parent = $_;
        cast(SoupAuthManager, $_);
      }
    }
    self!setObject($to-parent);
    self.roleInit-SoupSessionFeature unless $!sf;
  }

  method SOUP::Raw::Definitions::SoupAuthManager
    is also<SoupAuthManager>
  { $!sam }

  multi method new (SoupAuthManagerAncestry $auth-manager) {
    $auth-manager ?? self.bless( :$auth-manager ) !! Nil;
  }

  method clear_cached_credentials is also<clear-cached-credentials> {
    soup_auth_manager_clear_cached_credentials($!sam);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_auth_manager_get_type, $n, $t );
  }

  method use_auth (SoupURI() $uri, SoupAuth() $auth) is also<use-auth> {
    soup_auth_manager_use_auth($!sam, $uri, $auth);
  }

}

### /usr/include/libsoup-2.4/libsoup/soup-auth-manager.h

sub soup_auth_manager_clear_cached_credentials (SoupAuthManager $manager)
  is native(soup)
  is export
{ * }

sub soup_auth_manager_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_auth_manager_use_auth (
  SoupAuthManager $manager,
  SoupURI $uri,
  SoupAuth $auth
)
  is native(soup)
  is export
{ * }
