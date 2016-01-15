#!/usr/bin/perl
#
#   a3.plx

use CGI qw(:standard);
use DBI;

# set login information for database
my $serverName = "db-mysql";
my $serverPort = "xyz:xyz";
my $serverUser = "user";
my $serverPass = "pass";
my $serverDb = "dbname";

# define database related, passed-in, and other variables
my ($dbh, $sth, $products, $temp, $insertUser, $insertPic, @row);
my $imag = param('selPicture');
my $user = param('txtUserName');
my $bought = param('btnSubmit');
my $lastImag = param('lastImag');

# connect to mysql database
my $dbh = DBI->connect("DBI:mysql:database=$serverDb;host=$serverName;port=$serverPort", $serverUser, $serverPass);

# if user arrived at website from specified page (below), then reset all database STATUS values to A (Available)
if ($ENV{'HTTP_REFERER'} eq "http://www.somewebsitegoeshere.com") 
{
	$dbh -> do( "UPDATE GALLERY SET STATUS='A'" );
}

# if Buy button was pressed in a3buy.plx, change the status of the item to S (Sold)
if ($bought eq 'Buy') {
	$dbh -> do( "UPDATE GALLERY SET STATUS='S' WHERE FILENAME='$lastImag.jpg'" );
}

# pull list of A (Available) products from database
my $sth = $dbh -> prepare( "SELECT FILENAME FROM GALLERY WHERE STATUS = 'A'" );
$sth -> execute();

# parse list into options for dropdown list.
while( my @row = $sth->fetchrow_array() ) {
	$temp = "@row";
	$temp = substr($temp, 0, -4);
	if ($temp ne $imag) {
		$products .= "<option>$temp</option>\n";
	} else {
		# set the default of dropdown box to whichever item is currently displayed
		$products .= "<option selected='selected'>$temp</option>\n";
	}
}

# show user name if logged in, or Login link if not logged in
if ($user) {
	$insertUser = qq{<input name="txtUserName" id="user" size="10" readonly value="$user">};
} else {
	$insertUser = qq{<a href="a3login.plx">Login</a>};
}

# if an item is currently selected to be shown, pull the description for that item from database
if ($imag) {
	my $desc = $dbh -> prepare( "SELECT DESCRIPTION FROM GALLERY WHERE FILENAME = '$imag.jpg'" );
	$desc -> execute();
	$desc = $desc -> fetchrow();
	$insertPic = qq{ <img id="pic" src="../../images/$imag.jpg" alt="$imag" };
	# if user is logged in, allow item to be double-clicked to open the item purchasing interface (a3buy.plx)
	if ($user) {
		$insertPic .= qq{ ondblclick="makeOffer()"};
	} 
	$insertPic .= qq{></div><br /><br /><div class="imageTitle">$desc</div> };
} else {
	$insertPic =  qq{ <img id="pic" src="../../images/Toronto_Main.jpg" alt="NO IMAGE" /></div> };
}

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
		<h2><span id="title" title="INT 322 Assignment Three">Toronto in Motion</span></h2>
		<div class="selection" id="box"><br/>
			<form method="post" action="a3.plx" id="mainform">
				<select name="selPicture" id="selPicture">
					<option></option>
					$products
				</select>
				<button type="submit" value="Submit">Submit</button>
			$insertUser	
			</form>
		</div>
		<br />
		<div class="container">
			$insertPic
		</div>
		</body>
	</html>};
	
print $html;