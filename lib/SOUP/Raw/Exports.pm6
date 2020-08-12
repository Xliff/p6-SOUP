use v6.c;

unit package SOUP::Raw::Exports;

our @soup-exports is export;

BEGIN {
  @soup-exports = <
    SOUP::Raw::Definitions
  >;
}
