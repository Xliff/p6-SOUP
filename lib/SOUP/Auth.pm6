use v6.c;

use Method::Also;

use SOUP::Raw::Types;
use SOUP::Raw::Auth;

use GLib::Roles::Object;

our subset SoupAuthAncestry is export of Mu
  where SoupAuth | GObject;

class SOUP::Auth {
  also does GLib::Roles::Object;

  has SoupAuth $!sa is implementor;

  submethod BUILD (:$auth) {
    self.setSoupAuth($auth);
  }

  method setSoupAuth (SoupAuthAncestry $_) {
    $!sa = do {
      when SoupAuth { $_                 }
      default       { cast(SoupAuth, $_) }
    }
    self.roleInit-Object;
  }

  method Soup::Raw::Definitions::SoupAuth
  { $!sa }

  multi method new (SoupAuth $auth) {
    $auth ?? self.bless( :$auth ) !! Nil;
  }
  multi method new (Int() $type, SoupMessage() $msg, Str() $auth_header) {
    my GType $t = $type;
    my $auth = soup_auth_new($t, $msg, $auth_header);

    $auth ?? self.bless( :$auth ) !! Nil;
  }

  # Type: gchar
  method host is rw  {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('host', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('host', $gv);
      }
    );
  }

  # Type: gboolean
  method is-for-proxy is rw  {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('is-for-proxy', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('is-for-proxy', $gv);
      }
    );
  }

  # Type: gchar
  method realm is rw  {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('realm', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('realm', $gv);
      }
    );
  }

  method authenticate (Str() $username, Str() $password) {
    soup_auth_authenticate($!sa, $username, $password);
  }

  method basic_get_type is also<basic-get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_auth_basic_get_type, $n, $t );
  }

  method can_authenticate is also<can-authenticate> {
    so soup_auth_can_authenticate($!sa);
  }

  method digest_get_type is also<digest-get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_auth_digest_get_type, $n, $t );
  }

  method free_protection_space (GSList() $space)
    is also<free-protection-space>
  {
    soup_auth_free_protection_space($!sa, $space);
  }

  method get_authorization (SoupMessage() $msg) is also<get-authorization> {
    soup_auth_get_authorization($!sa, $msg);
  }

  method get_host is also<get-host> {
    soup_auth_get_host($!sa);
  }

  method get_info
    is also<
      get-info
      info
    >
  {
    soup_auth_get_info($!sa);
  }

  method get_protection_space (
    SoupURI() $source_uri,
    :$glist = False,
    :$raw   = False
  )
    is also<get-protection-space>
  {
    my $pl = soup_auth_get_protection_space($!sa, $source_uri);

    return Nil unless $pl;
    return $pl if $glist && $raw;

    $pl = GLib::GList.new($pl) but GLib::Roles::ListData[Str];
    return $pl if $glist;

    $pl.Array;
  }

  method get_realm is also<get-realm> {
    soup_auth_get_realm($!sa);
  }

  method get_saved_password (Str() $user)
    is DEPRECATED
    is also<get-saved-password>
  {
    soup_auth_get_saved_password($!sa, $user);
  }

  method get_saved_users (:$glist = False, :$raw = False)
    is DEPRECATED
    is also<get-saved-users>
  {
    my $sul = soup_auth_get_saved_users($!sa);

    return Nil unless $sul;
    return $sul if $glist && $raw;

    $sul = GLib::GList.new($sul) but GLib::Roles::ListData[Str];

    return $sul if $glist;

    $sul.Array;
  }

  method get_scheme_name
    is also<
      get-scheme-name
      scheme_name
      scheme-name
    >
  {
    soup_auth_get_scheme_name($!sa);
  }

  method has_saved_password (Str() $username, Str() $password)
    is DEPRECATED
    is also<has-saved-password>
  {
    so soup_auth_has_saved_password($!sa, $username, $password);
  }

  method is_authenticated is also<is-authenticated> {
    so soup_auth_is_authenticated($!sa);
  }

  method get_is_for_proxy is also<get-is-for-proxy> {
    so soup_auth_is_for_proxy($!sa);
  }

  method is_ready (SoupMessage() $msg) is also<is-ready> {
    so soup_auth_is_ready($!sa, $msg);
  }

  method negotiate_get_type is also<negotiate-get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_auth_negotiate_get_type, $n, $t );
  }

  method negotiate_supported (SOUP::Auth:U: ) is also<negotiate-supported> {
    so soup_auth_negotiate_supported();
  }

  method ntlm_get_type is also<ntlm-get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_auth_ntlm_get_type, $n, $t );
  }

  method save_password (Str() $username, Str() $password)
    is DEPRECATED
    is also<save-password>
  {
    soup_auth_save_password($!sa, $username, $password);
  }

  method update (SoupMessage() $msg, Str() $auth_header) {
    so soup_auth_update($!sa, $msg, $auth_header);
  }

}
