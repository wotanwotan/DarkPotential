using UnityEngine;
using System.Collections;

public class CameraAspect : MonoBehaviour {
	
	
	/* 
	 * FOV: 31
	 * 
	 * 1024/768 = 1.3333
	 * 
	 * FOV: 37
	 * 
	 * 960/640 = 1.5
	 * 1280/800 = 1.6
	 * 800/480 = 1.6666 
	 * 1280/720 = 1.777
	 * 960/540 = 1.777
	 * 854/480 = 1.779
	 *
	 *
	 * HOW 2 MATH RIGHT? 
	 * 
	 */
	
	
	
	public Camera cam;
	
	// Use this for initialization
	void Start () {
		float aspect = Screen.height*1.0f / Screen.width*1.0f;
		Debug.Log(aspect);
		if (aspect >= 1.5) {
			cam.fieldOfView = 37.0f;
		} else {
			// ipad aspect ratio is silly 
			cam.fieldOfView = 31.0f;
		}
		
	}
	
}
