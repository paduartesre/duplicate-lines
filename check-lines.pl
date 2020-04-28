#!/usr/bin/perl
use strict;
use Digest::MD5;

my $file = "path/to-your-file/file.txt";   #insert path and file to verify
my ($input, $check);

open($input, $file) or die "Could not open $file: $!";  #check if posible read file
open($check, $file) or die "Could not open $file: $!";  #check if posible read file

my %hash;
my $passes = 2;   #In this point below, read line by line and check if exists lines duplicates and print result output with index name DUP each ocurrence finding.

for (my $pass = 0; $pass < $passes; $pass++) {
    while (!eof($input)) {
        my $location = tell($input);
        my $line = readline($input);
        chomp $line;
        my $digest = Digest::MD5::md5($line);
        my $p = ord($digest);

        if ($p % $passes != $pass) {
            next;
        }

        if (defined(my $ll = $hash{$digest})) {
            my $d = 0;
            for my $l (@$ll) {
                seek($check, $l, 0);
                my $checkl = readline($check);
                chomp $checkl;
                if ($checkl eq $line) {
                    print "DUP $line\n";
                    $d = 1;
                    last;
                }
            }
            if ($d == 0) {
                push(@{$hash{$digest}}, $location);
            }
        } else {
            push(@{$hash{$digest}}, $location);
        }
    }
    seek($input, 0, 0);
}
