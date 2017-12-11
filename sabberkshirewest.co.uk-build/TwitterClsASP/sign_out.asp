<!--#include file="oauth/_inc/_base.asp"-->
<%
	Session(TWITTER_SCREEN_NAME) = ""
	Session.Contents.Remove(TWITTER_SCREEN_NAME)
	Session.Contents.RemoveAll()
	Session.Abandon()

	Response.ContentType = "text/html"
	Response.CharSet = "utf-8"
	Response.Status = RESPONSE_STATUS_200
	Response.End
%>
