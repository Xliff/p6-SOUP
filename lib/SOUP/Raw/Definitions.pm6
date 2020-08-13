use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Object;
use GLib::Raw::Subs;

use GLib::Roles::Pointers;

unit package SOUP::Raw::Structs;

constant soup is export = 'soup-2.4',v1;

constant SOUP_AUTH_DOMAIN_REALM                  is export = 'realm';
constant SOUP_AUTH_DOMAIN_PROXY                  is export = 'proxy';
constant SOUP_AUTH_DOMAIN_ADD_PATH               is export = 'add-path';
constant SOUP_AUTH_DOMAIN_REMOVE_PATH            is export = 'remove-path';
constant SOUP_AUTH_DOMAIN_FILTER                 is export = 'filter';
constant SOUP_AUTH_DOMAIN_FILTER_DATA            is export = 'filter-data';
constant SOUP_AUTH_DOMAIN_GENERIC_AUTH_CALLBACK  is export = 'generic-auth-callback';
constant SOUP_AUTH_DOMAIN_GENERIC_AUTH_DATA      is export = 'generic-auth-data';

constant SOUP_ADDRESS_NAME                       is export = 'name';
constant SOUP_ADDRESS_FAMILY                     is export = 'family';
constant SOUP_ADDRESS_PORT                       is export = 'port';
constant SOUP_ADDRESS_PROTOCOL                   is export = 'protocol';
constant SOUP_ADDRESS_PHYSICAL                   is export = 'physical';
constant SOUP_ADDRESS_SOCKADDR                   is export = 'sockaddr';


class SoupMessageHeaders is repr<CPointer> is export does GLib::Roles::Pointers { }


# ↓↓↓↓ Possibly to Structs ↓↓↓↓

class SoupRange              is repr<CStruct> is export does GLib::Roles::Pointers {
  has goffset $.start is rw;
  has goffset $.end   is rw;
}

class SoupAddress            is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS GObject $.parent;
}

class SoupAuthDomain         is repr<CStruct> is export does GLib::Roles::Pointers {
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

our %URI-SCHEME is export;

INIT {
  for <http https ftp file data resource ws wss> {
    %URI-SCHEME{ $_ } :=
    %URI-SCHEME{.uc } := cglobal(soup, '_SOUP_URI_SCHEME_' ~ .uc, Pointer);
  }
}
