using UnityEngine;
using System.Collections;

public class Initialization : MonoBehaviour
{
	void Awake()
	{
		DontDestroyOnLoad(gameObject);
	}

	void Start ()
	{
		// Disable screen sleep
		Screen.sleepTimeout = SleepTimeout.NeverSleep;
		SceneLoader.loadScene("Menu");
	}
}