#!/usr/bin/perl
#
# a3purchase.plx

use CGI qw(:standard);
use DBI;

# set login information for database
my $serverName = "db-mysql";
my $serverPort = "xyz:xyz";
my $serverUser = "user";
my $serverPass = "pass";
my $serverDb = "dbname";

# define database related, passed-in, and other variables
my ($dbh, $desc, $cost, $html);
my $imag = param('selPicture');
my $user = param('txtUserName');

# connect to mysql database
my $dbh = DBI->connect("DBI:mysql:database=$serverDb;host=$serverName;port=$serverPort", $serverUser, $serverPass);

# pull description of item from database
my $desc = $dbh -> prepare( "SELECT DESCRIPTION FROM GALLERY WHERE FILENAME = '$imag.jpg'" );
$desc -> execute();
$desc = $desc -> fetchrow();

# pull cost of item from database
my $cost = $dbh -> prepare( "SELECT PRICE FROM GALLERY WHERE FILENAME = '$imag.jpg'" );
$cost -> execute();
$cost = $cost -> fetchrow();

$html = qq{Content-type: text/html\n\n
	
	<html>
		<head>
			<meta content="text/html;charset=utf-8" http-equiv="Content-Type">
			<meta content="utf-8" http-equiv="encoding">
			<title>Chad Medeiros - A3 - Gallery</title>
			<link rel="stylesheet" href="../../css/a3.css" />
			<script src="../../js/a3.js"></script>
		</head>
		<body>
			
			<form method="post" action="a3.plx" id="mainform">	
			
				<input type="hidden" name="txtUserName" id="user" size="10" readonly value="$user">
				<input type="hidden" name="lastImag" id="lastImag" size="10" readonly value="$imag">
				
				<h2><span id="title" title="INT 322 Assignment Three">Toronto in Motion</span></h2>
				<br />
				<div class="container">
					<img id="pic" src="../../images/$imag.jpg" alt="$imag">
				</div>
				<br /><br />
				<div class="imageTitle">
						$imag<br /><br />
						$desc<br /><br />
						
						<strong>$cost <em>CAD</em></strong><br /><br />
						
						<button type="submit" name="btnSubmit" value="Buy" onclick="alert('SOLD!')">Buy</button>
						<button type="submit" name="btnSubmit" value="Cancel" onclick="alert('Maybe next time.')">Cancel</button>				
				</div>
				
			</form>
			
		</body>
	</html>};
	
print $html;