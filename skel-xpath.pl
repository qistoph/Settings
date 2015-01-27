#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use XML::XPath;

my $xp = new XML::XPath(filename => 'YOUR FILENAME');
my $nodeset = $xp->findnodes('YOUR XPATH');

print $nodeset->size()."\n";
foreach my $node ($nodeset->get_nodelist) {
	my $ns_part = $node->findnodes('SUBNODE XPATH');
	print $node->getAttribute('name').":\n";

	foreach my $n_part ($ns_part->get_nodelist) {
		print '- '.$n_part->getAttribute('element').' ('.$n_part->getAttribute('name').")\n";
	}
}
