use v6.c;

use Method::Also;

use SOUP::Raw::Types;
use SOUP::Raw::AuthDomain;

use GLib::Roles::Pointers;
use GLib::Roles::Object;

our subset SoupAuthDomainAncestry is export of Mu
  where SoupAuthDomain | GObject;

class SOUP::AuthDomain {
  also does GLib::Roles::Object;
  
  has SoupAuthDomain $!sad is implementor;

  submethod BUILD (:$authdomain) {
    self.setSoupAuthDomain($authdomain) if $authdomain;
  }

  method setSoupAuthDomain (SoupAuthDomainAncestry $_) {
    my $to-parent;

    $!sad = do {
      when SoupAuthDomain { $_                       }
      default             { cast(SoupAuthDomain, $_) }
    }
    self.roleInit-Object;
  }

  method SOUP::Raw::Definitions::SoupAuthDomain
    is also<SoupAuthDomain>
  { $!sad }

  method new (SoupAuthDomain $authdomain) {
    $authdomain ?? self.bless( :$authdomain ) !! Nil;
  }

  # Type: gchar
  method add-path is rw  is also<add_path> {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        warn 'add-path does not allow reading' if $DEBUG;
        '';
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('add-path', $gv);
      }
    );
  }

  # Type: gpointer - Callback!
  method filter is rw  {
    my $gv = GLib::Value.new( G_TYPE_POINTER );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('filter', $gv)
        );
        $gv.pointer;
      },
      STORE => -> $, $val is copy {
        my $original-type = $val.^name;
        # cw: This should employ the same strategy used to set function pointers
        #     in structs. For now. this is a placeholder.
        my $v := do if $val ~~ GLib::Roles::Pointers {
          $val.p;
        } elsif $val ~~ Callable {
          set_func_pointer( &($val), &sprintf-auth-domain-filter )
        }

        die "Cannot accept $original-type as RHS for .filter"
          unless $val ~~ gpointer;

        $gv.pointer = $val;
        self.prop_set('filter', $gv);
      }
    );
  }

  # Type: gpointer
  method filter-data is rw  is also<filter_data> {
    my $gv = GLib::Value.new( G_TYPE_POINTER );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('filter-data', $gv)
        );
        $gv.pointer;
      },
      STORE => -> $, $val is copy {
        my $original-type = $val.^name;

        $val .= p if $val ~~ GLib::Roles::Pointer;

        die "Cannot accept $original-type as RHS for .generic-auth-data"
          unless $val ~~ gpointer;

        self.prop_set('filter-data', $gv);
      }
    );
  }

  # Type: gpointer
  method generic-auth-callback is rw  is also<generic_auth_callback> {
    my $gv = GLib::Value.new( G_TYPE_POINTER );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('generic-auth-callback', $gv)
        );
        $gv.pointer
      },
      STORE => -> $, $val is copy {
        # cw: This should employ the same strategy used to set function pointers
        #     in structs. For now. this is a placeholder.
        my $v := do if $val ~~ GLib::Roles::Pointers {
          $val.p;
        } elsif $val ~~ Callable {
          set_func_pointer( &($val), &sprintf-auth-domain-generic-auth-callback )
        }

        $gv.pointer = $val;
        self.prop_set('generic-auth-callback', $gv);
      }
    );
  }

  # Type: gpointer
  method generic-auth-data is rw  is also<generic_auth_data> {
    my $gv = GLib::Value.new( G_TYPE_POINTER );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('generic-auth-data', $gv)
        );
        $gv.pointer
      },
      STORE => -> $, $val is copy {
        my $original-type = $val.^name;

        $val .= p if $val ~~ GLib::Roles::Pointer;

        die "Cannot accept $original-type as RHS for .generic-auth-data"
          unless $val ~~ gpointer;

        $gv.pointer = $val;
        self.prop_set('generic-auth-data', $gv);
      }
    );
  }

  # Type: gboolean
  method proxy is rw  {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('proxy', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        warn 'proxy is a construct-only attribute'
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
        warn 'realm is a construct-only attribute'
      }
    );
  }

  # Type: gchar
  method remove-path is rw  is also<remove_path> {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        warn 'remove-path does not allow reading' if $DEBUG;
        '';
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('remove-path', $gv);
      }
    );
  }

  method accepts (SoupMessage() $msg) {
    soup_auth_domain_accepts($!sad, $msg);
  }

  # Conflicts with signal<add-path> so  hence the extra "_to". This shall be
  # rectified in the next version.
  method add_path_to (Str() $path) is also<add-path-to> {
    soup_auth_domain_add_path($!sad, $path);
  }

  method challenge (SoupMessage() $msg) {
    soup_auth_domain_challenge($!sad, $msg);
  }

  method check_password (
    SoupMessage() $msg,
    Str() $username,
    Str() $password
  )
    is also<check-password>
  {
    soup_auth_domain_check_password($!sad, $msg, $username, $password);
  }

  method covers (SoupMessage() $msg) {
    soup_auth_domain_covers($!sad, $msg);
  }

  method get_realm is also<get-realm> {
    soup_auth_domain_get_realm($!sad);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, soup_auth_domain_get_type, $n, $t );
  }

  method remove_path_from (Str() $path) is also<remove-path-from>
  {
    soup_auth_domain_remove_path($!sad, $path);
  }

  method set_filter (
    &filter,
    gpointer $filter_data   = gpointer,
    GDestroyNotify $dnotify = GDestroyNotify
  )
    is also<set-filter>
  {
    soup_auth_domain_set_filter($!sad, &filter, $filter_data, $dnotify);
  }

  method set_generic_auth_callback (
    &auth_callback,
    gpointer $auth_data     = gpointer,
    GDestroyNotify $dnotify = GDestroyNotify
  )
    is also<set-generic-auth-callback>
  {
    soup_auth_domain_set_generic_auth_callback($!sad, &auth_callback, $auth_data, $dnotify);
  }

  method try_generic_auth_callback (
    SoupMessage() $msg,
    Str() $username
  )
    is also<try-generic-auth-callback>
  {
    soup_auth_domain_try_generic_auth_callback($!sad, $msg, $username);
  }

}
