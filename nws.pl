#!/usr/bin/perl -w
#
# National Weather Service local observation data parser for conky
#

# MIT License
# 
# Copyright (c) 2017 David Yockey
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

$url="https://forecast.weather.gov/obslocal.php?warnzone=VAZ054&local_place=Arlington%20VA&zoneid=EST&offset=18000";
$location="Washington/Reagan";

# 'my's suppress warnings about variables that are only used once
my $wloc="1";		# Location
my $wtime="2";		# Estimated time of last data update
my $wsky="3";		# Sky conditions (Fair, Cloudy, Rain, etc.)
my $wtemp="4";		# Temperature (°F)
my $wdewpt="5";		# Dewpoint (°F)
my $whumid="6";		# Humidity (%)
my $wwind="7";		# Wind (mph)
my $wpres="8";		# Pressure (in)

# The second '$grep location' in the following insures
# that the result is blank, so conky isn't fed the wrong data,
# if the weather.gov page is changed such that the target info
# is no longer in the first line of the table...
#

## Retreive the NWS weather page from the net
$page = `curl -s $url`;

## Get the line of the page that includes rows of weather infomation
@all_lines = split /\n/, $page;
@wline = grep /$location/, @all_lines;
$wline = $wline[0];
$wline =~ /$location/;

## Truncate the line to obtain only the first row, assumed to be the information of interest
## (based on the particular page being retreived)
$wline =~ s/(<\/tr>).*/$1/;

## Extract pertinent data from the row and combine it with the $display variable to produce a line formatted for display by conky
$wline =~ s/^.*<td.*><a.*>(.*)<\/a><\/td><td.*>(.*)<\/td><td.*> ?(.*)<\/td><td.*>(.*)<\/td><td.*>(.*)<\/td><td.*>(.*)<\/td><td.*>(.*)<\/td><td.*>(.*)<\/td>.*/ $$wsky\n $$wtemp°F  $$wpres\"  Humid: $$whumid%  Wind: $$wwind/;

## Convert pressure in inches of mercury to mm of mercury
@pres_in = $wline =~ /.* (.*)\".*/;
$pres_mmHg = $pres_in[0] * 25.4;
$pres_mmHg =~ s/(.{1,4}?)\.(.?).*/$1\.$2/;
$pres_mmHg .= "mmHg";

## Convert pressure in inches of mercury to hectopascals
$pres_hPa = $pres_in[0] / 29.53 * 1000;
$pres_hPa =~ s/(.{1,4}?)\.(.?).*/$1/;
$pres_hPa .= "hPa";

## Comment out both following $wline assignments to print pressure in inches of mercury.
## Uncomment the $wline assignment to print pressure in particular units.
#$wline =~ s/(.*) (.*\") (.*)/$1 $pres_mmHg $3/;
$wline =~ s/(.*) (.*\") (.*)/$1 $pres_hPa $3/;
print "$wline\n";
