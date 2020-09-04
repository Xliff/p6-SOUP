use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GLib::Raw::Object;
use GLib::Raw::Subs;
use GIO::Raw::Definitions;
use GIO::Raw::Structs;

use GLib::Roles::Pointers;

unit package SOUP::Raw::Definitions;

constant soup is export = 'soup-2.4',v1;

constant SOUP_AUTH_DOMAIN_REALM                  is export = 'realm';
constant SOUP_AUTH_DOMAIN_PROXY                  is export = 'proxy';
constant SOUP_AUTH_DOMAIN_ADD_PATH               is export = 'add-path';
constant SOUP_AUTH_DOMAIN_REMOVE_PATH            is export = 'remove-path';
constant SOUP_AUTH_DOMAIN_FILTER                 is export = 'filter';
constant SOUP_AUTH_DOMAIN_FILTER_DATA            is export = 'filter-data';
constant SOUP_AUTH_DOMAIN_GENERIC_AUTH_CALLBACK  is export = 'generic-auth-callback';
constant SOUP_AUTH_DOMAIN_GENERIC_AUTH_DATA      is export = 'generic-auth-data';

constant SOUP_AUTH_DOMAIN_DIGEST_AUTH_CALLBACK   is export = 'auth-callback';
constant SOUP_AUTH_DOMAIN_DIGEST_AUTH_DATA       is export = 'auth-data';

constant SOUP_ADDRESS_NAME                       is export = 'name';
constant SOUP_ADDRESS_FAMILY                     is export = 'family';
constant SOUP_ADDRESS_PORT                       is export = 'port';
constant SOUP_ADDRESS_PROTOCOL                   is export = 'protocol';
constant SOUP_ADDRESS_PHYSICAL                   is export = 'physical';
constant SOUP_ADDRESS_SOCKADDR                   is export = 'sockaddr';
constant SOUP_ADDRESS_ANY_PORT                   is export = 0;

constant SOUP_AUTH_SCHEME_NAME                   is export = 'scheme-name';
constant SOUP_AUTH_REALM                         is export = 'realm';
constant SOUP_AUTH_HOST                          is export = 'host';
constant SOUP_AUTH_IS_FOR_PROXY                  is export = 'is-for-proxy';
constant SOUP_AUTH_IS_AUTHENTICATED              is export = 'is-authenticated';

constant SOUP_SERVER_TLS_CERTIFICATE             is export = 'tls-certificate';
constant SOUP_SERVER_RAW_PATHS                   is export = 'raw-paths';
constant SOUP_SERVER_SERVER_HEADER               is export = 'server-header';
constant SOUP_SERVER_HTTP_ALIASES                is export = 'http-aliases';
constant SOUP_SERVER_HTTPS_ALIASES               is export = 'https-aliases';

constant SOUP_SOCKET_LOCAL_ADDRESS               is export = 'local-address';
constant SOUP_SOCKET_REMOTE_ADDRESS              is export = 'remote-address';
constant SOUP_SOCKET_FLAG_NONBLOCKING            is export = 'non-blocking';
constant SOUP_SOCKET_IS_SERVER                   is export = 'is-server';
constant SOUP_SOCKET_SSL_CREDENTIALS             is export = 'ssl-creds';
constant SOUP_SOCKET_SSL_STRICT                  is export = 'ssl-strict';
constant SOUP_SOCKET_SSL_FALLBACK                is export = 'ssl-fallback';
constant SOUP_SOCKET_TRUSTED_CERTIFICATE         is export = 'trusted-certificate';
constant SOUP_SOCKET_ASYNC_CONTEXT               is export = 'async-context';
constant SOUP_SOCKET_USE_THREAD_CONTEXT          is export = 'use-thread-context';
constant SOUP_SOCKET_TIMEOUT                     is export = 'timeout';
constant SOUP_SOCKET_TLS_CERTIFICATE             is export = 'tls-certificate';
constant SOUP_SOCKET_TLS_ERRORS                  is export = 'tls-errors';

class SoupMessageHeaders     is repr<CPointer> is export does GLib::Roles::Pointers { }
class SoupSessionFeature     is repr<CPointer> is export does GLib::Roles::Pointers { }

