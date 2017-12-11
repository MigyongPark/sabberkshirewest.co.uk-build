<!--#include Virtual="_core/oAuthTwitterNew/oauth/cLibOAuth.asp"--> 
<!--#include file="_config.asp"-->
<%
 
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' 1. catch the passed in qs param from twitter
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Dim strOAuthVerifier : strOAuthVerifier = Request.QueryString(OAUTH_VERIFIER)

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' 2. Instantiate an instance of the OAuth object.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Dim objOAuth : Set objOAuth = New cLibOAuth
	objOAuth.ConsumerKey = OAUTH_EXAMPLE_CONSUMER_KEY
	objOAuth.ConsumerSecret = OAUTH_EXAMPLE_CONSUMER_SECRET
	objOAuth.EndPoint = TWITTER_OAUTH_URL_ACCESS
	objOAuth.RequestMethod = OAUTH_REQUEST_METHOD_GET
	objOAuth.TimeoutURL = OAUTH_EXAMPLE_TIMEOUT_URL

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' 3. Add proprietary request parameters.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	objOAuth.Parameters.Add "oauth_token", Session(OAUTH_TOKEN_REQUEST)
	objOAuth.Parameters.Add "oauth_verifier", strOAuthVerifier

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' 4. Make the call.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	objOAuth.Send()

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' 5. check for error
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Dim strRedirectURL : If Not IsNull(objOAuth.ErrorCode) Then
	' set redirect to failure handler (do specific error handling here)
	strRedirectURL = OAUTH_EXAMPLE_LOGIN_FAILURE_URL
Else
	' save session variables
	Session(OAUTH_TOKEN) = objOAuth.Get_ResponseValue(OAUTH_TOKEN)
	Session(OAUTH_TOKEN_SECRET) = objOAuth.Get_ResponseValue(OAUTH_TOKEN_SECRET)
	Session(TWITTER_SCREEN_NAME) = objOAuth.Get_ResponseValue(TWITTER_SCREEN_NAME)
	
	' set redirect to success handler
	strRedirectURL = OAUTH_EXAMPLE_LOGIN_SUCCESS_URL & "?" & Session(TWITTER_SCREEN_NAME)
End If

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' kill obj ref
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Set objOAuth = Nothing

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' redirect user
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 
' Response.write "<br>1. " & Session(OAUTH_TOKEN) 
' Response.write "<br>2. " & Session(OAUTH_TOKEN_SECRET) 
' Response.write "<br>3. " & Session(TWITTER_SCREEN_NAME) 
' Response.write "<br>4. " & strRedirectURL   
   
Response.Redirect strRedirectURL

%>
