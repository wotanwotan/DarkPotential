using UnityEngine;
using System.Collections;

public class PushNotificationsController : MonoBehaviour {

//Urban Airship Config Strings
private string uaAppKey = "AWrmpl7vRDigp0FFQK9CnA";
private string uaAppSecret = "1cG-jWbuT7SRfckV620lAw";

private string appstoreurl = "http://itunes.apple.com/app/id526737700";


	// Use this for initialization
	void Awake () {
	  #if UNITY_IPHONE
	  		EtceteraManager.remoteNotificationReceived += NotificationRecieved;
			EtceteraManager.urbanAirshipRegistrationSucceeded += ActionSuccess; 
			EtceteraManager.urbanAirshipRegistrationFailed+= ActionFail; 
			EtceteraBinding.setUrbanAirshipCredentials( uaAppKey, uaAppSecret);
			EtceteraBinding.registerForRemoteNotifcations(P31RemoteNotificationType.Alert);
			EtceteraManager.alertButtonClicked += updateAlertPromptClicked;
		#endif
		#if UNITY_ANDROID
			EtceteraAndroid.urbanAirshipEnablePush();
		#endif
		
	}
	
	public void updateAlertPromptClicked(string clicked){
	clicked = clicked.ToLower();
		if (clicked.Equals("update")){
			Application.OpenURL (appstoreurl);
		}
	}
	
	public void ActionSuccess() {
	#if UNITY_IPHONE
		//EtceteraBinding.showAlertWithTitleMessageAndButton( "UAS", "Success!", "OK" );
	#else
		//EtceteraAndroid.showAlert("UAS", "Success!", "OK" );
	#endif
	}
	
	public void ActionFail(string error) {
	#if UNITY_IPHONE
		//EtceteraBinding.showAlertWithTitleMessageAndButton( "UAS", "FAIL -- "+error, "OK" );
	#else
		//EtceteraAndroid.showAlert("UAS", "FAIL -- "+error, "OK" );
	#endif
	}
	
	public void NotificationRecieved(Hashtable notification){
	#if UNITY_IPHONE
		string alert  = notification["alert"] as string;
		alert = alert.ToLower();
		if (alert.Contains("update") ){
			if (alert.Contains("webslinger") || alert.Contains("web slinger")){
				EtceteraBinding.showAlertWithTitleMessageAndButtons( "Update", "There's an update available. Would you Like to download it now?", new string [] {"Update", "Cancel"} );
			}
		}
	#else
		//EtceteraAndroid.showAlert("UAS", "Notification Recieved!", "OK" );
	#endif
	}
	
}
