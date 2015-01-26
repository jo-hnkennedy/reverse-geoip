use warnings;
use strict;

use Geo::IP;
use DBI;
use DBD::SQLite;


my $geo = Geo::IP->open("/Users/john/white/geoip/GeoLiteCity.dat", GEOIP_STANDARD);

my $db = DBI->connect("dbi:SQLite:dbname=geoip", "", "");

my $inputZip;

#getting input zip code
if ($ARGV[0]) {
	$inputZip = $ARGV[0];
}

#if not in command line args, prompt and read from stdin
else {
	print("Please enter a zip code: ");
	chomp($inputZip = <>);
}

print("Your input zipcode: $inputZip\n");

#finding region
my $st = $db->prepare("SELECT locID FROM locations WHERE postalCode = ?");
$st->execute($inputZip);

while (my @rowArray = $st->fetchrow_array) {
	
	#finding ip start, finish
	$st = $db->prepare("SELECT ip_start, ip_end FROM blocks WHERE locID = ?");

	$st->execute($rowArray[0]) or die "$DBI::errstr\n";

	while (my ($ip_start, $ip_finish) = $st->fetchrow_array) {
		print("ip ranges $ip_start to $ip_finish\n");
	}
}
