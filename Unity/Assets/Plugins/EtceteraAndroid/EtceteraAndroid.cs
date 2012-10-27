using UnityEngine;
using System.Collections;
using System.Collections.Generic;


#if UNITY_ANDROID
public enum TTSQueueMode
{
	Flush = 0,
	Add = 1
}


public class EtceteraAndroid
{
	private static AndroidJavaObject _plugin;
	
	public enum ScalingMode
	{
		None,
		AspectFit,
		Fill
	}
	
		
	static EtceteraAndroid()
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		// find the plugin instance
		using( var pluginClass = new AndroidJavaClass( "com.prime31.EtceteraPlugin" ) )
			_plugin = pluginClass.CallStatic<AndroidJavaObject>( "instance" );
	}
	

	// Plays a video either locally (must be in the StreamingAssets folder or accessible via full path) or remotely.  The video format must be compatible with the current
	// device.  Many devices have different supported video formats so choose the most common (probably 3gp).
	public static void playMovie( string pathOrUrl, uint bgColor, bool showControls, ScalingMode scalingMode, bool closeOnTouch )
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "playMovie", pathOrUrl, (int)bgColor, showControls, (int)scalingMode, closeOnTouch );
	}


	// Shows a Toast notification.  You can choose either short or long duration
	public static void showToast( string text, bool useShortDuration )
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "showToast", text, useShortDuration );
	}


	// Shows a native alert with a single button
	public static void showAlert( string title, string message, string positiveButton )
	{
		showAlert( title, message, positiveButton, string.Empty );
	}


	// Shows a native alert with two buttons
	public static void showAlert( string title, string message, string positiveButton, string negativeButton )
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "showAlert", title, message, positiveButton, negativeButton );
	}


	// Shows an alert with a text prompt embedded in it
	public static void showAlertPrompt( string title, string message, string promptHint, string promptText, string positiveButton, string negativeButton )
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "showAlertPrompt", title, message, promptHint, promptText, positiveButton, negativeButton );
	}

	
	// Shows an alert with two text prompts embedded in it
	public static void showAlertPromptWithTwoFields( string title, string message, string promptHintOne, string promptTextOne, string promptHintTwo, string promptTextTwo, string positiveButton, string negativeButton )
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "showAlertPromptWithTwoFields", title, message, promptHintOne, promptTextOne, promptHintTwo, promptTextTwo, positiveButton, negativeButton );
	}


	// Shows a native progress indicator.  It will not be dismissed until you call hideProgressDialog
	public static void showProgressDialog( string title, string message )
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "showProgressDialog", title, message );
	}


	// Hides the progress dialog
	public static void hideProgressDialog()
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "hideProgressDialog" );
	}


	// Shows a web view with the given url
	public static void showWebView( string url )
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "showWebView", url );
	}
	
	
	// Shows a web view without a title bar optionally disabling the back button. If you disable the back button the only way
	// a user can close the web view is if the web page they are on has a link with the protocol close://  It is highly recommended
	// to not disable the back button! Users are accustomed to it working as it is a default Android feature.
	public static void showCustomWebView( string url, bool disableTitle, bool disableBackButton )
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "showCustomWebView", url, disableTitle, disableBackButton );
	}


	// Lets the user choose an email program (or uses the default one) to send an email prefilled with the arguments
	public static void showEmailComposer( string toAddress, string subject, string text, bool isHTML )
	{
		showEmailComposer( toAddress, subject, text, isHTML, string.Empty );
	}
	
	public static void showEmailComposer( string toAddress, string subject, string text, bool isHTML, string attachmentFilePath )
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "showEmailComposer", toAddress, subject, text, isHTML, attachmentFilePath );
	}


	// Shows the SMS composer with the text string
	public static void showSMSComposer( string text )
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "showSMSComposer", text );
	}


	// Prompts the user to take a photo then resizes it to the dimensions passed in. Passing in 0 dimensions will get you a full sized image.
	public static void promptToTakePhoto( int desiredWidth, int desiredHeight, string name )
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "promptToTakePhoto", desiredWidth, desiredHeight, name );
	}


	// Prompts the user to choose an image from the photo album and resizes it to the dimensions passed in. Passing in 0 dimensions will get you a full sized image.
	public static void promptForPictureFromAlbum( int desiredWidth, int desiredHeight, string name )
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "promptForPictureFromAlbum", desiredWidth, desiredHeight, name );
	}

	
	// Prompts the user to take a video and records it saving with the given name (no file extension is needed for the name)
	public static void promptToTakeVideo( string name )
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "promptToTakeVideo", name );
	}
	
	
	// Saves an image to the photo gallery
	public static bool saveImageToGallery( string pathToPhoto, string title )
	{
		if( Application.platform != RuntimePlatform.Android )
			return false;
		
		return _plugin.Call<bool>( "saveImageToGallery", pathToPhoto, title );
	}
	
	
	// Scales the image
	public static void scaleImageAtPath( string pathToImage, float scale )
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "scaleImageAtPath", pathToImage, scale );
	}

	
	#region TTS

	// Starts up the TTS system
	public static void initTTS()
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "initTTS" );
	}
	
	
	// Tears down and destroys the TTS system
	public static void teardownTTS()
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "teardownTTS" );
	}
	
	
	// Speaks the text passed in
	public static void speak( string text )
	{
		speak( text, TTSQueueMode.Add );
	}
	
	
	// Speaks the text passed in optionally queuing it or flushing the current queue
	public static void speak( string text, TTSQueueMode queueMode )
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "speak", text, (int)queueMode );
	}
	
	
	// Stops the TTS system from speaking the current text
	public static void stop()
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "stop" );
	}
	
	
	// Plays silence for the specified duration in milliseconds
	public static void playSilence( long durationInMs, TTSQueueMode queueMode )
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "playSilence", durationInMs, (int)queueMode );
	}
	
	
	// Speech pitch. 1.0 is the normal pitch, lower values lower the tone of the synthesized voice, greater values increase it.
	public static void setPitch( float pitch )
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "setPitch", pitch );
	}
	
	
	// Speech rate. 1.0 is the normal speech rate, lower values slow down the speech (0.5 is half the
	// normal speech rate), greater values accelerate it (2.0 is twice the normal speech rate).
	public static void setSpeechRate( float rate )
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "setSpeechRate", rate );
	}

