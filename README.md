# nwsweather
Perl script for scraping and formatting local observation data from a National Weather Service page

It's not exactly ideal...
It has a hardcoded URL and location text that would have to be changed for another location,
it expects the target data to be in the first line of the table of data scraped, 
it's output configuration is hardcoded and thus difficult to change,
and (as with any scraping code) it's brittle.

Nevertheless, I use it to parse data for display in Conky.
