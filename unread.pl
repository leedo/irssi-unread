use strict;
use Irssi;
use List::Util qw(max);
use List::MoreUtils qw(any);

our $VERSION = "0.1";
our %IRSSI = (
    authors     => "Lee Aylward",
    contact     => "lee\@arstechnica.com",
    name        => "unread",
    description => "Adds a command to jump to next window with unread messages",
    license     => "GPLv2",
    url         => "http://github.com/leedo/irssi-unread",
    changed     => "Thu Mar 21 19:41:00 2013",
);

Irssi::command_bind('unread', 'cmd_unread');

sub cmd_unread {
  my $win  = Irssi::active_win()->{refnum};
  my @wins = grep {any {$_->{data_level} > 1} $_->items} Irssi::windows;
  my $max  = max map {$_->{refnum}} @wins;

  my @sorted = map {$_->[0]}
              sort {$a->[1] <=> $b->[1]}
               map {[$_, $_->{refnum} <= $win ? $_->{refnum} + $max : $_->{refnum}]}
                   @wins;

  $sorted[0]->set_active if @sorted;
}
