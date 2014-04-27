#!/usr/bin/perl

####
## Topic: Parse Webserver Access log for offical web crawlers to allow them in iosec
<<<<<<< HEAD
## Version: 1.2 / 24.4.2014
## Author: Sebastian Enger
## Check out: http://www.youtube-mp3.mobi/
## eMail: sebastian.enger@gmail.com
## Questions?, Want new Features? Mail me: sebastian.enger@gmail.com
## Licence: GPL 2 
# Usage Example		: perl logparser2.pl /var/log/lighttpd/access.log
# Usage Example 2	: perl logparser2.pl /var/log/lighttpd/access.log /var/log/apache2/access.log /var/log/nginx/access.log
## Speed: Parsing 4 Gbyte access.log on Xeon dual core with 3,4 Ghz in 2min
# 4/24/14: Added alexa.com bot detection
=======
## Version: 1.1.8 / 8.1.2014
## Licence: GPL 3 
# Usage Example		: perl logparser2.pl /var/log/lighttpd/access.log
# Usage Example 2	: perl logparser2.pl /var/log/lighttpd/access.log /var/log/apache2/access.log /var/log/nginx/access.log
## Speed: Parsing 4 Gbyte access.log on Xeon dual core with 3,4 Ghz in 2min
>>>>>>> a4316cca3679600787bb05100c491b00379d519b
####

use strict;
no strict "subs";
use Net::DNS;	# perl -MCPAN -e 'force install "Net::DNS"'

# init
my $Hash;
my %Hash = ();
my $UA;
my %UA = ();
my $rhash;
my %rhash = ();

my $goodbots = "./goodbots.txt";
my $iosec_whitelist = "whitelist"; # change this to the absolute path of your iosec whitelist file

# Offical User Agent strings for the corresponding web crawlers 
my $GoogleUserAgent = "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)";
my $BingUserAgent = "Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)";
my $YandexUserAgent = "Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)";
my $YahooUserAgent = "Mozilla/5.0 (compatible; Yahoo! Slurp; http://help.yahoo.com/help/us/ysearch/slurp)";
my $BaidoUserAgent = "Mozilla/5.0 (compatible; Baiduspider/2.0; +http://www.baidu.com/search/spider.html)";
<<<<<<< HEAD
# new: 4/24/14
my $AlexaUserAgent = 'ia_archiver (+http://www.alexa.com/site/help/webmasters; crawler@alexa.com)'; 
=======
>>>>>>> a4316cca3679600787bb05100c491b00379d519b

$UA{$GoogleUserAgent} = $GoogleUserAgent;
$UA{$BingUserAgent} = $BingUserAgent;
$UA{$YandexUserAgent} = $YandexUserAgent;
$UA{$YahooUserAgent} = $YahooUserAgent;
$UA{$BaidoUserAgent} = $BaidoUserAgent;
<<<<<<< HEAD
$UA{$AlexaUserAgent} = $AlexaUserAgent;
=======
>>>>>>> a4316cca3679600787bb05100c491b00379d519b

my $logfile = $#ARGV + 1 or die "No access.log Webserver logfile given\n";
my $count = 0;

foreach my $file1 (0 .. $#ARGV) {
	open(R,"<",$ARGV[$file1]);
	flock(R,LOCK_EX);
		while (my $entry = <R>){
		  my ($host,
			$login_name,
			$user_name,
			$date,
			$request_type,
			$request_path,
			$request_protocol, $status, $size, $referrer, $agent) = &parse_log($entry);
					
			if ($UA{$agent} && !$Hash{$host}){
					#print "Doing revers: $host\n";
					my $reverse = &reverseDNS($host);
					my $isValid = &matchBots($host, $reverse);
					
					if ($isValid==1){
						
						print "[$count] Offical Webcrawler IP Found: $host -> Its: ". $UA{$agent} . "\n";
						$Hash{$host} = $host;
						$count++;
						
						open(GOO,"+>>$goodbots");
						flock(GOO,LOCK_EX);
							  print GOO "$host\n";
						flock(GOO,LOCK_UN);
						close(GOO);

						open(GOO,"+>>$iosec_whitelist");
						flock(GOO,LOCK_EX);
							  print GOO "$host\n";
						flock(GOO,LOCK_UN);
						close(GOO);
					} # if ($isValid==1){
				}; # if ($UA{$agent} && !$Hash{$host}){
			}; # while (my $entry = <R>){
	flock(R,LOCK_UN);
	close R;	
}

