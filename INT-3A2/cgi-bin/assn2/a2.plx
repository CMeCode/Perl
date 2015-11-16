#!/usr/bin/perl

use CGI qw(:standard);
my $cgi=new CGI;

my $imag = $cgi->param('selPicture');
my $user = $cgi->param('txtUserName');

if ($user) {
	$insertA = qq{<input name="txtUserName" id="user" size="10" readonly value="$user">};
} else {
	$insertA = qq{<a href="a2login.plx">Login</a>};
}

if ($imag) {
	$insertB = qq{ <img id="pic" src="../../images/$imag.jpg" alt="$imag" /></div>
		<br /><br /><div class="imageTitle">$imag</div> };
} else {
	$insertB =  qq{ <img id="pic" src="../../images/Toronto_Main.jpg" alt="NO IMAGE" /></div> };
}

$html = qq{Content-type: text/html\n\n
	
	<html>
		<head>
			<meta charset="UTF-8" />
			<title>Chad Medeiros - A2 - Gallery</title>
			<link rel="stylesheet" href="../../css/a2.css" />
		</head>
		<body>
		<h2><span id="title" title="INT 322 Assignment Two">Toronto in Motion</span></h2>
		<div class="selection" id="box"><br/>
			<form method="post" action="a2.plx">
				<select name="selPicture">
					<option></option>
					<option>Toronto_Flying</option>
					<option>Toronto_Union</option>
					<option>Toronto_ChurchFront</option>
					<option>Toronto_NathanPhillipsSquare</option>
					<option>Toronto_RoyalOntarioMuseum</option>
					<option>Toronto_GardinerExpressway</option>
					<option>Toronto_CNTower</option>
				</select>
				<button type="submit" value="Submit">Submit</button>
			$insertA	
			</form>
		</div>
		<br />
		<div class="container">
			$insertB
		</div>
		</body>
	</html>};
	
print $html;