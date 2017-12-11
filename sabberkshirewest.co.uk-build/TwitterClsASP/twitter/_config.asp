<%
	' CREDENTIALS
	Const OAUTH_EXAMPLE_CONSUMER_KEY		= "lQKXy4UzbqEqvwrZ87RAnQ" 							' <-- YOUR CONSUMER KEY		from	https://dev.twitter.com/apps/309402/show
	Const OAUTH_EXAMPLE_CONSUMER_SECRET		= "4IGTvpIKTc5cSzCxf2jY2BOVU1u08DWVU5AzXFrkJU" 		' <-- YOUR CONSUMER SECRET
   
	' OPTIONS  
	Const OAUTH_EXAMPLE_FORCE_LOGIN			= False ' True  

	' CALLBACK URL (MAKE SURE TO START @ 127.0.0.1 on localhost)
	' Const OAUTH_EXAMPLE_CALLBACK_URL		= "http://www.webteam.berkshire.nhs.uk/dev/oauth/twitter/callback.asp"
	Const OAUTH_EXAMPLE_CALLBACK_URL		= "http://www.webteam.berkshire.nhs.uk/demo/_core/oAuthTwitterNew/twitter/callback.asp"    ' Verified 13-Jun-2013
 
	' REDIRECT URLS
	Const OAUTH_EXAMPLE_ERROR_URL			= "error.asp"
	Const OAUTH_EXAMPLE_LOGIN_FAILURE_URL	= "log_in_failure.asp"
	Const OAUTH_EXAMPLE_LOGIN_SUCCESS_URL	= "log_in_success.asp"
	Const OAUTH_EXAMPLE_TIMEOUT_URL			= "timeout.asp" 
	
	' ************* http://dev.twitter.com/pages/oauth_single_token  ************ Help
	' http://twitter.com/oauth/authorize?oauth_token=qYzs3zVbthxcc0vjJaU6vwyXVTAnMaVE7yYpxkU4FU&force_login=true 
	' http://dev.twitter.com/auth#authorization  : http://dev.twitter.com/apps/309402 
%>