#endregion
	
	
	#region Ask For Review
	
	// Shows the ask for review prompt with constraints. launchesUntilPrompt will not allow the prompt to be shown until it is launched that many times.
	// hoursUntilFirstPrompt is the time since the first launch that needs to expire before the prompt is shown
	// hoursBetweenPrompts is the time that needs to expire since the last time the prompt was shown
	// NOTE: once a user reviews your app the prompt will never show again until you call resetAskForReview
	public static void askForReview( int launchesUntilPrompt, int hoursUntilFirstPrompt, int hoursBetweenPrompts, string title, string message, string appPackageName, bool isAmazonAppStore = false )
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		if( isAmazonAppStore )
			_plugin.Set<bool>( "isAmazonAppStore", true );
		
		_plugin.Call( "askForReview", launchesUntilPrompt, hoursUntilFirstPrompt, hoursBetweenPrompts, title, message, appPackageName );
	}

	
	// Shows the ask for review prompt immediately unless the user pressed the dont ask again button
	public static void askForReviewNow( string title, string message, string appPackageName, bool isAmazonAppStore = false )
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		if( isAmazonAppStore )
			_plugin.Set<bool>( "isAmazonAppStore", true );
		
		_plugin.Call( "askForReviewNow", title, message, appPackageName );
	}
	
	
	// Resets all stored values such as launch count, first launch date, etc. Use this if you release a new version and want that version to be reviewed
	public static void resetAskForReview()
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "resetAskForReview" );
	}
	
	#endregion
	
	
	#region Urban Airship
	
	// Enables push notifications for this device
	public static void urbanAirshipEnablePush()
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "urbanAirshipEnablePush" );
	}
	
	
	// Disables push notifications for this device
	public static void urbanAirshipDisablePush()
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "urbanAirshipDisablePush" );
	}
	
	
	// Lets UA know that an activity started for analytics purposes
	public static void urbanAirshipActivityStarted()
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "urbanAirshipActivityStarted" );
	}
	
	
	// Lets UA know that an activity stopped
	public static void urbanAirshipActivityStopped()
	{
		if( Application.platform != RuntimePlatform.Android )
			return;
		
		_plugin.Call( "urbanAirshipActivityStopped" );
	}
	
	
	// Gets the devices APID for use with UA push. Note that it takes a few seconds after enabling push for this to become available.
	public static string urbanAirshipGetAPID()
	{
		if( Application.platform != RuntimePlatform.Android )
			return string.Empty;
		
		return _plugin.Call<string>( "urbanAirshipGetAPID" );
	}
	
	
	#endregion
	
	
	#region Inline web view
	
	// Shows the inline web view. The values sent are multiplied by the screens dpi on the native side. Note that Unity's input handling will still occur so make sure
	// nothing is touchable that is behind the web view while it is displayed.
	public static void inlineWebViewShow( string url, int x, int y, int width, int height )
	{
		if( Application.platform != RuntimePlatform.Android )
			return;

		_plugin.Call( "inlineWebViewShow", url, x, y, width, height );
	}


	// Closes the inline web view
	public static void inlineWebViewClose()
	{
		if( Application.platform != RuntimePlatform.Android )
			return;

		_plugin.Call( "inlineWebViewClose");
	}


	// Sets the current url for the inline web view
	public static void inlineWebViewSetUrl( string url )
	{
		if( Application.platform != RuntimePlatform.Android )
			return;

		_plugin.Call( "inlineWebViewSetUrl", url );
	}


	// Sets the current frame for the inline web view. The values sent are multiplied by the screens dpi on the native side.
	public static void inlineWebViewSetFrame( int x, int y, int width, int height )
	{
		if( Application.platform != RuntimePlatform.Android )
			return;

		_plugin.Call( "inlineWebViewSetFrame", x, y, width, height );
	}
	
	#endregion
	
}
#endif
