use v6.c;

use NativeCall;
use Method::Also;

use GLib::Compat::Definitions;
use SOUP::Raw::Types;
use SOUP::Raw::Address;

use GIO::SocketAddress;

use GLib::Roles::Object;
use GIO::Roles::SocketConnectable;

our subset SoupAddressAncestry is export of Mu
  where SoupAddress | GSocketConnectable | GObject;

class SOUP::Address {
  also does GLib::Roles::Object;
  also does GIO::Roles::SocketConnectable;

  has SoupAddress $!sa is implementor;

  method SOUP::Raw::Definitions::SoupAddress
    is also<SoupAddress>
  { $!sa }

  submethod BUILD (:$address) {
    self.setSoupAddress($address) if $address;
  }

  method setSoupAddress (SoupAddressAncestry $_) {
    my $to-parent;

    $!sa = do {
      when SoupAddress {
        $to-parent = cast(GObject, $_);
        $_;
      }

      when GSocketConnectable {
        $!sc = $_;
        $to-parent = cast(GObject, $_);
        cast(SoupAddress, $_);
      }

      default {
        $to-parent = $_;
        cast(SoupAddress, $_);
      }
    }
    self.roleInit-Object;
    self.roleInit-SocketConnectable unless $!sc;
  }

  multi method new (SoupAddressAncestry $address) {
    $address ?? self.bless( :$address ) !! Nil;
  }
  multi method new (Str() $name, Int() $port = 0) {
    my guint $p = $port;
    my $address = soup_address_new($name, $p);

    $address ?? self.bless( :$address ) !! Nil;
  }

  multi method new (Int() $family, Int() $port, :$any is required) {
    SOUP::Address.new_any($family, $port);
  }
  method new_any (Int() $family, Int() $port) is also<new-any> {
    my SoupAddressFamily $f = $family;
    my guint $p = $port;
    my $address = soup_address_new_any($f, $p);

    $address ?? self.bless( :$address ) !! Nil;
  }

  multi method new (
    sockaddr $sa,
    Int() $len = nativesizeof($sa),
    :socket(:$sockaddr) is required
  ) {
    SOUP::Address.new_from_sockaddr($sa, $len);
  }
  multi method new (
    sockaddr_in $sa,
    Int() $len = nativesizeof($sa),
    :socket(:sockaddr(:$sockaddr_in)) is required
  ) {
    SOUP::Address.new_from_sockaddr($sa, $len);
  }

  proto method new_from_sockaddr (|)
    is also<new-from-sockaddr>
  { * }

  multi method new_from_sockaddr (
    sockaddr_in $sa,
    Int() $len = nativesizeof($sa)
  ) {
    samewith( cast(sockaddr, $sa), $len );
  }
  multi method new_from_sockaddr (
    sockaddr $sa,
    Int() $len = nativesizeof($sa)
  ) {
    my gint $l = $len;
    my $address = soup_address_new_from_sockaddr($sa, $l);

    $address ?? self.bless( :$address ) !! Nil;
  }

  method equal_by_ip (SoupAddress() $addr2) is also<equal-by-ip> {
    so soup_address_equal_by_ip($!sa, $addr2);
  }

  method equal_by_name (SoupAddress() $addr2) is also<equal-by-name> {
    so soup_address_equal_by_name($!sa, $addr2);
  }

  method get_gsockaddr (:$raw = False) is also<get-gsockaddr> {
    my $sa = soup_address_get_gsockaddr($!sa);

    $sa ??
      ( $raw ?? $sa !! GIO::SocketAddress.new($sa) )
      !!
      Nil;
  }

  method get_name
    is also<
      get-name
      name
    >
  {
    soup_address_get_name($!sa);
  }

  method get_physical
    is also<
      get-physical
      physical
    >
  {
    soup_address_get_physical($!sa);
  }

  method get_port
    is also<
      get-port
      port
    >
  {
    soup_address_get_port($!sa);
  }

  proto method get_sockaddr (|)
      is also<get-sockaddr>
  { * }

  multi method get_sockaddr is also<sockaddr> {
    samewith($, :all);
  }
  multi method get_sockaddr ($len is rw, :$all = False) {
    my $l = 0;

    my $sa = soup_address_get_sockaddr($!sa, $l);
    $len = $l;
    $all.not ?? $sa !! ($sa, $len);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &soup_address_get_type, $n, $t );
  }

  method hash_by_ip is also<hash-by-ip> {
    soup_address_hash_by_ip($!sa);
  }

  method hash_by_name is also<hash-by-name> {
    soup_address_hash_by_name($!sa);
  }

  method is_resolved is also<is-resolved> {
    so soup_address_is_resolved($!sa);
  }

  proto method resolve_async (|)
      is also<resolve-async>
  { * }

  multi method resolve_async (
    GMainContext() $async_context,
    &callback,
    gpointer $user_data         = gpointer,
    GCancellable() $cancellable = GCancellable
  ) {
    samewith($async_context, $cancellable, &callback, $user_data)
  }
  multi method resolve_async (
    GMainContext() $async_context,
    GCancellable() $cancellable,
    &callback,
    gpointer $user_data
  ) {
    soup_address_resolve_async(
      $!sa,
      $async_context,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method resolve_sync (GCancellable() $cancellable = GCancellable)
    is also<resolve-sync>
  {
    SoupStatusEnum( soup_address_resolve_sync($!sa, $cancellable) );
  }

}
