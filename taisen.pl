#!/usr/bin/perl
use strict;
use DBI;
use DBD::SQLite;

my $target= 1;
my $diff  = 1;

my $dbfile = "mleague.sqlite3";
my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile") or die;

my $i = 0;

my $sql = "";
my $sth = "";
my $rv = 0;
my $player = "";
my @dbh_bind;

my @players;
my @teams;
my %hash;

$sql = 'SELECT players.id, players.name, teams.name FROM players, teams WHERE players.team = teams.id ORDER BY players.id';
$sth = $dbh->prepare($sql);
@dbh_bind = ();
$rv = $sth->execute(@dbh_bind) or print $dbh->errstr();

while (my ($id, $player, $team) = $sth->fetchrow_array()){
  $players[$id] = $player;
  $teams[$id] = $team;
}

#
# print CSV Header
#
printf("GAME,PLAYER,SCORE");
for (my $j = 1; $j <= $#players; $j++){
	printf(",%s", $players[$j]);
}
printf("\n");

#
# For All players
#
	my @team_total_game = ();
	my @team_total_point = ();

for (my $k = 1; $k <= $#players; $k++){
	$target = $k;

	my @games = ();
	my @total_game = ();
	my @total_point = ();

	$player = $players[$target];
	$sql = 'SELECT DISTINCT game FROM scores WHERE player = ?';
	$sth = $dbh->prepare($sql);
	@dbh_bind = ($target);
	$rv = $sth->execute(@dbh_bind) or print $dbh->errstr();

	$i = 1;
	while (my ($game) = $sth->fetchrow_array()){
		$games[$i] = $game;
		$i++;
	}

	for ($i = 1; $i <= $#games; $i++){
		my $game = $games[$i];
		$sql = 'SELECT player, score FROM scores WHERE game = ?';
		$sth = $dbh->prepare($sql);
		@dbh_bind = ($game);
		$rv = $sth->execute(@dbh_bind) or print $dbh->errstr();
	
		my @result = (); 
		my $myscore = 0;

		while (my ($name, $score) = $sth->fetchrow_array()){
			if ($name == $target){
				$myscore = $score;
			}
		}

		$sql = 'SELECT player, score FROM scores WHERE game = ?';
		$sth = $dbh->prepare($sql);
		@dbh_bind = ($game);
		$rv = $sth->execute(@dbh_bind) or print $dbh->errstr();

		while (my ($name, $score) = $sth->fetchrow_array()){
			if ($name != $target){
				my $id = $name;
				$result[$id] = $score;
				if ($total_game[$id] eq ""){
					$total_game[$id] = 1;
					$total_point[$id] = $score;
					if ($diff == 1){
						$total_point[$id] = $total_point[$id] - $myscore;
					}
				}
				else {
					$total_game[$id] = $total_game[$id] + 1;
					$total_point[$id] = $total_point[$id] + $score;
					if ($diff == 1){
						$total_point[$id] = $total_point[$id] - $myscore;
					}
				}

				if ($team_total_game[$id] eq ""){
					$team_total_game[$id] = 1;
					$team_total_point[$id] = $score;
					if ($diff == 1){
						$team_total_point[$id] = $team_total_point[$id] - $myscore;
					}
				}
				else {
					$team_total_game[$id] = $team_total_game[$id] + 1;
					$team_total_point[$id] = $team_total_point[$id] + $score;
					if ($diff == 1){
						$team_total_point[$id] = $team_total_point[$id] - $myscore;
					}
				}
			}	
		}
		printf("%s,%s,%s", $game, $player,$myscore);
		for (my $j = 1; $j <= $#players; $j++){
			if ($diff == 1){
				printf(",%.1f", $result[$j]);
			}
			else {
				printf(",%.1f", ($result[$j] - $myscore));
			}
		}
		printf("\n");
	}
	#
	# if write 
	#
	if (1){
		printf(",,");
		for (my $j = 1; $j <= $#players; $j++){
			printf(",%.1f", $total_point[$j]);
		}
		printf("\n");
		printf(",,");
		for (my $j = 1; $j <= $#players; $j++){
			printf(",%d", $total_game[$j]);
		}
		printf("\n");

		if ($target % 4 == 0){
			printf(",,");
			for (my $j = 1; $j <= $#players; $j++){
				printf(",%.1f", $team_total_point[$j]);
			}
			printf("\n");
			printf(",,");
			for (my $j = 1; $j <= $#players; $j++){
				printf(",%d", $team_total_game[$j]);
			}
			printf("\n");
			printf("GAME,PLAYER,SCORE");
			for (my $j = 1; $j <= $#players; $j++){
				printf(",%s", $players[$j]);
			}
			printf("\n\n");
			@team_total_point = ();
			@team_total_game = ();
		}
	}
}
