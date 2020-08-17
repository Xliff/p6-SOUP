use v6.c;

use Method::Also;

use NativeCall;

use SOUP::Raw::Types;

use SOUP::AuthDomain;

our subset SoupAuthDomainDigestAncestry is export of Mu
  where SoupAuthDomainDigest | SoupAuthDomain;

class SOUP::AuthDomain::digest is SOUP::AuthDomain {
  has $!sadd is implementor;

  submethod BUILD (:$auth-digest) {
    self.setSoupAuthDomainDigest($auth-digest) if $auth-digest;
  }

  method setSoupAuthDomainDigest (SoupAuthDomainDigestAncestry $_) {
    my $to-parent;

    $!sadd = do {
      when SoupAuthDomainDigest {
        $to-parent = cast(SoupAuthDomain, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(SoupAuthDomainDigest, $_);
      }
    }
    self.setSoupAuthDomain($to-parent);
  }

  method SOUP::Raw::Definitions::SoupAuthDomainDigest
    is also<SoupAuthDomainDigest>
  { $!sadd }

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

  multi method new (SoupAuthDomainDigest $auth-digest) {
    $auth-digest ?? self.bless( :$auth-digest ) !! Nil;
  }
  multi method new (Str() $realm) {
    my $auth-digest = soup_auth_domain_digest_new(Str);

    $auth-digest ?? self.bless( :$auth-digest ) !! Nil;
  }

  method encode_password (Str() $username, Str() $realm, Str() $password) {
    soup_auth_domain_digest_encode_password ($username, $realm, $password)
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_auth_domain_digest_get_type, $n, $t );
  }

  method set_auth_callback (
    &callback,
    gpointer $user_data     = Pointer,
    GDestroyNotify $dnotify = Pointer
  )
    is also<set-auth-callback>
  {
    soup_auth_domain_digest_set_auth_callback(
      $!sadd,
      &callback,
      $user_data,
      $dnotify
    );
  }

}


### /usr/include/libsoup-2.4/libsoup/soup-auth-domain-digest.h

sub soup_auth_domain_digest_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_auth_domain_digest_new (Str)
  returns SoupAuthDomainDigest
  is native(soup)
  is export
{ * }

sub soup_auth_domain_digest_set_auth_callback (
  SoupAuthDomain $domain,
  &callback (SoupAuthDomain, SoupMessage, Str, gpointer --> gboolean),
  gpointer $user_data,
  GDestroyNotify $dnotify
)
  is native(soup)
  is export
{ * }

sub soup_auth_domain_digest_encode_password (
  Str $username,
  Str $realm,
  Str $password
)
  returns Str
  is native(soup)
  is export
{ * }

sub sprintf-auth-callback (
  Blob,
  Str,
  & (SoupAuthDomain, SoupMessage, Str, gpointer --> gboolean)
)
  returns int64
  is export
  is native
  is symbol('sprintf')
{ * }
