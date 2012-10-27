using UnityEngine;
using System.Collections;
using System.IO ;

public class Menu : MonoBehaviour
{	
	public UIToolkit topbar;
	public UIToolkit experienceBanners;
	
	private UIButton settingsButton;
	private UIButton backButton;
	private UIButton fbButton;
	private UIButton twitterButton;
	private UIButton supportButton;
	
	private UIButton bannerAd;	
	
	// Use this for initialization
	void Start ()
	{		
		UISprite top_banner = topbar.addSprite("blank-bar-horizontal-slice.png", 0,0);
		top_banner.setSize(Screen.width, top_banner.height*SceneLoader.GUIScaleFactor);
		top_banner.positionFromTopLeft(0.0f, 0.0f);
			
		settingsButton = UIButton.create(topbar, "icon-gear.png", "icon-gear-on.png", 0,0);
		settingsButton.scale = Vector3.one * SceneLoader.GUIScaleFactor;
		settingsButton.positionFromTopRight(0.009f, 0.03f);
		settingsButton.normalTouchOffsets = new UIEdgeOffsets(30);
		settingsButton.highlightedTouchOffsets = new UIEdgeOffsets(30);
		//settingsButton.onTouchDown += (sender) => DisplayPopup("Settings");
			
		/*fbButton = UIButton.create(blankPopups, "popup-settings-fb.png", "popup-settings-fb-on.png", 0,0);
		fbButton.parentUIObject = frame;
		fbButton.positionFromCenter(-0.22f, 0f);
		fbButton.onTouchUpInside += (sender) => SocialNetworking.Instance.FacebookLogin();

		twitterButton = UIButton.create(blankPopups, "settings-twitter.png", "settings-twitter-onclick.png", 0,0);
		twitterButton.parentUIObject = frame;
		twitterButton.positionFromCenter(0.0f, 0f);
		twitterButton.onTouchUpInside += (sender) => SocialNetworking.Instance.FacebookLogin();
		
		supportButton = UIButton.create(blankPopups, "popup-settings-support.png", "popup-settings-support-on.png", 0,0);
		supportButton.parentUIObject = frame;
		supportButton.positionFromCenter(0.2f, 0f);
		supportButton.onTouchUpInside += (sender) =>
		{
#if UNITY_IPHONE
			if(EtceteraBinding.isEmailAvailable())
				EtceteraBinding.showMailComposer("app-support@miniwargaming.com", "Dark Potential App Support", "", true);
			else
				EtceteraBinding.showAlertWithTitleMessageAndButton("No Email Found!", "You need to set up an email account on your device.", "OK");
#else
			EtceteraAndroid.showEmailComposer("app-support@miniwargaming.com", "Dark Potential App Support", "", true);
#endif
		};
				
		bannerAd = UIButton.create(moreApps, "banner-ad-app.png", "banner-ad-app.png", 0,0);
		bannerAd.scale = new Vector3(SceneLoader.GUIScaleFactor, SceneLoader.GUIScaleFactor, SceneLoader.GUIScaleFactor);
		bannerAd.positionFromBottom(0.0f, 0.0f, UIyAnchor.Bottom, UIxAnchor.Center);
		bannerAd.onTouchUpInside += (obj) => {
			Application.OpenURL("http://www.darkpotential.com");
		};*/
		
		// Enable screen sleep
		Screen.sleepTimeout = SleepTimeout.SystemSetting;
	}	
	
	void Update()
	{
#if UNITY_ANDROID
		if (Input.GetKeyDown (KeyCode.Escape)) {
			Application.Quit ();
		}
#endif
	}
	
}