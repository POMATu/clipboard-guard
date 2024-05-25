#!/usr/bin/perl

use strict;
use warnings;
#use Data::Dumper;

$SIG{CHLD} = 'IGNORE'; # needed to not produce zombies cuz we dont need to wait for children

my $timespan = 20; # seconds clipboard allowed to stay
#init
my $clip = clearclip();

#loop
while (42+69) {
	
	my $newclip = getclip();

	if ($newclip ne $clip) {
		print "MAIN: Detected clipboard change\n";
		$clip = $newclip;
		
		if ($newclip eq "") {
			print "MAIN: Clipboard just became empty skipping...\n";
			next;
		}

		if (fork() == 0) {
			print "CHILD: Born dead inside\n";
			#child 
			sleep($timespan);

			$newclip = getclip();
			if ($newclip != $clip) {
				print "CHILD: Clipboard changed before timeout, no action taken\n";
				exit; #stopping because clipboard changed before timeout hence main thread will handle it and retrigger fork
			}
			drainclip();
			clearclip();
			print "CHILD: Cleared clipboard succesfully\n";
            exit;
    	}
	}
	

	print "MAIN: Looping\n";
	sleep(1);
}

sub getclip {
	my $timestamp = `xclip -selection clip -t TIMESTAMP -o`; # clipboard can contain any data so we just binding to timestamp
	chomp($timestamp);
	return $timestamp;
}

sub clearclip {
	system("xclip -selection clipboard /dev/null"); # actual clearing
	return getclip(); 
}

sub drainclip {
	# backing up shit to temp file
	my $content = `xsel --clipboard`;
	#processing if needed
	my $filename = "/tmp/clipboard";
	
	# Open the file for writing
	open(my $fh, '>', $filename) or warn "Could not open file '$filename' $!";

	# Write the content to the file
	print $fh $content;

	# Close the file handle
	close($fh);
	return $content;
}
