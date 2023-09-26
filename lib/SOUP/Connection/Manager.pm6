use v6.c;

use SOUP::Raw::Types;
use SOUP::Raw::Connection::Manager;

use GIO::Stream;

use GLib::Roles::Implementor;
use GLib::Roles::Object;
use GIO::Roles::SocketConnectable;

# BOXED

class SOUP::Connection::Manager {
  has SoupConnectionManager $!scm is implementor;

  submethod BUILD ( :$soup-conn-mgr ) {
    $!scm = $soup-conn-mgr if $soup-conn-mgr;
  }

  method SOUP::Raw::Definitions::SoupConnectionManager
  { $!scm }

  method new (
    SoupSession() $session,
    Int()         $max_conns,
    Int()         $max_conns_per_host
  ) {
    my gint ($mc, $mcph) = ($max_conns, $max_conns_per_host);

    my $soup-conn-mgr = soup_connection_manager_new(
      $session,
      $mc,
      $mcph
    );

    $soup-conn-mgr ?? self.bless( :$soup-conn-mgr ) !! Nil;
  }

  method cleanup (Int() $cleanup_idle) {
    my gboolean $c = $cleanup_idle;

    soup_connection_manager_cleanup($!scm, $c);
  }

  method free {
    soup_connection_manager_free($!scm);
  }

  method get_connection (SoupMessageQueueItem() $item) {
    soup_connection_manager_get_connection($!scm, $item);
  }

  method get_max_conns {
    soup_connection_manager_get_max_conns($!scm);
  }

  method get_max_conns_per_host {
    soup_connection_manager_get_max_conns_per_host($!scm);
  }

  method get_num_conns {
    soup_connection_manager_get_num_conns($!scm);
  }

  method get_remote_connectable ( :$raw = False ) {
    propReturnObject(
      soup_connection_manager_get_remote_connectable($!scm),
      $raw,
      |GIO::SocketConnectable.getTypePair
    );
  }

  method set_max_conns (Int() $max_conns) {
    my guint $m = $max_conns;

    soup_connection_manager_set_max_conns($!scm, $m);
  }

  method set_max_conns_per_host (Int() $max_conns_per_host) {
    my guint $m = $max_conns_per_host;

    soup_connection_manager_set_max_conns_per_host($!scm, $m);
  }

  method set_remote_connectable (GSocketConnectable() $connectable) {
    soup_connection_manager_set_remote_connectable($!scm, $connectable);
  }

  method steal_connection (SoupMessage() $msg, :$raw = False) {
    propReturnObject(
      soup_connection_manager_steal_connection($!scm, $msg),
      $raw,
      |GIO::Stream.getTypePair
    );
  }

}
