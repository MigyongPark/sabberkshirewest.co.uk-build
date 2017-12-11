// establish namespace
YUI.namespace('oauth_vbscript');

// YUI initialize wrapper
YUI().use('node', 'io', function(Y){

	// The "post" button used in posting a tweet. This
	// referenced is used in swapping the loading gif
	// in and out
	var _elPostButton = Y.one('#tweet_tools_button');

	// The container element that will encapsulate 
	// the logged in user's screen name
	var _elScreenName = Y.one('#screen_name');

	// The container encapsulating the "sign in" 
	// elements
	var _elSignIn = Y.one('#sign_in_container');

	// The container encapsulating the "sign out" 
	// elements
	var _elSignOut = Y.one('#sign_out_container');

	// The actual textarea form element used for the 
	// tweet post input. The value of the element IS 
	// the tweet.
	var _elTweetTextarea = Y.one('#tweet_textarea');

	/** 
	* @description The tweet's post object. Handles 
	* calling web svc to post user's tweet.
	* @object oPost
	* @private
	*/
	var oPost = function(){
		
		var bPosting = false;
		var oCfg = null;
		var sPost = null;
		var sURI = 'twitter/update_status';

		function handleComplete(){
			bPosting = false;
			_elPostButton.set('disabled', false);
			_elTweetTextarea.set('disabled', false);
		};
		
		function handleStart(){
			_elPostButton.set('disabled', true);
			_elTweetTextarea.set('disabled', true);
		}
		
		function handleFailure(id, o){
			alert('Oops! As error has occurred.\n\nPlease refresh the page and try again.');
		};

		function handleSuccess(id, o){
			_elTweetTextarea.set('value', '');
			alert('tweet successful!')
		};

		function isValid(){
			return (sPost && (sPost.length <= 140));
		};

		function process(){

			sPost = _elTweetTextarea.get('value');

			if (isValid()){
				send();
			}
			else{
				bPosting = false;
				alert('Oops! Invalid post! Too many Characters!');
			}

		};

		function send(){
			oCfg = {
				method: 'POST',
				data: 'post=' + encodeURIComponent(sPost)
			};

			Y.io(sURI, oCfg);
		};

		// configure the io object
		Y.on('io:failure', handleFailure, Y);
		Y.on('io:success', handleSuccess, Y);
		Y.on('io:complete', handleComplete, Y);
		Y.on('io:start', handleStart, Y);

		return {
		
			send: function(){
				if (bPosting){
					return;
				}
				else{
					bPosting = true;
					process();
				}
			}
		
		}
		
	}();
 
	// publicly accessible checkLoggedIn functoin
	YUI.oauth_vbscript.checkLoggedIn = function(){
		if(OAUTH_VBSCRIPT.loggedIn){
		  alert(OAUTH_VBSCRIPT.screenName); 
			_elSignIn.setStyle('display', 'none');
			_elSignOut.setStyle('display', 'block');
			_elScreenName.set('innerHTML', OAUTH_VBSCRIPT.screenName);
		}
		else{
			_elSignIn.setStyle('display', 'block');
			_elSignOut.setStyle('display', 'none');
			_elScreenName.set('innerHTML', '');
		}
	};

	// click handler for post
	Y.on('click', function(e){
		e.preventDefault();
		oPost.send()
	}, _elPostButton)

	// click handler for "Sign out"
	Y.on('click', function(e){
		e.preventDefault();

		Y.Get.script('sign_out.asp', {
			onSuccess: function(o){
				// purge the script element
				o.purge();

				// kill local object member vars
				OAUTH_VBSCRIPT.loggedIn = false;
				OAUTH_VBSCRIPT.screenName = null;

				// update UI
				YUI.oauth_vbscript.checkLoggedIn();
			},
			onFailure: function(o){
				alert('Oops! Try again.');
			}
		})
	}, '#sign_out')
		
	// click handler for "Sign in with Twitter"
	Y.on('click', function(e){
		e.preventDefault();

		window.open(
			'twitter/authenticate.asp',
			'signIn',
			'width=800,height=420,left=' + ((screen.width/2) - 420) + ',top=' + ((screen.height/2) - 210) + ',location=0,toolbar=0,menubar=0,scrollbars=0,resizable=1'
		);

	}, '#sign_in');

	// make sure we're at a resolvable address
	Y.on('domready', function(){
		YUI.oauth_vbscript.checkLoggedIn();
	});

});
