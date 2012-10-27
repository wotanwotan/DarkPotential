using UnityEngine;
using System.Collections;
using System;


public class TwitterManager : MonoBehaviour
{
#if UNITY_IPHONE
	// Fired after a successful login attempt was made
	public static event Action loginSucceededEvent;
	
	// Fired when an error occurs while logging in
	public static event Action<string> loginFailedEvent;
	
	// Fired after successfully sending a status update
	public static event Action postSucceededEvent;
	
	// Fired when a status update fails
	public static event Action<string> postFailedEvent;
	
	// Fired when the home timeline is received
	public static event Action<ArrayList> homeTimelineReceivedEvent;
	
	// Fired when a request for the home timeline fails
	public static event Action<string> homeTimelineFailedEvent;
	
	// Fired when a custom request completes
	public static event Action<object> requestDidFinishEvent;
	
	// Fired when a custom request fails
	public static event Action<string> requestDidFailEvent;
	
	// Fired when the tweet sheet completes. True indicates success and false cancel/failure.
	public static event Action<bool> tweetSheetCompletedEvent;
	
	
	
    void Awake()
    {
		// Set the GameObject name to the class name for easy access from Obj-C
		gameObject.name = this.GetType().ToString();
		DontDestroyOnLoad( this );
    }
	
	
	public void twitterLoginSucceeded( string empty )
	{
		if( loginSucceededEvent != null )
			loginSucceededEvent();
	}
	
	
	public void twitterLoginDidFail( string error )
	{
		if( loginFailedEvent != null )
			loginFailedEvent( error );
	}
	
	
	public void twitterPostSucceeded( string empty )
	{
		if( postSucceededEvent != null )
			postSucceededEvent();
	}
	
	
	public void twitterPostDidFail( string error )
	{
		if( postFailedEvent != null )
			postFailedEvent( error );
	}
	
	
	public void twitterHomeTimelineDidFail( string error )
	{
		if( homeTimelineFailedEvent != null )
			homeTimelineFailedEvent( error );
	}
	
	
	public void twitterHomeTimelineDidFinish( string results )
	{
		if( homeTimelineReceivedEvent != null )
		{
			ArrayList resultList = (ArrayList)Prime31.MiniJSON.jsonDecode( results );
			homeTimelineReceivedEvent( resultList );
		}
	}
	
	
	public void twitterRequestDidFinish( string results )
	{
		if( requestDidFinishEvent != null )
			requestDidFinishEvent( Prime31.MiniJSON.jsonDecode( results ) );
	}
	
	
	public void twitterRequestDidFail( string error )
	{
		if( requestDidFailEvent != null )
			requestDidFailEvent( error );
	}
	
	
	public void tweetSheetCompleted( string oneOrZero )
	{
		if( tweetSheetCompletedEvent != null )
			tweetSheetCompletedEvent( oneOrZero == "1" );
	}

#endif
}
