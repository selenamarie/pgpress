#!/usr/bin/perl -w

use Text::CSV;

my $csv = Text::CSV->new ( { binary => 1 } )  # should set binary attribute.
		or die "Cannot use CSV: ".Text::CSV->error_diag ();

open (my $fh, qq{/usr/bin/psql -AX -qt pgcontacts -c \"copy ( select continent, region, textcat_all(name ||E'\n<br/>'), pgemail, url, office_phone, cell_phone,xtra_line from people where verified = 't' group by region, continent, pgemail, url, xtra_line, office_phone, cell_phone order by continent,region ) to stdout csv \"| }) or die "can't get info from postgres!\n";

my ($continent_old, $region_old);

my $notfirst = 0;
print <<__HEADER__;

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"><html><head><META http-equiv="Content-Type" content="text/html; charset=utf-8"></head>

<body> 
Press Contacts
 
<div> 
<h1>Press Contacts</h1> 
 
<p>Please refer to the list of country contacts below for press enquiries.</p> 
<p>For general press enquiries in English, see <a href="#0.1_USA">USA &amp; General Enquiries</a>.</p> 
 
__HEADER__


my $brazil = 0;
print "<div id=\"pgPressContacts\"> \n";
while ( my $row = $csv->getline( $fh ) ) {

	my ($continent, $region, $name, $pgemail, $url, $office, $cell, $xtra_line) = @$row;

	$name =~ s/<br\/>$//;
	chomp $name;

	if ($continent_old ne $continent) { 
		# print the continent
		print "</dl>\n" if ($notfirst);
		print "<h2>" . $continent . "</h2>\n";
		print "<dl>\n";
		$notfirst = 1;
	}

	if ($region_old ne $region) {
		# print the region
		if ($region eq 'USA and General Enquiries') {
			print "<dt><a name ='0.1_USA'>" . $region . "</a></dt>\n";
		} elsif ($region eq 'Brazil') {
			print "<dt>" . $region . "</dt>\n" if ($brazil < 1);
		} else {
			print "<dt>" . $region . "</dt>\n";
		}
	}

	# Brazil and USA treated differently
	if ($region eq 'Brazil') {
		# print the user
		if ($brazil < 1) {
			print "<dd>" . $name . "\n";
		} else {
			print "<br />" . $name . "\n";
		}
		print "<br />Phone: " . $office . "\n" if ($office);
		print "<br />Cell: " . $cell . "\n" if ($cell);
		print "<br />" . $xtra_line . "\n" if ($xtra_line);
		if ($brazil > 0) {
			print "<br /><a href=\"mailto:" . $pgemail . "\">" . $pgemail . "</a>\n"; 
			print "<br /><a href=\"" . $url . "\">" . $url . "</a>\n" if ($url); 
			print "</dd>\n";
		}
		$brazil++;
	} else {
		# print the user
		print "<dd>" . $name . "\n";
		print "<br /><a href=\"mailto:" . $pgemail . "\">" . $pgemail . "</a>\n"; 
		print "<br />Phone: " . $office . "\n" if ($office);
		print "<br />Cell: " . $cell . "\n" if ($cell);
		print "<br /><a href=\"" . $url . "\">" . $url . "</a>\n" if ($url); 
		print "</dd>\n";
	}

	$continent_old = $continent;
	$region_old = $region;
}

print "</dl>\n";

print "</div>\n";

print <<__FOOTER__;
</div>

</body></html>
__FOOTER__

close $fh;
