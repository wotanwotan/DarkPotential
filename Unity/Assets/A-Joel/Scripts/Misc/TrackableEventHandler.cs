using UnityEngine;
using System.Collections;
using System.Collections.Generic;


public class TrackableEventHandler : MonoBehaviour, ITrackableEventHandler
{
	public static bool trackableFound;
	public static string trackableName = "";
	
	private TrackableBehaviour trackableBehaviour;
	
	// Do not change this function to Awake().
	// Other scripts are performing necessary setup of ImageTargets and AROrigin in Awake().
	protected void Start()
	{
		trackableBehaviour = GetComponent<TrackableBehaviour>();
		if (trackableBehaviour)
		{
			trackableBehaviour.RegisterTrackableEventHandler(this);
		}
		
		switch (trackableBehaviour.CurrentStatus)
		{
			case TrackableBehaviour.Status.TRACKED: OnTrackingFound(); break;
			default: FinishLosingTracking(); break;
		}
	}
	
	public void OnTrackableStateChanged(TrackableBehaviour.Status previousStatus, TrackableBehaviour.Status newStatus)
	{
		bool previouslyHadTracking =
			previousStatus == TrackableBehaviour.Status.DETECTED ||
			previousStatus == TrackableBehaviour.Status.TRACKED;
		
		bool nowHasTracking =
			newStatus == TrackableBehaviour.Status.DETECTED ||
			newStatus == TrackableBehaviour.Status.TRACKED;
		
		if (!previouslyHadTracking && nowHasTracking)
		{
			OnTrackingFound();
		}
		else if (previouslyHadTracking && !nowHasTracking)
		{
			OnTrackingLost();
		}
	}
	
	virtual protected void OnTrackingFound()
	{	
		StopCoroutine("LosingTracking");

		trackableFound = true;
		
		// Enable children's rendering.
		foreach (Renderer renderer in GetComponentsInChildren<Renderer>(true))
		{
			renderer.enabled = true;
		}

		Debug.Log("Trackable " + trackableBehaviour.TrackableName + " found");
		trackableName = trackableBehaviour.TrackableName;
		
		// when there are multiple trackers, ignore the others
		
	}
	
	virtual protected void OnTrackingLost()
	{
		if(this.gameObject.active)
		{
			StartCoroutine("LosingTracking");
		}
		else
		{
			FinishLosingTracking();
		}
	}
	
	virtual protected IEnumerator LosingTracking()
	{
		yield return null;//new WaitForSeconds(loseTrackingDelay);
		FinishLosingTracking();
	}
	
	virtual protected void FinishLosingTracking()
	{
		trackableFound = false;
		
		// Disable children's rendering.
		foreach (Renderer renderer in GetComponentsInChildren<Renderer>(true))
			renderer.enabled = false;
		
		Debug.Log("Trackable " + trackableBehaviour.TrackableName + " lost");
	}
	
	virtual protected void OnDestroy()
	{
		if (trackableBehaviour)
		{
			trackableBehaviour.UnregisterTrackableEventHandler(this);
		}
	}
}