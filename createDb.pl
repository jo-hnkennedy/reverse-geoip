#createDb.pl - creates an sqlLite db from the geoip csv files

#this should take 

use warnings;
use strict;

use DBI;

my $db = DBI->connect("dbi:SQLite:dbname=geoip", "", "");

open(my $blockFH, "<GeoLiteCity-Blocks.csv");

my $st;

#adding block file to db
my $i = 0;
while (<$blockFH>) {
	chomp;
	s/\"//g;
	my ($ip_start, $ip_end, $locID) = split(/,/);
	$st = $db->prepare("INSERT INTO blocks VALUES (?, ?, ?);");
	$st->execute($ip_start, $ip_end, $locID) or die "$DBI::errstr\n";
	$i++;
}		

open (my $locationFH, "<GeoLiteCity-Location.csv");

#addding location file to db
$i = 0;
while (<$locationFH>) {
	chomp;
	s/\"//g;
	my ($locID, $country, $region, $city, $postalCode, $latitude, $longitude, $metroCode, $areaCode) = split(/,/);
	my $st = $db->prepare("INSERT INTO locations VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);");
	$st->execute($locID, $country, $region, $city, $postalCode, $latitude, $longitude, $metroCode, $areaCode) or die "$DBI::errstr\n";
	$i++;
}

$db->close;
