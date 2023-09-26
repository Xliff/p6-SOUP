use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GIO::Raw::Definitions;
use SOUP::Raw::Definitions;

unit package SOUP::Raw::ConnectionManager;

### /usr/src/libsoup/libsoup/soup-connection-manager.h

sub soup_connection_manager_cleanup (
  SoupConnectionManager $manager,
  gboolean              $cleanup_idle
)
  returns uint32
  is      native(soup)
  is      export
{ * }

sub soup_connection_manager_free (SoupConnectionManager $manager)
  is      native(soup)
  is      export
{ * }

sub soup_connection_manager_get_connection (
  SoupConnectionManager $manager,
  SoupMessageQueueItem  $item
)
  returns SoupConnection
  is      native(soup)
  is      export
{ * }

sub soup_connection_manager_get_max_conns (SoupConnectionManager $manager)
  returns guint
  is      native(soup)
  is      export
{ * }

sub soup_connection_manager_get_max_conns_per_host (SoupConnectionManager $manager)
  returns guint
  is      native(soup)
  is      export
{ * }

sub soup_connection_manager_get_num_conns (SoupConnectionManager $manager)
  returns guint
  is      native(soup)
  is      export
{ * }

sub soup_connection_manager_get_remote_connectable (
  SoupConnectionManager $manager
)
  returns GSocketConnectable
  is      native(soup)
  is      export
{ * }

sub soup_connection_manager_new (
  SoupSession $session,
  guint       $max_conns,
  guint       $max_conns_per_host
)
  returns SoupConnectionManager
  is      native(soup)
  is      export
{ * }

sub soup_connection_manager_set_max_conns (
  SoupConnectionManager $manager,
  guint                 $max_conns
)
  is      native(soup)
  is      export
{ * }

sub soup_connection_manager_set_max_conns_per_host (
  SoupConnectionManager $manager,
  guint                 $max_conns_per_host
)
  is      native(soup)
  is      export
{ * }

sub soup_connection_manager_set_remote_connectable (
  SoupConnectionManager $manager,
  GSocketConnectable    $connectable
)
  is      native(soup)
  is      export
{ * }

sub soup_connection_manager_steal_connection (
  SoupConnectionManager $manager,
  SoupMessage           $msg
)
  returns GIOStream
  is      native(soup)
  is      export
{ * }
