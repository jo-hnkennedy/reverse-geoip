use warnings;
use strict;

use Text::CSV;

my $csvFile = $ARGV[0]; #THIS SHOULD BE THE BLOCK FILE

my $startTime = time;

my $postalCode = $ARGV[1];

#straight from meta cpan

my $csv = Text::CSV->new ( { binary => 1 } )  # should set binary attribute.
                or die "Cannot use CSV: ".Text::CSV->error_diag ();

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
