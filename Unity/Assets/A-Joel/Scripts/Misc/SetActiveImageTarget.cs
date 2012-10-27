using UnityEngine;
using System.Collections;

public class SetActiveImageTarget : MonoBehaviour {
	
	public string editorImageTarget;
	private string trackername;
	
	void Awake ()
	{
		GameObject arOrigin = GameObject.Find("AROrigin");
		GameObject image_targets_root = GameObject.Find("ImageTargets");
		if (image_targets_root == null)
		{
			Debug.Log("image_targets_root" == null);
		}
		else
		{	
			/*if (SceneLoader.trackableName != null)
			{
				trackername = SceneLoader.trackableName;
			}
			else*/
			{
				trackername = editorImageTarget;
			}
			
			if (trackername != null)
			{
				Debug.Log("TRACKER: " + trackername);
				GameObject active_image_target = GameObject.Find(trackername);
				if (active_image_target == null)
				{
					Debug.Log("Active Image target == null");
					image_targets_root.SetActiveRecursively(false);
					arOrigin.SetActiveRecursively(false);
					Debug.Log("The image target "+trackername+ " was not found in this scene");
				}
				else
				{
					active_image_target.transform.parent = null;
					image_targets_root.SetActiveRecursively(false);
					GameObject jf = GameObject.Find("JitterFree");
					if(jf == null)
					{
						Debug.Log("jf == null");
						arOrigin.transform.parent = active_image_target.transform;
					}
					else
					{
						arOrigin.transform.parent = jf.transform;
					}
				}
			}
			else
			{
				Debug.Log("SceneLoader.trackableName = null!");
			}
		}
	}
}
