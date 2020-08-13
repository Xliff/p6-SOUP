use v6;

use GLib::Raw::Exports;
use GIO::Raw::Exports;
use SOUP::Raw::Exports;

unit package SOUP::Raw::Types;

need GLib::Raw::Definitions;
need GLib::Raw::Enums;
need GLib::Raw::Object;
need GLib::Raw::Structs;
need GLib::Raw::Struct_Subs;
need GLib::Raw::Subs;
need GLib::Raw::Exports;
need GIO::Raw::Definitions;
need GIO::Raw::Enums;
need GIO::Raw::Structs;
need GIO::Raw::Subs;
need GIO::Raw::Exports;
need GIO::DBus::Raw::Types;
need SOUP::Raw::Definitions;
need SOUP::Raw::Enums;

BEGIN {
  glib-re-export($_) for |@glib-exports,
                         |@gio-exports,
                         |@soup-exports;
}