print "I found $count offical bots\n";
exit;


sub matchBots(){
	
	my $host	= shift;
	my $reverse = shift;
	
	#my $MY;
	#my %MY = ();

	my $reverse_host = $host;
	$reverse_host =~ s/\./-/g;
				
	my $babot = "baiduspider-$reverse_host\.crawl\.baidu\.com";
	my $gbot = "crawl-$reverse_host\.googlebot\.com";
	my $yabot = "\.crawl\.yahoo\.com";
	my $yanbot = "spider-$reverse_host\.yandex\.com";
	my $bibot = "msnbot-$reverse_host\.search\.msn\.com";
<<<<<<< HEAD
	# new: 4/24/14
	my $alexbot = "$reverse_host\.compute-1\.amazonaws.com";
	
	if ($reverse =~ /$babot/ || $reverse =~ /$alexbot/ || $reverse =~ /$gbot/ || $reverse =~ /$yabot/ || $reverse =~ /$yanbot/ || $reverse =~ /$bibot/ ) {
=======
	
	if ($reverse =~ /$babot/ || $reverse =~ /$gbot/ || $reverse =~ /$yabot/ || $reverse =~ /$yanbot/ || $reverse =~ /$bibot/ ) {
>>>>>>> a4316cca3679600787bb05100c491b00379d519b
	#	print "(VALID): $host is offical bot\n";
		return 1;
	} else {
	#	print "(ERROR): $host is NOT offical bot\n";
		return 0;
	}
#	$MY{$babot} = $babot;
#	$MY{$gbot} = $gbot;
#	$MY{$yabot} = $yabot;
#	$MY{$yanbot} = $yanbot;
#	$MY{$bibot} = $bibot;
	
#	my ($first_matching_key) = grep { $_ =~ /$reverse/ } keys %MY;
#	print "First matching key is $first_matching_key\n";
#	print "Corresponding value is $MY{$first_matching_key}\n";
};
	
sub reverseDNS(){

	my $ip = shift;
	return if length($ip)<7;
	my $res = Net::DNS::Resolver->new;
	# create the reverse lookup DNS name (note that the octets in the IP address need to be reversed).

	my $target_IP = join('.', reverse split(/\./, $ip)).".in-addr.arpa";
	my $query = $res->query("$target_IP", "PTR");

	if ($query) {
	  foreach my $rr ($query->answer) {
		next unless $rr->type eq "PTR";
		#print $rr->rdatastr, "\n";
		return $rr->rdatastr;
	  }
	} else {
	  warn "query failed: ", $res->errorstring, "\n";
	}
}


sub parse_log {

	# Apache Web Log Graphical Stats
	# (c) 2002 Ramon Rodriguez rr_axis@hotmail.com
	#                          mi_cuenta@yahoo.com
	# License: GPL
	# this subroutine is taken from: https://sourceforge.net/projects/loganal/
	
  my ($s) = @_;
  chomp $s;
  $s =~ m/(\S+)\s(\S+)\s(\S+)\s\[(.*)\]\s\"(\S+)\s(\S+)\s(\S+)\"\s(\d+|-)\s(\d+|-)\s\"(\S+|-)\"\s\"(.*)\"/;
  if (!$1) {
    $s =~ m/(\S+)\s(\S+)\s(\S+)\s\[(.*)\]\s\"(\S+)\s(\S+)\s(\S+)\"\s(\d+|-)\s(\d+|-).*/;
    if (!$1) {
      return ();
    }
    return ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);
  }

  return ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);
}