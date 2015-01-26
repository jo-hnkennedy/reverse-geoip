use warnings;
use strict;

use DBI;

my $db = DBI->connect("dbi:SQLite:dbname=geoip", "", "");

#open(my $blockFH, "<GeoLiteCity-Blocks.csv");

my $st;

#adding block file to db
my $i = 0;
#while (<$blockFH>) {
#	chomp;
#	s/\"//g;
#	my ($ip_start, $ip_end, $locID) = split(/,/);
#	$st = $db->prepare("INSERT INTO blocks VALUES (?, ?, ?);");
#	print("blocks $i ip_start : $ip_start ip_end : $ip_end locID : $locID\n");
#	$st->execute($ip_start, $ip_end, $locID) or die "$DBI::errstr\n";
#	$i++;
#}		

open (my $locationFH, "<GeoLiteCity-Location.csv");

#addding location file to db
$i = 0;
while (<$locationFH>) {
	chomp;
	s/\"//g;
	my ($locID, $country, $region, $city, $postalCode, $latitude, $longitude, $metroCode, $areaCode) = split(/,/);
	my $st = $db->prepare("INSERT INTO locations VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);");
	print("blocks $i locID : $locID country : $country city : $city areaCode : $areaCode postalCode : $postalCode\n");
	$st->execute($locID, $country, $region, $city, $postalCode, $latitude, $longitude, $metroCode, $areaCode) or die "$DBI::errstr\n";
	$i++;
}

$db->close;
