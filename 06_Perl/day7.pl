#!/usr/bin/perl

# Modules used
use strict;
use warnings;
  
# Read file
open(FH, '<', $ARGV[0]) or die $!;
my $line = <FH>;
close(FH);
my @fish = split(',', $line);

# Save fish by dates to birth
my @fishForDay = (0, 0, 0, 0, 0, 0, 0, 0, 0);
foreach my $days (@fish) 
{
    $fishForDay[$days] += 1;
}

# Simulate number of days by shifting the array and inserting the the original and new fish in the correct location
my $days = 256;
foreach(1..$days) {
    my $newFish = shift @fishForDay;
    $fishForDay[6] += $newFish;
    $fishForDay[8] += $newFish;
}

# Count the number of fish
my $sum = 0;
foreach my $fish (@fishForDay) {
    $sum += $fish
}

# Print the result
print($sum);