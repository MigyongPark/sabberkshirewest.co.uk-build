<%

' *-*-*-*-*-* Last updated by Thiagu.S on 24-Mar-2015 *-*-*-*-*-*-*-*-*-*

' ASPTwitter 1.1
' Release date: 1 June 2013
' Author: Tim Acheson
' Support Twitter: @timacheson
' License: source open, full details available from the author.
' Project URL: http://www.timacheson.com/Blog/2013/jun/asptwitter

' *** Please keep the comments above with the code below so I can help people with their code if they need it. ***

const API_BASE_URL = "https://api.twitter.com"

' Summary: Provides convenient methods for accessing the Twitter API within a legacy classic ASP web application.
Class ASPTwitter

	Private strConsumerKey
	Private strConsumerSecret
	
	Private strBearerToken

	Private Sub Class_Initialize()
	End Sub
	
	' Set your application's authentication credentials for the Twitter API.
	' NOTE: Get your consumer key and consumer secret here: https://dev.twitter.com/apps
	Public Sub Configure(ByVal sConsumerKey, ByVal sConsumerSecret)	
		strConsumerKey = sConsumerKey
		strConsumerSecret = sConsumerSecret
	End Sub

	Public Sub Login()
		Call SetBearerToken(GetBearerTokenJSON)
	End Sub
	
	Public Sub Logout()
		DeleteBearerTokenJSON
	End Sub

	' Gets user timeline as structured object, using AXE JSON Parser.
	Public Function GetUserTimeline(ByVal sUsername, ByVal iCount, ByVal bExcludeReplies, ByVal bIncludeRTs)
		Set GetUserTimeline = JSON.Parse(GetUserTimelineJSON(sUsername, iCount, bExcludeReplies, bIncludeRTs))
	End Function

	' Sets bearer token from JSON string returned by Twitter API authentication.
	Private Sub SetBearerToken(ByRef sBearerTokenJSON)
		
		On Error Resume Next
		
		Dim oVbsJson : Set oVbsJson = New VbsJson
		
		' Troubleshooting: an error here early on usually just means you haven't set values for ClientKey and ClientSecret yet.
		Dim oJSONToken : Set oJSONToken = oVbsJson.Decode(sBearerTokenJSON)

		'WScript.Echo oJSONToken("Image")("Thumbnail")("Url")
		'For Each i In oJSONToken("Image")("IDs")
			'WScript.Echo i
		'Next

		strBearerToken = oJSONToken("access_token")

		Set oJSONToken = Nothing
		Set oVbsJson = Nothing
		
		If Err Then
			%><h1>ASPTwitter error: Have you set values for ClientKey and ClientSecret yet?</h1><%
			Response.Flush
		End If

	End Sub

	' Gets bearer token for application-only authentication from Twitter API 1.1.
	' Application-only authentication: https://dev.twitter.com/docs/auth/application-only-auth
	' API endpoint oauth2/token: https://dev.twitter.com/docs/api/1.1/post/oauth2/token
	Private Function GetBearerTokenJSON

		Dim sURL : sURL = API_BASE_URL + "/oauth2/token"

		' Dim oXmlHttp: Set oXmlHttp = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")   				' Local barweb3 dev server 
		Dim oXmlHttp: set oXmlHttp	= Server.CreateObject("WinHTTP.WinHTTPRequest.5.1")			' Carelink
		oXmlHttp.SetProxy 2, "172.19.27.10:8080"    												' Carelink

		oXmlHttp.open "POST", sURL, False

		oXmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;charset=UTF-8"
		oXmlHttp.setRequestHeader "User-Agent", "http://www.eastcoastch.co.uk"
		oXmlHttp.setRequestHeader "Authorization", "Basic " & Base64_Encode(strConsumerKey & ":" & strConsumerSecret)				''''''''''''''''''''''''''''''''''''''''''& "=="

		'encodedPost="status=" & Server.URLEncode(postData)
		oXmlHttp.send "grant_type=client_credentials"

		'oXmlHttp.getAllResponseHeaders

		GetBearerTokenJSON = oXmlHttp.responseText

		Set oXmlHttp = Nothing

	End Function

	' API oauth2/token: https://dev.twitter.com/docs/api/1.1/post/oauth2/token
	Private Function DeleteBearerTokenJSON

		Dim sURL : sURL = API_BASE_URL + "/oauth2/invalidate_token"

		' Dim oXmlHttp: Set oXmlHttp = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")   				' Local barweb3 dev server 
		Dim oXmlHttp: set oXmlHttp	= Server.CreateObject("WinHTTP.WinHTTPRequest.5.1")			' Carelink
		oXmlHttp.SetProxy 2, "172.19.27.10:8080"    												' Carelink 

		oXmlHttp.open "POST", sURL, False

		oXmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;charset=UTF-8"
		oXmlHttp.setRequestHeader "User-Agent", "http://www.eastcoastch.co.uk"
		oXmlHttp.setRequestHeader "Authorization", "Basic " & Base64_Encode(strConsumerKey & ":" & strConsumerSecret)

		oXmlHttp.send "access_token=" & strBearerToken

		DeleteBearerTokenJSON = oXmlHttp.responseText

		Set oXmlHttp = Nothing

	End Function

	' API user_timeline: https://dev.twitter.com/docs/api/1.1/get/statuses/user_timeline
	Private Function GetUserTimelineJSON(ByVal sUsername, ByVal iCount, ByVal bExcludeReplies, ByVal bIncludeRTs)
		
		Dim sURL : sURL = API_BASE_URL + "/1.1/statuses/user_timeline.json" & "?screen_name=" & sUsername & "&count=" & iCount & "&exclude_replies=" & LCase(bExcludeReplies) & "&include_rts=" & LCase(bIncludeRTs)

		' Dim oXmlHttp: Set oXmlHttp = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")   		' Local barweb3 dev server 
		Dim oXmlHttp: set oXmlHttp	= Server.CreateObject("WinHTTP.WinHTTPRequest.5.1")			' Carelink
		oXmlHttp.SetProxy 2, "172.19.27.10:8080"    											' Carelink 

		oXmlHttp.open "GET", sURL, False
		oXmlHttp.setRequestHeader "User-Agent", "http://www.eastcoastch.co.uk"
		oXmlHttp.setRequestHeader "Authorization", "Bearer " & strBearerToken

		oXmlHttp.send

		GetUserTimelineJSON = oXmlHttp.responseText

		Set oXmlHttp = Nothing
		
		REM: A JSON viewer can be useful here: http://www.jsoneditoronline.org/
		'Response.Write "<textarea cols=""100"" rows=""50"" >" & GetUserTimelineJSON & "</textarea>"

	End Function
	
	Private Sub Class_Terminate()	
	End Sub

End Class

%>
<!--#include virtual="/twitterclsasp/Libs/VBScriptOAuth/oauth/_inc/hex_sha1_base64.asp"-->
<!--#include virtual="/twitterclsasp/Libs/VbsJson/VbsJson.asp"-->
<!--#include virtual="/twitterclsasp/Libs/AXEJSONParser/AXEJSONParser.asp"-->