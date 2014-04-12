#! /usr/bin/env perl

# Example:
#cd ~/sb/path
#find . -name '*.cpp' -exec perl ~/script.pl {} \;

use File::Copy;

# Get the file name from the command line
my $sourcePath = $ARGV[0];

# Create a backup
move($sourcePath, $sourcePath . ".bak");

# Open the file for read only
open inFile, $sourcePath . ".bak" or die $!;

open outFile, "..", $sourcePath or die $!;

print outFile "// New header text line 1\n";
print outFile "// New header text line 2\n";
print outFile "// New header text line 3\n";
print outFile "// New header text line 4\n";

# For every line in the current file...
while (my $curLine = <inFile>)
{
    print outFile $curLine;
}
close inFile;
close outFile;
