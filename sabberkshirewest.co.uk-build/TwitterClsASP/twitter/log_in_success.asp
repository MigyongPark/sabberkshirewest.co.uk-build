<%
	Dim strScreenName : strScreenName = Request.QueryString
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
	<head>
		<title>Thanks for logging in!</title>
		<link href="http://yui.yahooapis.com/3.1.0/build/cssreset/reset-min.css" rel="stylesheet" type="text/css">
		<link href="../css/base.css" rel="stylesheet" type="text/css">
		<script>
			var bOpenerAvailable = false;
			var oParent = window.parent;
			var oReferrer = window.opener;

			if (oReferrer){
				try{
					bOpenerAvailable = (oReferrer.location.host == window.location.host);
				}
				catch(e){
				}
			}

			if (!bOpenerAvailable){
				if (oParent){
					bOpenerAvailable = true;
					oReferrer = oParent;
				}
			}
			
			oReferrer.OAUTH_VBSCRIPT.loggedIn = true;
			oReferrer.OAUTH_VBSCRIPT.screenName = '<%=strScreenName%>';
			oReferrer.YUI.oauth_vbscript.checkLoggedIn();

			window.close();
		</script>
	</head>
	<body>
		You are now logged in.
		<p>
		<a href="javascript:window.close();">Click here to close this window.</a>
	</body>
</html>
