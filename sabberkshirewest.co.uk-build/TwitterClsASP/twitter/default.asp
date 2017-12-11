<!--#include Virtual="_core/oAuthTwitterNew/oauth/_inc/_base.asp"-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<title>Direct twitter post - OAuth Authentication</title>
	</head> 
	<body> 
	
	<br>  
				<h4>Direct twitter post - OAuth </h4>
   
				<form name="frmMain" method="post" action="webteam_update.asp"> 
					<br> 
					Enter your secret code &nbsp;:&nbsp;&nbsp;&nbsp; <input type="text" name="txtName" value="">
					<br>  <br><br> 
					Tweet message  &nbsp;:&nbsp;&nbsp;&nbsp; <textarea id="txtTweet" name="txtTweet">SA : </textarea>
					<br>  <br><br> 
					<input type="submit" value="Direct Post" id="btnTtweet" NAME="btnTtweet"> <br>
					<br>  
				</form>  
 <% 
		 Response.write "<br>1. " & Session(OAUTH_TOKEN)  
		 Response.write "<br>2. " & Session(OAUTH_TOKEN_SECRET) 
		 Response.write "<br>3. " & Session(TWITTER_SCREEN_NAME) 
 
		 Response.write "<br>4. " & OAUTH_TOKEN  
		 Response.write "<br>5. " & OAUTH_TOKEN_SECRET 
		 Response.write "<br>6. " & TWITTER_SCREEN_NAME  
		%> 

	</body> 
</html>
