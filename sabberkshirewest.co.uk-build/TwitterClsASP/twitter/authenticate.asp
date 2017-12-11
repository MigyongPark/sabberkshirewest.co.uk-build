<!--#include Virtual="_core/oAuthTwitterNew/oauth/cLibOAuth.asp"-->
<!--#include file="_config.asp"-->
<%
  
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Make sure all session variables are non existent. This is NOT recommended for 
' your personal project. This is ONLY meant for this example project.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Dim Item : For Each Item In Session.Contents
	Session(Item) = ""
	Session.Contents.Remove(Item)
Next 
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' 1. Instantiate an instance of the OAuth object.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Dim objOAuth : Set objOAuth = New cLibOAuth
	objOAuth.ConsumerKey = OAUTH_EXAMPLE_CONSUMER_KEY
	objOAuth.ConsumerSecret = OAUTH_EXAMPLE_CONSUMER_SECRET
	objOAuth.EndPoint = TWITTER_OAUTH_URL_REQUEST_TOKEN
	objOAuth.RequestMethod = OAUTH_REQUEST_METHOD_GET
	objOAuth.TimeoutURL = OAUTH_EXAMPLE_TIMEOUT_URL

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' 2. Add proprietary request parameters.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	objOAuth.Parameters.Add "oauth_callback", OAUTH_EXAMPLE_CALLBACK_URL

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' 3. Make the call.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	objOAuth.Send()

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' 4. Evaluate the response.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Dim strRequestToken : strRequestToken = objOAuth.Get_ResponseValue(OAUTH_TOKEN)

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' set the redirect url
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Dim strRedirectURL : If Not IsNull(objOAuth.ErrorCode) Then
	' set redirect to generic error (do specific error handling here)
	strRedirectURL = OAUTH_EXAMPLE_ERROR_URL
Else
	' store the request token
	Session(OAUTH_TOKEN_REQUEST) = strRequestToken
	
	' set redirect to authenticate
	strRedirectURL = TWITTER_OAUTH_URL_AUTHENTICATE & _
		"?oauth_token=" & strRequestToken & "&force_login=" & LCase(CStr(OAUTH_EXAMPLE_FORCE_LOGIN))
End If

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' kill obj refs. We're done with them.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Set objOAuth = Nothing

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' redirect user
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Response.Redirect strRedirectURL

%>
