#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $basename = $ARGV[0] || '.';
handle($basename);

sub handle {
	my $path = shift;

	if(-d "$path") {
		handle_dir($path);
	} elsif(-f "$path") {
		handle_file($path);
	}
}

sub handle_dir {
	my $dir = shift;
	#print "$dir\n";
	opendir(DIR, $dir);
	my @files = readdir(DIR);
	closedir(DIR);

	foreach my $file (@files) {
		next if($file =~ /^\.\.?$/);
		my $path = "$dir/$file";
		#print "path: $path\n";

		handle($path);
	}
}

sub handle_file {
	my $file = shift;
	print "$file\n";
}
