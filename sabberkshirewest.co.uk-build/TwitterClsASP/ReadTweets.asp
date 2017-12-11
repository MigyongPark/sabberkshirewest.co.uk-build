<%@ Language="VBScript" %>
<%
Session.CodePage    = 65001 
response.codepage   = 65001
Session.LCID        = 2057 
Response.CharSet	= "UTF-8"

' *-*-*-*-*-* Last updated by Thiagu.S on 26-Mar-2015 *-*-*-*-*-*-*-*-*-*

' Option Explicit

' Configure Twitter API authentication.
' TODO: Enter your own consumer key and consumer secret here so the code can log you in.
' Get your consumer key and consumer secret here: https://dev.twitter.com/apps
' NOTE: These are dummy values and will not work.

const TWITTER_API_CONSUMER_KEY 		= 	"gmZVXxNgAbev7B4APyyGsw7my"								' CLHCIC key
const TWITTER_API_CONSUMER_SECRET 	= 	"n9hDwTaiHIHic0YCnn3J0g7LPjRR7MeSZvvQvTNew2SmFG6gJG"
%>

<style type="text/css"> 

body {
	font-family: Arial, "Helvetica Neue", Helvetica, sans-serif;
	font-size: 16px;
	line-height: 1.62857143;
	margin: 0;
	padding: 0;
}

#twitter-feed {
                margin-bottom:2em;
	}

#twitter-feed h2 {
	background: #80d6ed url(../images/twitter-bird-40x40.png) no-repeat 10px 10px;
	color:#fff;
	font-size: 1.6em;
	font-weight: 500;
	line-height: 1.1;
	margin-bottom:0;
	padding: 20px 20px 20px 60px;
	
	-webkit-border-top-left-radius: 9px;
	-webkit-border-top-right-radius: 9px;
	-moz-border-radius-topleft: 9px;
	-moz-border-radius-topright: 9px;
	border-top-left-radius: 9px;
	border-top-right-radius: 9px;
}

#tweets {
	background: #00aedb;
	color:#fff;
	overflow: auto;
	padding: 1em 20px;
	
	-webkit-border-bottom-right-radius: 9px;
	-webkit-border-bottom-left-radius: 9px;
	-moz-border-radius-bottomright: 9px;
	-moz-border-radius-bottomleft: 9px;
	border-bottom-right-radius: 9px;
	border-bottom-left-radius: 9px;
}

#tweets p {
	margin: 0;
}

#tweets p.small {
	font-size: 85%;
	margin-bottom: 2em;
}

#tweets a {
	background: url(../images/twitter-bird-20x20.png) no-repeat;
	color: #fff;
	padding-left:32px;
}

#tweets a:hover,
#tweets a:focus
 {
	text-decorartion: none;
}


@media (min-width: 961px) { 
	
	.tweet {
		float: left;
		margin: 0 1%;
		width: 31.33333333333333%;
	}
}

</style>

<html>
<head>
</head>

<body>
<div id="twitter-feed">
<h2>Twitter Feed</h2>
<div id="tweets">

<%
' Twitter API client.
Dim objASPTwitter

' Tweets will be obtained by parsing data from Twitter API.
Dim objTweets
Dim sUsername : sUsername = "clhcic"  		' ***** Central London Healthcare 

Call Page_Load

%>


	</div>
</div>
</body>
</html>



<%

Sub Page_Load()

	'On Error Resume Next

	Set objASPTwitter = New ASPTwitter
	Call objASPTwitter.Configure(TWITTER_API_CONSUMER_KEY, TWITTER_API_CONSUMER_SECRET)
	Call objASPTwitter.Login

	Call LoadTweets
	Call WriteTweets
	
	Set objTweets 		= Nothing 
	Set objASPTwitter 	= Nothing	
End Sub

Sub LoadTweets()

	' Configure the API call.
	 
	Dim iCount : iCount = 3
	Dim bExcludeReplies : bExcludeReplies = False
	Dim bIncludeRTs : bIncludeRTs = True
	
	Set objTweets = objASPTwitter.GetUserTimeline(sUsername, iCount, bExcludeReplies, bIncludeRTs)
	
End Sub

Sub WriteTweets()

	If objTweets.length = 0 Then
		%>
			<ol id="Tweets"> <li>Tweets.asp: No tweets.</li> </ol>
		<%
	End If
	
	If Err Then
		%>
			<ol id="Tweets"> <li>Tweets.asp: invalid API response.</li> </ol>
		<%
	End if


	Dim oTweet,gDtTime , gId
	Dim ary 
	Dim gCounter
	gCounter = 0

	For Each oTweet In objTweets
		
		' Workarounds.
		' JSON parser bug workaround:
		'	- API can return invalid tweets, probably due to characters.
		' Twitter API bugs:
		'	- Filtering by the API can return additional invalid items, and seems to filter only after retrieving the requested number of items, so you get less than you asked for.
		'	- API sometimes seems to exclude replies even if that filter is not set, resulting in "*up to* count" responses and associated issues.
		If IsTweet(oTweet) Or IsRetweet(oTweet) Then
			
			' NOTE: A JSON viewer can be useful here: http://www.jsoneditoronline.org/
			Dim screen_name, text
			If Not IsRetweet(oTweet) Then
				screen_name = oTweet.user.screen_name
				text = Left(URLsBecomeLinks(oTweet.text),200) ' & "..."
				gId = URLsBecomeLinks(oTweet.id_str)
				gDtTime = URLsBecomeLinks(oTweet.created_at)
				
				ary=Split(gDtTime," ")
				
				gCounter = gCounter + 1
				
				Response.Write "<div class='tweet'>"
				Response.Write "<p>"& text  & "</p>"
				Response.Write "<p class='small'>Tweeted on "& ary(2) & " " & ary(1) & " " & ary(5) & "</p>"
				Response.Write "<p><a target='_blank' href='https://twitter.com/"& screen_name &"/status/"& gId &"'>Read / Retweet</a></p>"
				Response.Write "</div>"
			Else 
				' screen_name 	= oTweet.retweeted_status.user.screen_name
				' text 			= URLsBecomeLinks(oTweet.retweeted_status.text)
				' gId 			= "*-*"
				' gDtTime 		= "#-#"
			End If 
					
		End If

			IF gCounter = 12 Then
				Exit For 
			End IF		
			
	Next

	Set ary = Nothing

End Sub

Function IsTweet(ByRef oTweet)
	IsTweet = HasKey(oTweet, "user") 
End Function

Function IsRetweet(ByRef oTweet)
	IsRetweet = HasKey(oTweet, "retweeted_status") 
End Function

Function IsReply(ByRef oTweet)
	IsReply = Not oTweet.get("in_reply_to_user_id") = Null
End Function

Function HasKey(ByRef oTweet, ByVal sKeyName)
	HasKey = IsObject(oTweet.get(sKeyName))
End Function

Function URLsBecomeLinks(sText)
	' Wrap URLs in text with HTML link anchor tags.
	Dim objRegExp
	Set objRegExp = New RegExp
	objRegExp.Pattern = "(http://[^\s<]*)"
	objRegExp.Global = True
	objRegExp.ignorecase = True
	UrlsBecomeLinks = "" & objRegExp.Replace(sText, "<a href=""$1"" target=""_blank"">$1</a>")
	Set objRegExp = Nothing
End Function
 
%>
<!--#include virtual="/twitterclsasp/Libs/ASPTwitter/ASPTwitter.asp"-->