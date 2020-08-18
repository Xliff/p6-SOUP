use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Compat::Definitions;
use GIO::Raw::Definitions;
use SOUP::Raw::Definitions;
use SOUP::Raw::Enums;

unit package SOUP::Raw::Address;

### /usr/include/libsoup-2.4/libsoup/soup-address.h

sub soup_address_equal_by_ip (SoupAddress $addr1, SoupAddress $addr2)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_address_equal_by_name (SoupAddress $addr1, SoupAddress $addr2)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_address_get_gsockaddr (SoupAddress $addr)
  returns GSocketAddress
  is native(soup)
  is export
{ * }

sub soup_address_get_name (SoupAddress $addr)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_address_get_physical (SoupAddress $addr)
  returns Str
  is native(soup)
  is export
{ * }

sub soup_address_get_port (SoupAddress $addr)
  returns guint
  is native(soup)
  is export
{ * }

sub soup_address_get_sockaddr (SoupAddress $addr, gint $len is rw)
  returns sockaddr
  is native(soup)
  is export
{ * }

sub soup_address_get_type ()
  returns GType
  is native(soup)
  is export
{ * }

sub soup_address_hash_by_ip (SoupAddress $addr)
  returns guint
  is native(soup)
  is export
{ * }

sub soup_address_hash_by_name (SoupAddress $addr)
  returns guint
  is native(soup)
  is export
{ * }

sub soup_address_is_resolved (SoupAddress $addr)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_address_new (Str $name, guint $port)
  returns SoupAddress
  is native(soup)
  is export
{ * }

sub soup_address_new_any (SoupAddressFamily $family, guint $port)
  returns SoupAddress
  is native(soup)
  is export
{ * }

sub soup_address_new_from_sockaddr (sockaddr $sa, gint $len)
  returns SoupAddress
  is native(soup)
  is export
{ * }

sub soup_address_resolve_async (
  SoupAddress $addr,
  GMainContext $async_context,
  GCancellable $cancellable,
  &callback (SoupAddress, guint, gpointer),
  gpointer $user_data
)
  is native(soup)
  is export
{ * }

sub soup_address_resolve_sync (
  SoupAddress $addr,
  GCancellable $cancellable
)
  returns guint
  is native(soup)
  is export
{ * }
