using UnityEngine;
using System.Collections;

public class CameraManager : MonoBehaviour {

	private Texture2D preview;
	private Texture2D closeButton;
	
	[HideInInspector]
	public Rect previewRect;
	public float previewScale = 0.75f;
	[HideInInspector]
	public bool previewIsVisible = false;
	private string screenshotPath;
	
	public string ScreenshotPath
	{
		get { return screenshotPath; }
	}
	
	public Texture2D Screenshot
	{
		get { return preview; }
	}
	
	private MeshRenderer[] uiMeshes;
	
	void Start()
	{
		
		preview = new Texture2D(Screen.width, Screen.height, TextureFormat.RGB24, false);
		closeButton = Resources.Load("button-2x") as Texture2D;
		
		// Center the photo preview rect
		float left, top, width, height;
		width = Screen.width*previewScale;
		height = Screen.height*previewScale;
		left = (Screen.width - width)/2;
		top = (Screen.height - height)/2;
		previewRect = new Rect(left, top, width, height);

		screenshotPath = "";
		uiMeshes = GetComponentsInChildren<MeshRenderer>();	
	}
	
	public void HideUI()
	{
		for (int i = 0; i < uiMeshes.Length; i++)
			uiMeshes[i].enabled = false;
	}
	
	public void ShowUI()
	{
		for (int i = 0; i < uiMeshes.Length; i++)
			uiMeshes[i].enabled = true;
	}
	
		
	public IEnumerator TakePhoto()
	{
		Debug.Log ("Take Photo");
		
		previewIsVisible = false;
		HideUI();
		
		// Have to wait until end of frame so the 3D objects get drawn before the photo gets taken
		yield return new WaitForEndOfFrame();
		CapturePreview();
		
		ShowUI();
		previewIsVisible = true;
		yield return null;
	}
	
	
	public void CapturePreview()
	{

		Debug.Log ("Capture Preview");
        preview.ReadPixels( new Rect(0, 0, Screen.width, Screen.height), 0, 0, false);
        preview.Apply();
		
		string filenameTemp = "screenshot" + System.DateTime.Now.Ticks + ".png";
		SocialNetworking.Instance.globalFileName = filenameTemp;
		StartCoroutine(CacheToDisk(filenameTemp));
	}
		
	private IEnumerator CacheToDisk(string filename)
	{
		Debug.Log ("Begin saving preview to disk");
		screenshotPath = Application.persistentDataPath + "/" + filename;
		
		byte[] bytes = preview.EncodeToPNG();
        System.IO.File.WriteAllBytes(screenshotPath, bytes);
		
		Debug.Log ("End saving preview to disk");
		yield return null;
	}

	public void ClosePreview()
	{
		previewIsVisible = false;
	}
	
	// Displays the preview of the image 
	void OnGUI()
	{
		if (previewIsVisible)
		{
			GUI.DrawTexture(previewRect, preview, ScaleMode.ScaleToFit, false, 0.0f);
			if(GUI.Button(new Rect(previewRect.xMax-closeButton.width*0.3f*SceneLoader.GUIScaleFactor, previewRect.y*0.7f, closeButton.width*0.7f*SceneLoader.GUIScaleFactor, closeButton.height*0.7f*SceneLoader.GUIScaleFactor), closeButton, GUIStyle.none))
			{
//				pui.CloseScreenCapture();
			}
		}
	}
}