using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;


#if UNITY_IPHONE
public class FacebookBinding
{
	static FacebookBinding()
	{
		// on login, set the access token
		FacebookManager.preLoginSucceededEvent += () =>
		{
			Facebook.instance.accessToken = getAccessToken();
		};
	}


    [DllImport("__Internal")]
    private static extern void _facebookInit( string applicationId );

	// Initializes the Facebook plugin for you application
    public static void init( string applicationId )
    {
        if( Application.platform == RuntimePlatform.IPhonePlayer )
			_facebookInit( applicationId );
		
		// grab the access token in case it is saved
		Facebook.instance.accessToken = getAccessToken();
    }
	
	
    [DllImport("__Internal")]
    private static extern bool _facebookIsLoggedIn();
 
	// Checks to see if the current session is valid
    public static bool isSessionValid()
    {
        if( Application.platform == RuntimePlatform.IPhonePlayer )
			return _facebookIsLoggedIn();
		return false;
    }
    
    
	[DllImport("__Internal")]
	private static extern string _facebookGetFacebookAccessToken();
	
	// Gets the current access token
	public static string getAccessToken()
	{
		if(Application.platform == RuntimePlatform.IPhonePlayer)
			return _facebookGetFacebookAccessToken();

		return string.Empty;
	}

	
	// Opens the Facebook single sign on login in Safari or the official Facebook app
    public static void login()
    {
        loginWithRequestedPermissions( new string[] {} );
    }

    public static void loginWithRequestedPermissions( string[] permissions )
    {
        loginWithRequestedPermissions( permissions, null );
    }


    [DllImport("__Internal")]
    private static extern void _facebookLoginWithRequestedPermissions( string perms, string urlSchemeSuffix );
	
	// Opens the Facebook single sign on login in Safari or the official Facebook app with the requested permissions
    public static void loginWithRequestedPermissions( string[] permissions, string urlSchemeSuffix )
    {
        if( Application.platform == RuntimePlatform.IPhonePlayer )
		{
			var permissionsString = string.Join( ",", permissions );
			_facebookLoginWithRequestedPermissions( permissionsString, urlSchemeSuffix );
		}
    }
	
	
    [DllImport("__Internal")]
    private static extern void _facebookLogout();
 
	// Logs the user out and invalidates the token
    public static void logout()
    {
        if( Application.platform == RuntimePlatform.IPhonePlayer )
			_facebookLogout();
		
		Facebook.instance.accessToken = string.Empty;
    }
	
	
    [DllImport("__Internal")]
    private static extern void _facebookShowDialog( string dialogType, string json );
 
	// Full access to any existing or new Facebook dialogs that get added.  See Facebooks documentation for parameters and dialog types
    public static void showDialog( string dialogType, Dictionary<string,string> options )
    {
        if( Application.platform == RuntimePlatform.IPhonePlayer )
			_facebookShowDialog( dialogType, Prime31.MiniJSON.jsonEncode( options ) );
    }

	
    [DllImport("__Internal")]
    private static extern void _facebookRestRequest( string restMethod, string httpMethod, string jsonDict );
 
	// Allows you to use any available Facebook REST API method
    public static void restRequest( string restMethod, string httpMethod, Hashtable keyValueHash )
    {
        if( Application.platform == RuntimePlatform.IPhonePlayer )
		{
			// convert the Hashtable to JSON
			string jsonDict = Prime31.MiniJSON.jsonEncode( keyValueHash );
			
			if( jsonDict != null )
				_facebookRestRequest( restMethod, httpMethod, jsonDict );
		}
    }
	
	
    [DllImport("__Internal")]
    private static extern void _facebookGraphRequest( string graphPath, string httpMethod, string jsonDict );
 
	// Allows you to use any available Facebook Graph API method
    public static void graphRequest( string graphPath, string httpMethod, Hashtable keyValueHash )
    {
        if( Application.platform == RuntimePlatform.IPhonePlayer )
		{
			// convert the Hashtable to JSON
			string jsonDict = Prime31.MiniJSON.jsonEncode( keyValueHash );
			
			if( jsonDict != null )
				_facebookGraphRequest( graphPath, httpMethod, jsonDict );
		}
    }
	

	#region iOS6 Facebook composer
	
	[DllImport("__Internal")]
	private static extern bool _facebookIsFacebookComposerSupported();

	// Facebook Composer methods
	public static bool isFacebookComposerSupported()
	{
		if( Application.platform == RuntimePlatform.IPhonePlayer )
			return _facebookIsFacebookComposerSupported();

		return false;
	}


	[DllImport("__Internal")]
	private static extern bool _facebookCanUserUseFacebookComposer();

	// Checks to see if the user is using a version of iOS that supports the Facebook composer and if they have an account setup
	public static bool canUserUseFacebookComposer()
	{
		if( Application.platform == RuntimePlatform.IPhonePlayer )
			return _facebookCanUserUseFacebookComposer();

		return false;
	}


	[DllImport("__Internal")]
	private static extern void _facebookShowFacebookComposer( string message, string imagePath, string link );
	
	public static void showFacebookComposer( string message )
	{
		showFacebookComposer( message, null, null );
	}
	
	
	// Shows the Facebook composer with optional image path and link
	public static void showFacebookComposer( string message, string imagePath, string link )
	{
		if( Application.platform == RuntimePlatform.IPhonePlayer )
			_facebookShowFacebookComposer( message, imagePath, link );
	}
	
	#endregion

}
#endif
