#!/usr/local/bin/perl

my $player = "";
my $year = 0;
my $month = 0;
my $day = 0;
my $kaisen = 0;
my $flag_point = 0;

while (<>){
	$_ =~ s/\r//g;
	$_ =~ s/\n//g;

	if ($flag_point == 1){
		$_ =~ s/ //g;
		$_ =~ s/\t//g;
		$_ =~ s/▲/-/g;	
		$_ =~ s/pt//;
		$_ =~ s/\(.*\)//; #チョンボ対策
		$point = $_;

		if ($year >= 2021){
			printf("%04d%02d%02d%02d,%s,%s\n", $year, $month, $day, $kaisen, $player, $point);
		}
		$flag_point = 0;
		next;
	}

	if (/<div class=\"p-gamesResult__date\">(\d+)\/(\d+)</){
		$month = $1;
		$day = $2;
		if ($month >= 10){
			$year = 2021;
		}
		else {
			$year = 2022;
		}
		next;
	}

	if (/<div class=\"p-gamesResult__number\">[^0-9]+([0-9])[^0-9]+/){
		$kaisen = $1;
	}

	if (/<div class=\"p-gamesResult__name\">(.+)<\/div>/){
		$player = $1;
		next;
	}

	if (/<div class=\"p-gamesResult__point\">/){
		$flag_point = 1;
		next;
	}
}
