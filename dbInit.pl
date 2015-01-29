use warnings;
use strict;

use DBI;

my $db = DBI->connect("dbi:SQLite:dbname=geoip", "", "");

open (my $blockFH, "<GeoLite2-City-Blocks-IPv4.csv");

my $i = 0;

my $st;

while (<$blockFH>) {
	chomp;
	my @split = split(/,/);
	$st = $db->prepare("INSERT INTO blocks (