# ↓↓↓↓ Possibly to Structs ↓↓↓↓

class SoupRange              is repr<CStruct> is export does GLib::Roles::Pointers {
  has goffset $.start is rw;
  has goffset $.end   is rw;
}

class SoupAddress            is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS GObject $.parent;
}

class SoupAuth               is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS GObject $.parent;
  has Str     $!realm;

  method realm is rw {
    Proxy.new:
      FETCH => -> $         { $!realm      },
      STORE => -> $, Str \r { $!realm := r };
  }

}

class SoupAuthDomain         is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS GObject $.parent;
}

class SoupAuthDomainBasic    is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS SoupAuthDomain $.parent;
}

class SoupAuthDomainDigest   is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS SoupAuthDomain $.parent;
}

class SoupCookieJar          is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS GObject $.parent;
}

class SoupRequest            is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS GObject $.parent;
  has Pointer $!priv;
}

class SoupMessageHeadersIter is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS gpointer @.dummy[3] is CArray;
}

class SoupBuffer is repr<CStruct> is export does GLib::Roles::Pointers {
    has Str   $!data;
    has gsize $.length is rw;

    method data is rw {
      Proxy.new:
        FETCH => -> $ { $!data },
        STORE => -> $, Str \s { $!data := s };
    }
}

class SoupURI is repr<CStruct> is export does GLib::Roles::Pointers {
  has Str    $!scheme   ;
  has Str    $!user     ;
  has Str    $!password ;
  has Str    $!host     ;
  has guint  $.port     is rw;
  has Str    $!path     ;
  has Str    $!query    ;
  has Str    $!fragment ;

  method scheme-check (Pointer $s) {
    +cast(Pointer, $!scheme) == +$s
  }

  method scheme is rw {
    Proxy.new:
      FETCH => -> $ { $!scheme },
      STORE => -> $, Str \s { $!scheme := s };
  }

  method user is rw {
    Proxy.new:
      FETCH => -> $ { $!user },
      STORE => -> $, Str \s { $!user := s };
  }

  method password is rw {
    Proxy.new:
      FETCH => -> $ { $!password },
      STORE => -> $, Str \s { $!password := s };
  }

  method host is rw {
    Proxy.new:
      FETCH => -> $ { $!host },
      STORE => -> $, Str \s { $!host := s };
  }

  method path is rw {
    Proxy.new:
      FETCH => -> $ { $!path },
      STORE => -> $, Str \s { $!path := s };
  }

  method query is rw {
    Proxy.new:
      FETCH => -> $ { $!query },
      STORE => -> $, Str \s { $!query := s };
  }

  method fragment is rw {
    Proxy.new:
      FETCH => -> $ { $!fragment },
      STORE => -> $, Str \s { $!fragment := s };
  }
}

class SoupMessageBody is repr<CStruct> is export does GLib::Roles::Pointers {
    has Str     $.data   is rw;
    has goffset $.length is rw;
}

class SoupMessage is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS GObject            $.parent;

  has Str                $.method           is rw;
  has guint              $.status_code      is rw;
  has Str                $.reason_phrase    is rw;
  has SoupMessageBody    $!request_body     ;
  has SoupMessageHeaders $!request_headers  ;
  has SoupMessageBody    $!response_body    ;
  has SoupMessageHeaders $!response_headers ;

  method request_body is rw {
    Proxy.new:
      FETCH => -> $ { $!request_body },
      STORE => -> $, SoupMessageBody \b { $!request_body := b };
  }

  method response_body is rw {
    Proxy.new:
      FETCH => -> $ { $!request_body },
      STORE => -> $, SoupMessageBody \b { $!response_body := b };
  }

  method request_headers is rw {
    Proxy.new:
      FETCH => -> $ { $!request_body },
      STORE => -> $, SoupMessageHeaders \h { $!request_headers := h };
  }

  method response_headers is rw {
    Proxy.new:
      FETCH => -> $ { $!request_body },
      STORE => -> $, SoupMessageHeaders \h { $!response_headers := h };
  }

}

