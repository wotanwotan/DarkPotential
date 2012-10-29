using UnityEngine;
using System.Collections;
using System.IO ;

public class Menu : MonoBehaviour
{	
	public UIToolkit topbar;
	public UIToolkit experienceBanners;
	public UIToolkit bgToolkit;
	
	// background image
	private UISprite menuBG;
	
	// experience banners
	private UIButton btnBanner1;
	private UIButton btnBanner2;
	private UIButton btnBanner3;
	
	// company banner
	private UIButton btnBannerMWG;
	
	// banner positioning
	private Vector3 banner1Show;
	private Vector3 banner1Hide;
	private Vector3 banner2Show;
	private Vector3 banner2Hide;
	private Vector3 banner3Show;
	private Vector3 banner3Hide;
	private Vector3 logoShow;
	private Vector3 logoHide;
	
	private UIButton settingsButton;
	private UIButton backButton;
	private UIButton fbButton;
	private UIButton twitterButton;
	private UIButton supportButton;
	
	private UIButton bannerAd;
	
	public ParticleEmitter logoDust;
	
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
		
		menuBG = bgToolkit.addSprite("bg.png", 0, 0);
		menuBG.setSize(Screen.width, Screen.height);
		menuBG.positionFromTopLeft(0f,0f);
		
		btnBanner1 = UIButton.create(experienceBanners, "banner1.png", "banner1.png", 0,0);
		btnBanner1.scale = Vector3.one * SceneLoader.GUIScaleFactor;
		btnBanner1.positionFromTop (0.1f);
		banner1Show = btnBanner1.position;
		banner1Hide = new Vector3(banner1Show.x, banner1Show.y + Screen.height, banner1Show.z);
		btnBanner1.hidden = true;
		
		btnBanner2 = UIButton.create(experienceBanners, "banner2.png", "banner2.png", 0,0);
		btnBanner2.scale = Vector3.one * SceneLoader.GUIScaleFactor;
		btnBanner2.positionFromTop (0.3f);
		banner2Show = btnBanner2.position;
		banner2Hide = new Vector3(banner2Show.x, banner2Show.y + Screen.height, banner2Show.z);
		btnBanner2.hidden = true;
		
		btnBanner3 = UIButton.create(experienceBanners, "banner2.png", "banner2.png", 0,0);
		btnBanner3.scale = Vector3.one * SceneLoader.GUIScaleFactor;
		btnBanner3.positionFromTop (0.5f);
		banner3Show = btnBanner3.position;
		banner3Hide = new Vector3(banner3Show.x, banner3Show.y + Screen.height, banner3Show.z);
		btnBanner3.hidden = true;
		
		// MWG banner
		btnBannerMWG = UIButton.create(experienceBanners, "logo-mwg.png", "logo-mwg.png", 0,0);
		btnBannerMWG.scale = Vector3.one * SceneLoader.GUIScaleFactor;
		btnBannerMWG.positionFromBottomLeft (0.05f, 0.1f);
		logoShow = btnBannerMWG.position;
		logoHide = new Vector3(logoShow.x, logoShow.y, logoShow.z + 5f);
		btnBannerMWG.hidden = true;
		
		StartCoroutine(ShowBanners(false, 0.001f));
			
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
	
	void OnLevelWasLoaded()
	{
		// wait a second, and then begin the menu animations
		StartCoroutine(BeginMenuAnimations());
	}
	
	private IEnumerator BeginMenuAnimations()
	{
		// wait
		yield return new WaitForSeconds(1f);
		
		// play audio
		AudioSource audioSrc = GetComponent<AudioSource>();
		audioSrc.Play ();
		
		yield return new WaitForSeconds(0.5f);
		
		// animate banners		
		StartCoroutine(ShowBanners(true, 0.25f));
	}
	
	private IEnumerator ShowBanners(bool show, float time)
	{
		if (show)
		{
			btnBanner1.hidden = false;
			btnBanner1.positionTo (time, banner1Show, Easing.Circular.easeOut);
			
			yield return new WaitForSeconds(0.4f);
			btnBanner2.hidden = false;
			btnBanner2.positionTo (time, banner2Show, Easing.Circular.easeOut);
			
			yield return new WaitForSeconds(0.4f);
			btnBanner3.hidden = false;
			btnBanner3.positionTo (time, banner3Show, Easing.Circular.easeOut);
			
			yield return new WaitForSeconds(0.5f);
			btnBannerMWG.hidden = false;
			btnBannerMWG.positionTo (time, logoShow, Easing.Circular.easeOut);
			logoDust.Emit();
		}
		else
		{
			btnBanner1.positionTo (time, banner1Hide, Easing.Linear.easeOut);
			btnBanner2.positionTo (time, banner2Hide, Easing.Linear.easeOut);
			btnBanner3.positionTo (time, banner3Hide, Easing.Linear.easeOut);
			btnBannerMWG.positionTo (time, logoHide, Easing.Linear.easeOut);
		}
	}
	
}