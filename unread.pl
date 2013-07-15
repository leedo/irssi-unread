use strict;
use Irssi;
use List::Util qw(max sum);

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

my @tests = (
  # has highlight
  sub {
    my ($win, $level) = @_;
    if ($win->{data_level} > 2) {
      return 3;
    }
    return 0;
  },

  # query window
  sub {
    my ($win, $level) = @_;
    if ($win->{type} eq "QUERY") {
      return 2;
    }
    return 0;
  },

  # is after the current window
  sub {
    my ($win, $level) = @_;
    my $cur  = Irssi::active_win();
    if ($win->{refnum} >= $cur->{refnum}) {
      return 1;
    }
    return 0;
  },

);

sub win_score { sum map { $_->(@_) } @tests }

sub cmd_unread {
  my @wins = grep { $_->[1] > 1 }
              map { [$_, max map {$_->{data_level}} $_->items] }
              Irssi::windows;

  return unless @wins;

  my @sorted = map { $_->[0] }
              sort { $b->[1] <=> $a->[1] }
               map { [$_, win_score @$_] } @wins;

  $sorted[0]->set_active;
}

