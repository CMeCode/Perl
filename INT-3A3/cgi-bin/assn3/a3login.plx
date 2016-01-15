#!/usr/bin/perl
#
# a3login.plx

use CGI qw(:standard);

# define passed-in and other variables
my $user = param('txtUserName');
my $pass = param('txtUserPass');
my $error = ""; 
my ($userVerified, $passVerified, $line, $username, $password, $html);

# Access USER.txt file for list of valid username/passwords combos
if ($user) {
	open (USER, "USER.txt") or die("Cannot open USER.txt file");
	while ( $line = <USER> )
	{
		# pull one line at a time
		chomp ($line);
		
		# separate the line by specifying that columns are delimited by a tab
		( $username, $password ) = split( "\t", $line );
		   
		# if entered username is found in the list (ignoring column title of 'USERNAME')
		if (($user eq $username) && ($user ne 'USERNAME'))
		{
			# flag user has been verified
			$userVerified = 1;
			
			# if entered password matches with password corresponding to user name
			if ( $pass eq $password )
			{
				# flag pass has been verified
				$passVerified = 1;
			}
		} 
	}
	close(USER);

	# perform simple logic to test if username and pass are valid:
	if ($userVerified == 1) {
		if ($passVerified == 1) {
			# if name/pass combo are valid, redirect logged-in user to main page (this may need to be absolute rather than relative -- edited for github)
			print redirect("a3.plx?txtUserName=$user");
		}  	
		# otherwise, return an appropriate error:
		elsif ($pass eq "") {
			$error = "Login error. Please log in again. (Please enter a password.)";
		}	
		else {
			$error = "Login error. Please log in again. (Incorrect password.)";
		} 
	} 
	else {
		$error = "Login error. Please log in again. (Username not found.)";
	} 
}

$html = qq{Content-type: text/html\n\n
	
	<html>
	<head>
		<meta content="text/html;charset=utf-8" http-equiv="Content-Type">
		<meta content="utf-8" http-equiv="encoding">
		<title>Chad Medeiros - A3 - Login</title>
		<link rel="stylesheet" href="../../css/a3.css" />
	</head>
	<body>
		<h2><span id="title" title="INT 322 Assignment Three - Login">Login</span></h2>
		<div id="box">
			<form method="post" action="a3login.plx"><br/>
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
			<br/>
			$printme<br/>
		</div>
	</body>
	</html>};
	
print $html;