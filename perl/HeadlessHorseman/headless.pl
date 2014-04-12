#! /usr/bin/env perl

# Example:
#cd ~/sb/path
#find . -name '*.cpp' -exec perl ~/script.pl {} \;

# For each file
    # while not eof && not header done
    # readline
    # if line contain "KEYWORD"
	    # headerdone
    # else
	    # delete and continue
#

use File::Copy;

# Get the file name from the command line
my $sourcePath = $ARGV[0];
#print $sourcePath;

# Create a backup
move($sourcePath, $sourcePath . ".bak");

# Open the file for read only
open inFile, $sourcePath . ".bak" or die $!;

open outFile, ">>", $sourcePath or die $!;

# Set the header flag to false
my $headerDone = 0;

my $write_pos = 0;

my $headerFound = 0;
#For every line in the current file...
while (my $curLine = <inFile>)
{
    if ($curLine =~/KEYWORD/)
    {
	    $headerFound = 1;
    }
}
close inFile;

if$headerFound ==1)
{
    open inFile, $sourcePath . ".bak" or die$!;
    # For every line in the current file...
    print "\nParsing $sourcePath...";
    while (my $curLine = <inFile>)
    {
	    if ($headerDone == 0)
	    {
		    # Make sure we only get rid of comments or blank lines
		    if ($curLine =~ /\/\// or $curLine =~ /^\s/)
		    {
		    }
		    else
		    {
			    print "***" . $curLine;
		    }

		    if  ($curLine =~ /KEYWORD/)
		    {
			    $headerDone = 1;
			    print outFile $curLine;
		    }
	    }
	    else
	    {
		    print outFile $curLine;
	    }
    }
    close inFile;
    close outFile;
}
else
{
    print "\nNot parsing $sourcePath";
    move ($sourcePath . ".bak", $sourcePath);
}
