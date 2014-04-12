#! /usr/bin/env perl

# Usage:
#   Do a find, exec to pass in the path to the file
#   Create a folder of the class name, and put all the functions in it

# Example:
#cd ~/sb/path
#find . -name '*.cc' -exec perl ~/script.pl {} \;

# V4:
#   - Change path of output files to match source code repository
#     (e.g. full/path/to/ClassName/FunctionName
#   - This version is even more of a hack than before...I got lazy and
#     hardcoded in the path (i.e. change to the product_functions manually!!)
#   Note: the paths get screwy depending on what system you run on...so this version of
#     the script runs on solaris but not lnx64

# V2:
#   - Writes function names to a function list
#   - Appends overloaded functions instead of overwriting
#   - This meaans you need an EMPTY directory to start with

# To do:
#   - Keep count of overloaded functions

# Get the file name from the command line
my $fullPath = $ARGV[0];

# Assume the class name is the file name minus .cpp
#print $fullPath . "\n";
my $pathToClass = $fullPath;
#$pathToClass =~ s/(\w+).cpp$//;
my $className = $1;

# Create a folder based on the file name
my $tmp = "~/tasks/headless/firsttyry/." . $pathToClass;
chdir $tmp;
my $sourcePath = $fullPath;
$fullPath = "/home/troxlet/tasks/product/." . $pathToClass . $className;
mkdir $fullPath; # or die $!;

# Open the *.cpp file for read only
open inFile, $sourcePath or die$!;

# Drop every function name into a file
# Can use this to compare with another generated function list
open functionListFile, ">", $fullPath . "\/functionList.txt" or die $!;

my $outputOn = 0;
$startLine = 0;
$rb = 0;
$lb = 0;
my $rParenCount = 0;

# For every line in the current file...
while (my $curLine = <inFile>) {

    $lineNumber = $.;
	   #print $lineNumber . "\n";

    if (!$inFunction) {
	    #if a function has ended
	    #see if we are at a new function

	    # Ignore these lines which might otherwise be parsed by the next regex
	    if ($curLine =~/\;/ or $curLine =~ /<</ or $curLine =~/^\/\//) {

	    }
	    # Is this a destructor?
	    elsif ($curLine =~ /$className\;\;~([\w\d]+)/) {
		    #$print $curLine . "\n";
		    # If the regex cathes this, we ahve hit a new function
		    # So, close the previous file and open up a new one with
		    # the function name grabbed via regex
		    # While we're at it, print the function name to the function list file
		    close outFile;

		    #rename outfile we just closed
	  	    #print $fullpath . "\/" . $functionName, $fullPath . "\/" . $functionName . "_" . $paramName . "\n";
		    rename($fullpath . "\/" . $functionName, $fullPath . "\/" . $functionName . "_" . $paramName);# or die $!;

		    $functionName = $1;
		    print functionListFile $1 . "\n";
		    open outFile, ">>", $fullPath . "\/" . $1 or die $!;
		    $inFunction = 1;
		    $getParams = 1;
		    $startLine = $lineNumber;
		    $newName = "";
		    $paramLine = "";
		    $paramName = "_destructor_";
	    }
	    # This is the regez we care about:
	    elsif ($curLine =~ /$className\:\:([\w\d]+)/) {
		    #print $curLine . "\n";
		    # If the regex cathes this, we ahve hit a new function
		    # So, close the previous file and open up a new one with
		    # the function name grabbed via regex
		    # While we're at it, print the function name to the function list file
		    close outFile;

		    #rename outfile we just closed
	  	    #print $fullpath . "\/" . $functionName, $fullPath . "\/" . $functionName . "_" . $paramName . "\n";
		    rename($fullpath . "\/" . $functionName, $fullPath . "\/" . $functionName . "_" . $paramName);# or die $!;

		    $functionName = $1;
		    print functionListFile $1 . "\n";
		    open outFile, ">>", $fullPath . "\/" . $1 or die $!;
		    $inFunction = 1;
		    $getParams = 1;
		    $startLine = $lineNumber;
		    $newName = "";
		    $paramLine = "";
		    $paramName = "";
	    }
    }

    #if a function has started
    #write to the current file
    #update bracket count
    #see if the function has ended
    if ($inFunction) {
	    print outFile $curLine;
	    $rb += ($curLine =~/\(/ );
	    #print $lineNumber . ": " . $rb . "\n";
	    if ( $rb )
	    {
		    $lb += ( $curLine =~ /\)/ );
		    $count = $rb - $lb;

		    #print "R:$rb L:$lb diff:$count\n";

		    if ( ( $count == 0 ) && ( $lineNumber != $startLine ) )
		    {
			    $inFunction = 0;
			    $rb = 0;
			    $lb = 0;
		    }
	    }
    }

    # Get the paramter list
    if ($getParams) {
		 @splitLine = split('\)', $curLine, 2);
	    $lineWhichiCareAbout = $splitLine[0];
	    #print $curLine . "\n";
	    #print $lineWhichICareAbout . "\n";
	    if ($splitLine[1]) {
		    #print $splitLine[1];
		    $lineWhichICareAbout .= ")";
		    #print $lineWhichICareAbout . "\n";
	    }

	    # Remove leading and trailing whitespace
	    $tempLine = $lineWhichICareAbout;
	    $tempLine =~ s/^\s+//;
	    $tempLine =~ s/\s+$//;

	    $paramLine = $paramLine . "_" . $tempLine;

	    # Any right parantheses on the current line?
	    $rParenCount = ($curLine =~ /\)/);
	    # If so, we can finish up the parameter name
	    if( $rParenCount > 0 ) {
		    # First, get rid of variable names
		    # To do this, split on the commas, remove anything after
		    # the first space, then put it back together again.
		    # Then, do the old logic again where we replace
		    # non-alphanumerics with a '_' for good measure
		    $paramLine =~/$functionName\(([\w\W]*)\)/;
		    $tempLine = $1;

		    $allParams = "";
			@splitLine = split(',', $tempLine);
		    foreach $param (@splitLine) {
			    @splitParam = split(' ', $param);
			    $numSplitParam = scalar @splitParam;
			    for($count = 0; $count <= $numSplitParam - 2; $count++) {
				    $allParams .= "_" . $splitParams[$count];
			    }
		    }
		    #$paramName .= $1;
		    #$paramName =~ s/[\W\s]+/_/g;
		    $paramName .= $allParams;
		    $paramName =~ s/[\W\s]+/_/g;
		    #print $paramName . "\n";
		    $getParams = 0;
	    }
    }
}

# And don't forget to do the renaming again since we broke out of the loop before finishing up...
rename($fullPath . "\/" . $functionname, $fullPath . ""\/" . $functionName . "_" . $paramName);# or die$!;

# Close up all open files
close inFile;
close outFile;
close functionListFile;
	
