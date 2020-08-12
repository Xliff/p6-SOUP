use v6.c;

use NativeCall;

use GLib::Raw::Definitions;

use GLib::Roles::Pointers;

unit package SOUP::Raw::Structs;

constant soup = 'soup-2.4',v0;

class SoupMessageHeaders is repr<CPointer> is export does GLib::Roles::Pointers { }


# ↓↓↓↓ Possibly to Structs ↓↓↓↓

class SoupMessageHeadersIter is repr<CPointer> is export does GLib::Roles::Pointers {
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
  HAS GObject parent;

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