class SoupDate is repr<CStruct> is export does GLib::Roles::Pointers {
  has int32    $.year   is rw;
  has int32    $.month  is rw;
  has int32    $.day    is rw;
  has int32    $.hour   is rw;
  has int32    $.minute is rw;
  has int32    $.second is rw;
  has gboolean $.utc    is rw;
  has int32    $.offset is rw;
}

class SoupCookie is repr<CStruct> is export does GLib::Roles::Pointers {
  has Str      $!name           ;
  has Str      $!value          ;
  has Str      $!domain         ;
  has Str      $!path           ;
  has SoupDate $!expires        ;
  has gboolean $.secure    is rw;
  has gboolean $.http_only is rw;

  method name is rw {
    Proxy.new:
      FETCH => -> $         { $!name },
      STORE => -> $, Str \s { $!name := s};
  }
  method value is rw {
    Proxy.new:
      FETCH => -> $         { $!value },
      STORE => -> $, Str \s { $!value := s };
  }
  method domain is rw {
    Proxy.new:
      FETCH => -> $         { $!domain },
      STORE => -> $, Str \s { $!domain := s };
  }
  method path is rw {
    Proxy.new:
      FETCH => -> $         { $!path },
      STORE => -> $, Str \s { $!path := s };
  }
  method expires is rw {
    Proxy.new:
      FETCH => -> $                { $!expires      },
      # cw: XXX - Will NC bind work with CStruct? This should be tested!
      STORE => -> $, SoupDate() \d { $!expires := d };
  }
}

class SoupSession              is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS GObject     $.parent;
}

class SoupRequestHTTP          is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS SoupRequest $.parent;
  has Pointer     $!priv;
}

class SoupRequestData          is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS SoupRequest $.parent;
  has Pointer     $!priv;
}

class SoupRequestFile          is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS SoupRequest $.parent;
  has Pointer     $!priv;
}

class SoupWebsocketConnection  is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS GObject $.parent;
  has Pointer $!priv;
}

class SoupCache                is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS GObject $.parent;
  has Pointer $!priv;
}

class SoupMultipartInputStream is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS GFilterInputStream $.parent;
  has Pointer            $!priv;
}

class SoupSocket              is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS GObject $.parent;
}

class SoupServer              is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS GObject $.parent;
}

# Taken from implementation, No public members!
class SoupMultipart           is repr<CStruct> is export does GLib::Roles::Pointers {
  has Str       $!mime_type;
  has Str       $!boundary;
  has GPtrArray $!headers;
  has GPtrArray $!bodies;
}

# Taken from implementation, No public members!
class SoupClientContext       is repr<CStruct> is export does GLib::Roles::Pointers {
  has SoupServer     $!server;
  has SoupSocket     $!sock;
  has GSocket        $!gsock;
  has SoupMessage    $!msg;
  has SoupAuthDomain $!auth_domain;
  has Str            $!auth_user;
  has GSocketAddress $!remote_addr;
  has Str            $!remote_ip;
  has GSocketAddress $!local_addr;
  has int64          $!ref_count;
}

class SoupCookieJarDB         is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS SoupCookieJar $.parent;
}

class SoupCookieJarText       is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS SoupCookieJar $.parent;
}

class SoupAuthManager         is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS GObject $.parent;
  has Pointer $!private;
}

class SoupContentDecoder      is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS GObject $.parent;
  has Pointer $!private;
}

class SoupContentSniffer      is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS GObject $.parent;
  has Pointer $!private;
}

class SoupLogger              is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS GObject $.parent;
}

our %SOUP-URI-SCHEME  is export;
our %SOUP-METHOD      is export;
our @SOUP-METHODS     is export = <
  options  get       head  post put  delete trace connect
  propfind proppatch mkcol copy move lock   unlock
>;
our @SOUP-URI-SCHEMES is export = <http https ftp file data resource ws wss>;

INIT {
  for @SOUP-URI-SCHEMES {
    %SOUP-URI-SCHEME{ $_ } :=
    %SOUP-URI-SCHEME{.uc } := cglobal(soup, '_SOUP_URI_SCHEME_' ~ .uc, Pointer);
  }
  for @SOUP-METHODS {
    %SOUP-METHOD{ $_ } :=
    %SOUP-METHOD{.uc } := cglobal(soup, '_SOUP_METHOD_' ~ .uc, Pointer);
  }
}
