use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GLib::Raw::Object;
use GIO::Raw::Definitions;
use SOUP::Raw::Definitions;
use SOUP::Raw::Enums;

unit package SOUP::Raw::Test;

### /usr/src/libsoup2.4-2.70.0/tests/test-utils.h

sub apache_cleanup ()
  is native(soup)
  is export
{ * }

sub apache_init ()
  returns uint32
  is native(soup)
  is export
{ * }

sub check_apache ()
  returns uint32
  is native(soup)
  is export
{ * }

sub debug_printf (gint $level, Str $message, Str)
  is native(soup)
  is export
{ * }

# sub soup_test_assert (gboolean $expr, Str $fmt, ...)
#   is native(soup)
#   is export
# { * }

sub test_cleanup ()
  is native(soup)
  is export
{ * }

sub soup_test_get_index ()
  returns SoupBuffer
  is native(soup)
  is export
{ * }

sub test_init (gint $argc, Str $argv, GOptionEntry $entries)
  is native(soup)
  is export
{ * }

sub soup_test_load_resource (Str $name, CArray[Pointer[GError]] $error)
  returns SoupBuffer
  is native(soup)
  is export
{ * }

sub soup_test_register_resources ()
  is native(soup)
  is export
{ * }

sub soup_test_request_close_stream (
  SoupRequest $req,
  GInputStream $stream,
  GCancellable $cancellable,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_test_request_read_all (
  SoupRequest $req,
  GInputStream $stream,
  GCancellable $cancellable,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(soup)
  is export
{ * }

sub soup_test_request_send (
  SoupRequest $req,
  GCancellable $cancellable,
  guint $flags,
  CArray[Pointer[GError]] $error
)
  returns GInputStream
  is native(soup)
  is export
{ * }

sub soup_test_server_get_uri (SoupServer $server, Str $scheme, Str $host)
  returns SoupURI
  is native(soup)
  is export
{ * }

sub soup_test_server_new (SoupTestServerOptions $options)
  returns SoupServer
  is native(soup)
  is export
{ * }

sub soup_test_server_quit_unref (SoupServer $server)
  is native(soup)
  is export
{ * }

sub soup_test_session_abort_unref (SoupSession $session)
  is native(soup)
  is export
{ * }

# sub soup_test_session_new (GType $type, ...)
#   returns SoupSession
#   is native(soup)
#   is export
# { * }

sub soup_test_session_new (
  # accept-language 	gchar*
  Str, Str,
  # accept-language-auto 	gboolean
  Str, gboolean,
  # add-feature 	SoupSessionFeature*
  Str, SoupSessionFeature,
  # add-feature-by-type 	GType* (GObject)
  Str, GObject,
  # async-context 	gpointer (GMainContext)
  Str, GMainContext,
  # http-aliases 	GStrv
  Str, CArray[Str],
  # https-aliases 	GStrv
  Str, CArray[Str],
  # idle-timeout 	guint
  Str, guint,
  # local-address 	SoupAddress*
  Str, SoupAddress,
  # max-conns 	gint
  Str, gint,
  # max-conns-per-host 	gint
  Str, gint,
  # proxy-resolver 	GProxyResolver*
  Str, GProxyResolver,
  # proxy-uri 	SoupURI*
  Str, SoupURI,
  # remove-feature-by-type 	GType* (Gobject)
  Str, GObject,
  # ssl-ca-file 	gchar*
  Str, Str,
  # ssl-strict 	gboolean
  Str, gboolean,
  # ssl-use-system-ca-file 	gboolean
  Str, gboolean,
  # timeout 	guint
  Str, guint,
  # tls-database 	GTlsDatabase*
  Str, GTlsDatabase,
  # tls-interaction 	GTlsInteraction*
  Str, GTlsInteraction,
  # use-ntlm 	gboolean
  Str, gboolean,
  # use-thread-context 	gboolean
  Str, gboolean,
  # user-agent 	gchar*
  Str, Str,
  # End
  Str
)
  returns SoupSession
  is native(soup)
  is export
{ * }
