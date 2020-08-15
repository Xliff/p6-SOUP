use v6.c;

use Method::Also;

use NativeCall;

use SOUP::Raw::Types;

use SOUP::AuthDomain;

our subset SoupAuthDomainBasicAncestry is export of Mu
  where SoupAuthDomainBasic | SoupAuthDomain;

class SOUP::AuthDomain::Basic is SOUP::AuthDomain {
  has $!sadb is implementor;

  submethod BUILD (:$auth-basic) {
    self.setSoupAuthDomainBasic($auth-basic) if $auth-basic;
  }

  method setSoupAuthDomainBasic (SoupAuthDomainBasicAncestry $_) {
    my $to-parent;

    $!sadb = do {
      when SoupAuthDomainBasic {
        $to-parent = cast(SoupAuthDomain, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(SoupAuthDomainBasic, $_);
      }
    }
    self.setSoupAuthDomain($to-parent);
  }

  method SOUP::Raw::Definitions::SoupAuthDomainBasic
    is also<SoupAuthDomainBasic>
  { $!sadb }

  # Type: gpointer
  method auth-callback is rw  is also<auth_callback> {
    my $gv = GLib::Value.new( G_TYPE_POINTER );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('auth-callback', $gv)
        );
        # cw: Do we want to convert to a callable, here? Or maybe give option?
        $gv.pointer;
      },
      STORE => -> $, &val is copy {
        $gv.pointer = set_func_pointer( &val, &sprintf-auth-callback );
        self.prop_set('auth-callback', $gv);
      }
    );
  }

  # Type: gpointer
  method auth-data is rw  is also<auth_data> {
    my $gv = GLib::Value.new( G_TYPE_POINTER );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('auth-data', $gv)
        );
        $gv.pointer
      },
      STORE => -> $, Pointer $val is copy {
        $gv.pointer = $val;
        self.prop_set('auth-data', $gv);
      }
    );
  }

  multi method new (SoupAuthDomainBasic $auth-basic) {
    $auth-basic ?? self.bless( :$auth-basic ) !! Nil;
  }
  multi method new (Str() $realm) {
    my $auth-basic = soup_auth_domain_basic_new('realm', $realm, Str);

    $auth-basic ?? self.bless( :$auth-basic ) !! Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_auth_domain_basic_get_type, $n, $t );
  }

  method set_auth_callback (
    &callback,
    gpointer $user_data     = Pointer,
    GDestroyNotify $dnotify = Pointer
  )
    is also<set-auth-callback>
  {
    soup_auth_domain_basic_set_auth_callback(
      $!sadb,
      &callback,
      $user_data,
      $dnotify
    );
  }

}


### /usr/include/libsoup-2.4/libsoup/soup-auth-domain-basic.h

sub soup_auth_domain_basic_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_auth_domain_basic_new (Str $realm-param, Str $realm, Str)
  returns SoupAuthDomainBasic
  is native(soup)
  is export
{ * }

sub soup_auth_domain_basic_set_auth_callback (
  SoupAuthDomain $domain,
  &callback (SoupAuthDomain, SoupMessage, Str, Str, gpointer --> gboolean),
  gpointer $user_data,
  GDestroyNotify $dnotify
)
  is native(soup)
  is export
{ * }

sub sprintf-auth-callback (
  Blob,
  Str,
  & (SoupAuthDomain, SoupMessage, Str, Str, gpointer --> gboolean)
)
  returns int64
  is export
  is native
  is symbol('sprintf')
{ * }
