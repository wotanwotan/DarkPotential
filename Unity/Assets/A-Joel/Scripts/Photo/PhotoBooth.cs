using UnityEngine;
using System.Collections;

public class PhotoBooth : MonoBehaviour
{
	//public Transform spidey1;
	//public Transform spidey2;
	
	// save image to device even when just emailing or facebooking
	private bool alreadySavedImageToAlbum;
	
	public void Start()
	{
		alreadySavedImageToAlbum = false;	
	}
	
	public IEnumerator FacebookShare(string path, Texture2D tex)
	{
		if (!alreadySavedImageToAlbum)
			StartCoroutine(SavePhoto(path, false));
		
		SocialNetworking.Instance.FacebookPostImage(tex);

		yield return null;
	}
	
	public IEnumerator Email(string path)
	{
		if (!alreadySavedImageToAlbum)
			StartCoroutine(SavePhoto(path, false));
		
		SocialNetworking.Instance.Email();
		
		yield return null;
	}
	
	public IEnumerator SavePhoto(string path, bool showFeedback)
	{
		if (showFeedback)
			SocialNetworking.Instance.SaveImage();
		else
			StartCoroutine(SocialNetworking.Instance.SaveImageNoIndicator());
		
		alreadySavedImageToAlbum = true;
		
		yield return null;
	}
	
	public void ScreenCaptureWasJustSaved(bool val)
	{
		alreadySavedImageToAlbum = val;
	}
}
