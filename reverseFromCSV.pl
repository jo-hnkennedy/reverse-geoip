use warnings;
use strict;

use Text::CSV_XS;

my $csvFile;
my $postalCode;

if ($ARGV[0] =~ /^[\d-]+$/) { #if zip code
	$postalCode = $ARGV[0];
	$csvFile = "GeoLite2-City-Blocks-IPv4.csv";
}

else { #then argv[1] 
	$csvFile = $ARGV[0]; #THIS SHOULD BE THE BLOCK FILE
	$postalCode = $ARGV[1];
}

my $startTime = time;


#straight from meta cpan

my $csv = Text::CSV_XS->new ( { binary => 1 } )  # should set binary attribute.
                or die "Cannot use CSV: ".Text::CSV_XS->error_diag ();

open my $fh, "<$csvFile" or die $!;

#printing ip array if matching postalCode

print("Searching for postal code $postalCode\n");

my $resultCount = 0;
while ( my $row = $csv->getline( $fh ) ) {
        $row->[6] =~ /$postalCode/ or next; # 3rd field should match
        print("$row->[0]\n");
	$resultCount++;
}
$csv->eof or $csv->error_diag();
close $fh;

my $timeSpent = time - $startTime;

my $minutes = int($timeSpent / 60);
my $seconds = $timeSpent % 60;

print("Found $resultCount results, $timeSpent seconds ($minutes minutes, $seconds seconds)\n");
