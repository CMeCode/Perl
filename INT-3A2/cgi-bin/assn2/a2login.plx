#!/usr/bin/perl

use CGI;
my $cgi=new CGI;

my $user = $cgi->param('txtUserName');
my $pass = $cgi->param('txtUserPass');
my $error = ""; 

if ($user) {
	if ($user eq "admin") {
		if ($pass eq "admin") {
			print $cgi->redirect("http://zenit.senecac.on.ca/~int322_153sa07/cgi-bin/assn2/a2.plx?txtUserName=$user")
		} 
		elsif ($pass ne "")	{
			$error = "Login error. Please log in again. (Incorrect password.)";
		} 
		else {
			$error = "Login error. Please log in again. (Please enter a password.)";
		}
	} 
	elsif ($user ne "")	{
		$error = "Login error. Please log in again. (Username not found.)";
	} 
}

$html = qq{Content-type: text/html\n\n
	
	<html>
	<head>
		<meta charset="UTF-8" />
		<title>Chad Medeiros - A2 - Login</title>
		<link rel="stylesheet" href="../../css/a2.css" />
	</head>
	<body>
		<h2><span id="title" title="INT 322 Assignment Two - Login">Login</span></h2>
		<div id="box">
			<form method="post" action="a2login.plx"><br/>
			<table class="center">
				<tr>
					<td>User Name:</td>
					<td><input type="text" name="txtUserName" /><br /></td>
				</tr>
				<tr>
					<td>Password:</td>
					<td><input type="password" name="txtUserPass" /><br /></td>
				</tr>
			</table><br />
			<button type="submit" value="Submit">Submit</button><br /><br />
			</form>
			<br/>
			$error
			<br/><br/>
		</div>
	</body>
	</html>};
	
print $html;