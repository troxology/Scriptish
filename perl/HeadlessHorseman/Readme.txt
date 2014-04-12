HeadlessHorseman

This folder contains 2 scripts that together find and replace the text at the top of a given file.

The use case for this would be if you have a bunch of scripts with boilerplate text (e.g. copyright) at the top of a given source file, followed immediately by a keyword (e.g. 'Filename:') indicating the rest of the header text.

It's a simple script that first creates a copy of the original file without the legacy boilerplate text.  Then, it makes a new verison with the new boilerplate text, and pastes in the rest of the file from the backup copy.  Files without boilerplate text are noted at the command line.