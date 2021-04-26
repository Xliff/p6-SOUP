use v6.c;

use NativeCall;

use SOUP::Raw::Types;
use GLib::Class::Object;

use GLib::Roles::Pointers;

unit package SOUP::Class::Auth;

class SoupAuthClass is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS GObjectClass $.parent_class;
  has Str          $.scheme_name;
  has guint        $.strength;

  has Pointer      $!update;               # gboolean     (*update)               (SoupAuth      *auth, SoupMessage   *msg, GHashTable    *auth_header);
  has Pointer      $!get_protection_space; # GSList *     (*get_protection_space) (SoupAuth      *auth, SoupURI       *source_uri);
  has Pointer      $!authenticate;         # void         (*authenticate)         (SoupAuth      *auth, const char    *username, const char    *password);
  has Pointer      $!is_authenticated;     # gboolean     (*is_authenticated)     (SoupAuth      *auth);
  has Pointer      $!get_authorization;    # char *       (*get_authorization)    (SoupAuth      *auth, SoupMessage   *msg);
  has Pointer      $!is_ready;             # gboolean     (*is_ready)             (SoupAuth      *auth, `SoupMessage   *msg);
  has Pointer      $!can_authenticate;     # gboolean     (*can_authenticate)     (SoupAuth      *auth);

  # Padding for future expansion
  has Pointer      $!reserved3;         # void (*_libsoup_reserved3) (void);
  has Pointer      $!reserved4;         # void (*_libsoup_reserved4) (void);
}
