<!--#include Virtual="/dev/oauth/oauth/cLibOAuth.asp"-->
<!--#include file="_config.asp"-->
<%
 
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' instantiate oAuth object ref
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Dim objOAuth : Set objOAuth = New cLibOAuth 

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' check if logged in
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
If objOAuth.LoggedIn Then   

	'Dim strStatus : strStatus = Request.Form("post")   
   
	Dim strStatus : strStatus = "^^^^^ PC: Live webteam site (office v 1.2) - : " & now() 
 
	'Dim intReplyId : intReplyId = Request.Form("replyId")
	'Dim strReplyTo : strReplyTo = Request.Form("replyTo")

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	' setup oAuth object   
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	objOAuth.ConsumerKey 		= "6fqJGWaIhpx8G7EhgEbBw" 
	objOAuth.ConsumerSecret 	= "tMi6FQqXySRWPJtFRfH8YyqquuPk2qECsXBQGtCxrbE"
	objOAuth.EndPoint 			= TWITTER_OAUTH_URL_UPDATE_STATUS 
	objOAuth.Parameters.Add "in_reply_to", strReplyTo
	objOAuth.Parameters.Add "in_reply_to_status_id", intReplyID
	objOAuth.Parameters.Add "oauth_token", Session(OAUTH_TOKEN)
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
		Response.Write strErrorCode
	Else
		Response.ContentType = "text/html"
		Response.CharSet = "utf-8"
		Response.Write strResponseText
	End If

Else
	Response.Status = RESPONSE_STATUS_403
End If

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' kill object refs.
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Set objOAuth = Nothing

%>
