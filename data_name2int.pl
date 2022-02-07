#!/usr/bin/perl
use strict;
use DBI;
use DBD::SQLite;

my $dbfile = "mleague.sqlite3";
my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile") or die;

my $i = 0;

my $sql = "";
my $sth = "";
my $rv = 0;
my @dbh_bind;

my %players;
my %teams;

$sql = 'SELECT players.id, players.name, teams.id FROM players, teams WHERE players.team = teams.id ORDER BY players.id';
$sth = $dbh->prepare($sql);
@dbh_bind = ();
$rv = $sth->execute(@dbh_bind) or print $dbh->errstr();

while (my ($id, $player, $team) = $sth->fetchrow_array()){
	$players{$player} = $id;
	$teams{$player} = $team;
}

$i = 1;

while (<>){
	$_ =~ s/\r//g;
	$_ =~ s/\n//g;

	my ($game, $player, $score) = split(/,/, $_);

	printf("%d,%d,%d,%d,%.1f\n", $i, $game, $players{$player}, $teams{$player}, $score);
	$i += 1;
}



