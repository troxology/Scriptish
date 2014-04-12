#!/usr/bin/perl -w
# to run the script type in the following two commands as you see here:
#cd your/module
#find . -name ‘Root’ -exec perl ~/updateCVSRoot.pl {} \;

my $file = shift;
my $content = “”;
open (FILE, $file) || die “Can’t open $file: $!\n”;
while (<FILE>)
{
	s{oldcvsroot}{newcvsroot}g;
}
close(FILE);
open(FILE,”>$file”) || die “Can’t open $file: $!\n”;
print File $content;
close(FILE);
