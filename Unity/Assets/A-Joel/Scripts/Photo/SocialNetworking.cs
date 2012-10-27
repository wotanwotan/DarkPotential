using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class SocialNetworking : MonoBehaviour {
	
	
	
	private static SocialNetworking instance = null;
	public static SocialNetworking Instance
	{ 
		get {
			if (instance == null)
			{
                Debug.Log("instantiate social networking");
                GameObject go = new GameObject();
                instance = go.AddComponent<SocialNetworking>();
                go.name = "SocialNetworking";


				instance.successTexture 	= (Texture2D)Resources.Load("social-posted", typeof(Texture2D));
				instance.failTexture 		= (Texture2D)Resources.Load("social-failed", typeof(Texture2D));
				
				instance.Init();
            }
			return instance; 
		}
	}

	public Texture2D successTexture;
	public Texture2D failTexture;
	
	private bool useTweetSheet = false;
	
	private string twitter_consumer_key		= 	"uM5PoRb6bWUL9DpXiBBM0A";
	private string twitter_consumer_secret 	= 	"h658AUjCUm4t7X6O11PVJW18cz3Sg2K5KLLjRfnVzc4";
	private string twitter_hash_tag 		=	"#SpidermanAR";
	private string twitter_default_message 	= 	"Check out my Spider-Man comic with the #Webslinger app only at #Walmart ";
	
	private string facebook_init			= 	"348726778509021" ;
	private string facebook_message 		= 	"Check out my Spider-Man comic with the Web-slinger app only at Walmart " ;
	
#if UNITY_IPHONE 
	private string email_message 			= 	"Check out my Spider-Man comic with the Web-slinger app only at Walmart.";
#elif UNITY_ANDROID
	private string android_email_message	= 	"Check out my Spider-Man comic with the Web-slinger app only at Walmart.";
#endif
	
	private bool success = false;
	private bool fail = false;
	
	private Rect frame;
	private float startTime = 0.0f;
	public string globalFileName;
	
	// Use this for initialization
	void Init ()
	{
		frame = new Rect(((Screen.width - 177)/2)+10, ((Screen.height - 52)/2)-20, 177, 52);
				
#if UNITY_IPHONE
		TwitterBinding.init( twitter_consumer_key, twitter_consumer_secret ) ;
		TwitterManager.postSucceededEvent 	+= ActionSuccess ;
		TwitterManager.postFailedEvent 		+= ActionFail;
		
		FacebookBinding.init( facebook_init );
#elif UNITY_ANDROID
		FacebookAndroid.init( facebook_init );
		TwitterAndroid.init( twitter_consumer_key, twitter_consumer_secret ) ;
#endif
	}
	
	
	void Awake()
	{
        instance = this;
		Init();
    }

	
	void OnGUI ()
		{	
				if ((Time.time - startTime > 1.0f) && (startTime > 0.0f)) {
						success = false;
						fail = false;
						startTime = 0.0f;
				}
		
				if (success) {
						GUI.DrawTexture(frame, successTexture);
				}
		
				if (fail) {
						GUI.DrawTexture(frame, failTexture);
				}
	}
	
	
	#region FACEBOOK_REGION
	
	public void FacebookLogin()
	{
		Debug.Log("Facebook Login");
#if UNITY_IPHONE
		if (!FacebookBinding.isSessionValid()) 
			FacebookBinding.loginWithRequestedPermissions(new string[] {"publish_stream", "offline_access"});
#elif UNITY_ANDROID
		if (!FacebookAndroid.isSessionValid()) 
			FacebookAndroid.loginWithRequestedPermissions(new string[] {"publish_stream", "offline_access"});
#endif
		else
		{
			Debug.Log ("Already logged into Facebook. Logging out...");
#if UNITY_IPHONE
			FacebookBinding.logout();
#elif UNITY_ANDROID
			FacebookAndroid.logout();
#endif
			
			// try again
			FacebookLogin ();
		}
	}
	
	public void FacebookPostText() {
		StartCoroutine( FacebookCheckIfLoogedInAnd_PostText() ) ;
	}
	
	private void postFbMessage() {
		Facebook.instance.postMessage( "Lorem Ipsum", ActionSuccess );
		/*
		Facebook.instance.postMessageWithLink(
			facebook_message,
			null,
			null,
			FacebookActionSuccess
			);*/
	}
	
	private IEnumerator FacebookCheckIfLoogedInAnd_PostText () {
#if UNITY_IPHONE
		if(FacebookBinding.isSessionValid())
#elif UNITY_ANDROID
		if (FacebookAndroid.isSessionValid())
#endif
		{
			Debug.Log ("Yes, we are logged in. Post the image...");
			postFbMessage() ;
			FBSuccess();
			Debug.Log ("...done.");
		}
		else
		{
			Debug.Log("Not logged in!");
			FacebookLogin();
			yield return new WaitForSeconds(1.5f);
#if UNITY_IPHONE
			if(FacebookBinding.isSessionValid())
#elif UNITY_ANDROID
			if (FacebookAndroid.isSessionValid())
#endif
			{
				postFbMessage() ;
				FBSuccess();
				//FlurryMetricsController.Instance.TextPostedToFacebook();
			}
			else
				FBFail();			
		}
		yield return null;
	}
	
	public void FacebookPostImage(Texture2D img)
	{
		Debug.Log("Posting to Facebook");
		Debug.Log("Converting image...");
		byte[] photo = img.EncodeToPNG();
		Debug.Log("... done. Now sending to facebook...");
		StartCoroutine(iPhoneCheckLoggedinAndPostImage(photo));
	}
	
	IEnumerator iPhoneCheckLoggedinAndPostImage(byte[] img)//Texture2D img)
	{
#if UNITY_IPHONE
		if(FacebookBinding.isSessionValid())
#elif UNITY_ANDROID
		if (FacebookAndroid.isSessionValid())
#endif
		{
			Debug.Log ("Yes, we are logged in. Post the image...");
			Facebook.instance.postImage(img, facebook_message, FacebookActionSuccess);
			FBSuccess();
			Debug.Log ("...done.");
		}
		else
		{
			Debug.Log("Not logged in!");
			FacebookLogin();
			yield return new WaitForSeconds(1.5f);
#if UNITY_IPHONE
			if(FacebookBinding.isSessionValid())
#elif UNITY_ANDROID
			if (FacebookAndroid.isSessionValid())
#endif
			{
				Facebook.instance.postImage( img, facebook_message, FacebookActionSuccess);
				SaveImageNoIndicator();
				FBSuccess();
				//FlurryMetricsController.Instance.PhotoPostedToFacebook();
			}
			else
				FBFail();			
		}
		yield return null;
	}
	
	
	#endregion
	
	
	
	
	public void SaveImage()
	{
		Debug.Log("Saving image");
#if UNITY_IPHONE
		EtceteraBinding.saveImageToPhotoAlbum(Application.temporaryCachePath + "/" + globalFileName);	
		SSuccess();
#elif UNITY_ANDROID
		EtceteraAndroid.saveImageToGallery( Application.temporaryCachePath + "/" + globalFileName, "picture"+Time.time.ToString() );
		SSuccess();
#endif	
	}
	
	public IEnumerator SaveImageNoIndicator()
	{
		Debug.Log("Saving image with no indicator");
		#if UNITY_IPHONE
		EtceteraBinding.saveImageToPhotoAlbum(Application.temporaryCachePath + "/" + globalFileName);	
		#elif UNITY_ANDROID
		EtceteraAndroid.saveImageToGallery( Application.temporaryCachePath + "/" + globalFileName, null);
		#endif	
		yield return null;
	}
	
	
	public void Email()
	{
		Debug.Log("Emailing");
	#if UNITY_IPHONE
		if(EtceteraBinding.isEmailAvailable())
		{
			EtceteraBinding.showMailComposerWithAttachment(Application.temporaryCachePath + "/" + globalFileName,
				"image/png", "Spiderman"+Time.time.ToString()+".png", "", email_message, "", true);
			EMSuccess();
			//FlurryMetricsController.Instance.PhotoEmailed();
		}
		else
		{
			EtceteraBinding.showAlertWithTitleMessageAndButtons("No Email Found!", "You need to set up an email acount on your device.", new string[]{"OK"});
			EMFail();
		}
	#elif UNITY_ANDROID
		EtceteraAndroid.showEmailComposer( "", android_email_message, "", false, Application.temporaryCachePath + "/" + globalFileName );
		SaveImageNoIndicator();
		EMSuccess();
		//FlurryMetricsController.Instance.PhotoEmailed();
	#endif	
		SaveImageNoIndicator();
	}
	
	public void EmptyEmail(string address, string subject)
	{
		StartCoroutine(SaveImageNoIndicator());
		Debug.Log("Emailing");
		#if UNITY_IPHONE
		if(EtceteraBinding.isEmailAvailable())
		{
			EtceteraBinding.showMailComposer(address, subject, "", true );
			EMSuccess();
		}
		else
		{
			EMFail();
		}
		#elif UNITY_ANDROID
		EtceteraAndroid.showEmailComposer(address, subject, "", true);
		#endif	
	}
	

	
	public void ActionSuccess(string message, object obj)
	{
		Debug.Log ("ActionSuccess: " + message);
		startTime = Time.time;
		success = true;
	}
	
	public void ActionSuccess()
	{
		Debug.Log ("ActionSuccess()");
		startTime = Time.time;
		success = true;
	}

	public void ActionSuccessFacebook()
	{
		startTime = Time.time;
		success = true;
	}
	
	public void FacebookActionSuccess(string message, object obj)
	{
		Debug.Log ("FacebookActionSuccess()");
	}
	
	public void ActionSuccessObj(object obj)
	{
		Debug.Log("ActionSuccessObj: " + obj);
		startTime = Time.time;
		success = true;
	}




	public void FBSuccess(){
		startTime = Time.time;
		success = true;
	}

	public void TSuccess(){
		startTime = Time.time;
		success = true;
	}

	public void EMSuccess(){
		startTime = Time.time;
		success = true;
	}

	public void SSuccess(){
		startTime = Time.time;
		success = true;
	}

	public void FBFail(){
		startTime = Time.time;
		fail = true;
	}

	public void TFail(){
		startTime = Time.time;
		fail = true;
	}

	public void EMFail(){
		startTime = Time.time;
		fail = true;
	}

	public void SFail(){
		startTime = Time.time;
		fail = true;
	}


	public void ActionFail(string error)
	{
		Debug.Log("ActionFail: " + error);
		startTime = Time.time;
		fail = true;
	}
	
	
	
	#region TWITTER_REGION
	
	
	public void TwitterLogin () {
		Debug.Log( "Initialisation");
#if UNITY_IPHONE
		TwitterBinding.showOauthLoginDialog();
		Debug.Log( "End" ); 
#endif
#if UNITY_ANDROID 
		// Twitter login
		TwitterAndroid.showLoginDialog();
#endif
	}
	
		private void CheckOperatingSystem() {

#if UNITY_IPHONE
		Debug.Log( SystemInfo.operatingSystem ) ;

		var someSplit = SystemInfo.operatingSystem.Split( ' ' ) ;
		Debug.Log ( "Version number : " + someSplit[1] ) ;
		string[] someOtherSplit = someSplit[2].Split( '.' );

		Debug.Log ( "This is the intersting part : " + someOtherSplit[0] );
		if( someOtherSplit[0][0] == '5' || someOtherSplit[0][0] == '6' ){
			Debug.Log( "OS version is 5 Activate neat stuff" );
			useTweetSheet = true ;
		}
		else{
			Debug.Log( "meh stay as it is " );
		}
#endif

	}
	
	
	
	public void TwitterPostText() {
		Debug.Log("Posting to Twitter");
		CheckOperatingSystem() ;

		Debug.Log("... done. Now sending to twitter...");
		StartCoroutine( TwitterCheckIfLoggedinAndPostText() );
	}
	
	
	private IEnumerator TwitterCheckIfLoggedinAndPostText(){
		{
#if UNITY_IPHONE
		if( TwitterBinding.isLoggedIn())
#elif UNITY_ANDROID
		if ( TwitterAndroid.isLoggedIn() )
#endif
		{
			Debug.Log( "I sure hope that you are logged otherwise you are going to have a bad time " + TwitterBinding.isLoggedIn()  ) ;
			if( !useTweetSheet )  {
					TwitterBinding.postStatusUpdate( twitter_default_message + twitter_hash_tag );
			}
			else {
				Debug.Log( "Can the user tweet using the tweet sheet? " + TwitterBinding.isTweetSheetSupported() );
				if ( TwitterBinding.canUserTweet() ) {
					TwitterBinding.showTweetComposer( twitter_default_message + twitter_hash_tag, null ) ;
				}
				else TwitterBinding.postStatusUpdate( twitter_default_message + twitter_hash_tag );
			}
			TSuccess();
			Debug.Log ("...done.");
		}
		else
		{
			Debug.Log("Not logged in!");
			TwitterLogin();
			yield return new WaitForSeconds(1.5f);
#if UNITY_IPHONE
			if(TwitterBinding.isLoggedIn())
#elif UNITY_ANDROID
			if (TwitterAndroid.isLoggedIn())
#endif
			{
				Debug.Log( "I sure hope that you are logged otherwise you are going to have a bad time " + TwitterBinding.isLoggedIn()  ) ;
				if( !useTweetSheet )  {
					TwitterBinding.postStatusUpdate( twitter_default_message);
				}
				else {
					Debug.Log( "Can the user tweet using the tweet sheet? " + TwitterBinding.isTweetSheetSupported() );
					if ( TwitterBinding.canUserTweet() ) {
						TwitterBinding.showTweetComposer( twitter_default_message , null );
					}
					else TwitterBinding.postStatusUpdate( twitter_default_message );
				}
			TSuccess();
			}
			else { ; }
			TFail();			
		}
		yield return null;
	}	
	}
	
	
	
	

	public void TwitterPostImage()
	{
		Debug.Log("Posting to Twitter");
		CheckOperatingSystem() ;

		Debug.Log("... done. Now sending to twitter...");
		StartCoroutine( TwitterCheckLoggedinAndPostImage( Application.temporaryCachePath + "/" + globalFileName ) );
		SaveImageNoIndicator();
	}
	
	IEnumerator TwitterCheckLoggedinAndPostImage( string pictureDataPath ) {
#if UNITY_IPHONE
		if( TwitterBinding.isLoggedIn())
#elif UNITY_ANDROID
		if ( TwitterAndroid.isLoggedIn() )
#endif
		{
#if UNITY_IPHONE
			Debug.Log( "I sure hope that you are logged otherwise you are going to have a bad time " + TwitterBinding.isLoggedIn()  ) ;
			if( !useTweetSheet )  {
//				TwitterAndroid.postUpdateWithImage( twitter_default_message, CameraController.preview.EncodeToPNG() );	
			}
			else {

				Debug.Log( "Can the user tweet using the tweet sheet? " + TwitterBinding.isTweetSheetSupported() );
				if ( TwitterBinding.canUserTweet() ) {
					TwitterBinding.showTweetComposer( twitter_default_message , pictureDataPath );
				}
				else TwitterBinding.postStatusUpdate( twitter_default_message , pictureDataPath );
			}
#elif UNITY_ANDROID
			Debug.Log("Posting to twitter");
				TwitterAndroid.postUpdateWithImage( twitter_default_message, CameraController.preview.EncodeToPNG() );		
#endif

			TSuccess();
			Debug.Log ("...done.");
		}
		else
		{
			Debug.Log("Not logged in!");
			TwitterLogin();
			yield return new WaitForSeconds(1.5f);
#if UNITY_IPHONE
			if(TwitterBinding.isLoggedIn())
#elif UNITY_ANDROID
			if (TwitterAndroid.isLoggedIn())
#endif
			{
#if UNITY_IPHONE
				Debug.Log( "I sure hope that you are logged otherwise you are going to have a bad time " + TwitterBinding.isLoggedIn()  ) ;
				if( !useTweetSheet )  {
					TwitterBinding.postStatusUpdate( twitter_default_message , pictureDataPath );
				}
				else {
					Debug.Log( "Can the user tweet using the tweet sheet? " + TwitterBinding.isTweetSheetSupported() );
					if ( TwitterBinding.canUserTweet() ) {
						TwitterBinding.showTweetComposer( twitter_default_message , pictureDataPath );
					}
					else TwitterBinding.postStatusUpdate( twitter_default_message , pictureDataPath );
				}
#elif UNITY_ANDROID
				Debug.Log ("posting the second time");
				TwitterAndroid.postUpdateWithImage( twitter_default_message, CameraController.preview.EncodeToPNG() );	
#endif
				TSuccess();
			}

			TFail();			
		}
		yield return null;
	}
	
	
	
	#endregion
	
}