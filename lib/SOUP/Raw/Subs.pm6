use v6.c;

use SOUP::Raw::Definitions;
use SOUP::Raw::Enums;

unit package SOUP::Raw::Subs;

sub statusIsTransportError ($code) is export { $code ~~   0..^100 }
sub statusIsInformational  ($code) is export { $code ~~ 100..^200 }
sub statusIsSuccessful     ($code) is export { $code ~~ 200..^300 }
sub statusIsRedirection    ($code) is export { $code ~~ 300..^400 }
sub statusIsClientError    ($code) is export { $code ~~ 400..^500 }
sub statusIsServerError    ($code) is export { $code ~~ 500..^600 }