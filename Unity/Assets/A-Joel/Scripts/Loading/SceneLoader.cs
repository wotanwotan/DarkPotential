using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Security.Cryptography;

public class SceneLoader : MonoBehaviour
{
	private static SceneLoader instance = null;
	public static SceneLoader Instance { 
		get {
			if (instance == null) {
                Debug.Log("instantiate");
                GameObject go = new GameObject();
                instance = go.AddComponent<SceneLoader>();
                go.name = "SceneLoader";
            }

			return instance; 
		}
	}
	
	public static float GUIScaleFactor = 1f;

	private Queue<AsyncOperation> scenesToLoad;
	
    void Awake()
	{
        instance = this;
		scenesToLoad = new Queue<AsyncOperation>();
				
		DontDestroyOnLoad(instance);
    }
	
	
	void Start()
	{		
		Screen.sleepTimeout = SleepTimeout.NeverSleep;
		
#if UNITY_IPHONE
		GUIScaleFactor = Screen.width / 768f; 
#else 
		GUIScaleFactor = Screen.width / 768f;
#endif
		
		// determine which splash to use here?
		
		Resources.UnloadUnusedAssets();
	}
	
	/*void OnGUI()
	{	
		Screen.sleepTimeout = SleepTimeout.NeverSleep;
		
		if (Application.isLoadingLevel || scenesToLoad.Count > 0)
		{
		}
		else
		{
			if (Screen.sleepTimeout != SleepTimeout.SystemSetting)
				Screen.sleepTimeout = SleepTimeout.SystemSetting;
		}
	}*/
	
	// public static wrappers
	public static void loadUI(string name) {
		SceneLoader.Instance.StartCoroutine(instance.streamUI(name, true, false));
	}
	
	public static void loadUIAdditive(string name) {
		SceneLoader.Instance.StartCoroutine(instance.streamUI(name, true, true));
	}
	
	public static void cacheUI(string name) {
		SceneLoader.Instance.StartCoroutine(instance.streamUI(name, false, false));
	}
	
	public static void loadScene(string name) {
		SceneLoader.Instance.StartCoroutine(instance.streamScene(name, true, false));
	}
	
	public static void loadSceneAdditive(string name) {
		SceneLoader.Instance.StartCoroutine(instance.streamScene(name, true, true));
	}
	
	public static void cacheScene(string name) {
		SceneLoader.Instance.StartCoroutine(instance.streamScene(name, false, false));
	}	
	
	// Type wrappers 
	public IEnumerator streamUI (string name, bool loadImmediately, bool loadAdditive) {
		yield return StartCoroutine(streamBundle(name, loadImmediately, loadAdditive, "UI"));
	}

	public IEnumerator streamScene (string name, bool loadImmediately, bool loadAdditive) {
		yield return StartCoroutine(streamBundle(name, loadImmediately, loadAdditive, "Experiences"));
	}
	
	private IEnumerator streamBundle (string name, bool loadImmediately, bool loadAdditive, string type)
	{
		if (loadImmediately && !loadAdditive)
		{
			AsyncOperation load = Application.LoadLevelAsync(name);
			scenesToLoad.Enqueue(load);
			StartCoroutine(progressDequeue(load));
		}
		else if (loadImmediately && loadAdditive)
		{
			AsyncOperation load = Application.LoadLevelAdditiveAsync(name);
			scenesToLoad.Enqueue(load);
			StartCoroutine(progressDequeue(load));
		}

		yield return null;
	}	
	
	private IEnumerator progressDequeue(AsyncOperation scene)
	{
		yield return scene;
		if (scene.isDone)
		{
			Debug.Log("Scene done loading");
			//yield return new WaitForSeconds(0.5f);
			scenesToLoad.Dequeue();
		}
		
		Debug.Log("Ending scene load");
		yield return null;
	}
	
	public void forceSceneDequeue()
	{
		scenesToLoad.Clear();
	}	
}