<!--#include Virtual="_core/oAuthTwitterNew/oauth/cLibOAuth.asp"-->
<!--#include file="_config.asp"-->
<%
 
' 	***		http://classicaspreference.com/aspexamples/classic_asp_for_twitter_desapio.asp		***


	Session("oauth_token") 				= "94535419-qpbFUMzzMquLvo8kMi3I2udrPwRk0tE9HYRY0Y5Ck"
	Session("oauth_token_secret") 		= "uc7UjPx9jj6QbZySrHjEZBoSeYKePEPOJDjEB3gqkiM"
	Session("screen_name") 				= "testnhswebteam"  
	strScreenName  						= "testnhswebteam" 

   strTweetText = Trim(Request.form("txtTweet"))   
   strName = Trim(Request.form("txtName")) 
      
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' instantiate oAuth object ref
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Dim objOAuth : Set objOAuth = New cLibOAuth 

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' check if logged in 
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' 
If objOAuth.LoggedIn And strTweetText <> "" And strName = "iPhoneV401" Then   
   
	Dim strStatus : strStatus = strTweetText & " : eastcoast-local : ... Time : " & now()   

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	' setup oAuth object   
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	objOAuth.ConsumerKey 		= "lQKXy4UzbqEqvwrZ87RAnQ" 
	objOAuth.ConsumerSecret 	= "4IGTvpIKTc5cSzCxf2jY2BOVU1u08DWVU5AzXFrkJU" 
	objOAuth.EndPoint 			= TWITTER_OAUTH_URL_UPDATE_STATUS 
	
	objOAuth.Parameters.Add "oauth_token", Session("oauth_token")
	objOAuth.Parameters.Add "oauth_token_secret", Session("oauth_token_secret") 
	
	objOAuth.Parameters.Add "status", strStatus
	objOAuth.RequestMethod = OAUTH_REQUEST_METHOD_POST
	objOAuth.Send() 
 
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	' check the response
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	Dim strResponseText : strResponseText = objOAuth.ResponseText

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	' error code 
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	Dim strErrorCode : strErrorCode = objOAuth.ErrorCode

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	' check for errors 
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	If Not IsNull(strErrorCode) Then
		Response.Status = RESPONSE_STATUS_500
		 
		Response.Write "<br><br>Error Code : " & strErrorCode
		Response.Write "<br><br>RESPONSE_STATUS_500 : " & Response.Status 
	Else
		Response.ContentType = "text/html"
		Response.CharSet = "utf-8"
		Response.Write strResponseText 
 
		Response.Write "<br><br>Error Code : " & strErrorCode
		Response.Write "<br><br>Response.Status : " & Response.Status
		 
		Response.Write "<br><br><a target='_blank' href='http://twitter.com/testnhswebteam'>Public site</a>&nbsp;&nbsp;&nbsp;"
		Response.Write "&nbsp;&nbsp;&nbsp;<a target='_blank' href='http://mobile.twitter.com/testnhswebteam'>Mobile site</a>&nbsp;&nbsp;&nbsp;"
			
	End If 
 
Else 
 
	' Response.Status = RESPONSE_STATUS_403 
	
	Response.Write "<br><br>Error Code : " & strErrorCode 
	Response.Write "<br><br>RESPONSE_STATUS_403 : " & Response.Status
		  
	Response.Write "<br><br>Please login with your twitter acct or enter your correct secret code...<br>" 
		 		
End IF  
 
	Response.Write "<br><br><a href='http://www.webteam.berkshire.nhs.uk/dev/oauth/twitter/default.asp'>Go Home</a>"
   
	Session("oauth_token") 				= ""
	Session("oauth_token_secret") 		= ""
	Session("screen_name") 				= ""  
	Session.Contents.RemoveAll()
  
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' kill object refs.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Set objOAuth = Nothing

%>
