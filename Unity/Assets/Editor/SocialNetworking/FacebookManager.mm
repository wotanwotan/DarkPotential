//
//  FacebookManager.m
//  Facebook
//
//  Created by Mike on 9/13/10.
//  Copyright 2010 Prime31 Studios. All rights reserved.
//

#import "FacebookManager.h"
#import <objc/runtime.h>
#import "JSONKit.h"
#import "TwitterManager.h" // to get the USE_UNITY_3_5 define


NSString* const kFacebookAppIdKey = @"kFacebookAppIdKey";
NSString* const kFacebookLibAccessToken = @"kFacebookLibAccessToken";
NSString* const kFacebookLibAccessTokenExpirationDate = @"kFacebookLibAccessTokenExpirationDate";


void UnitySendMessage( const char * className, const char * methodName, const char * param );

void UnityPause( bool pause );

#if USE_UNITY_3_5
UIViewController *UnityGetGLViewController();
#endif


@implementation FacebookManager

@synthesize appId = _appId, facebook;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSObject

+ (void)load
{
	[[NSNotificationCenter defaultCenter] addObserver:[self sharedManager]
											 selector:@selector(applicationDidFinishLaunching:)
												 name:UIApplicationDidFinishLaunchingNotification
											   object:nil];
}


+ (FacebookManager*)sharedManager
{
	static FacebookManager *sharedSingleton;
	
	if( !sharedSingleton )
		sharedSingleton = [[FacebookManager alloc] init];
	
	return sharedSingleton;
}


+ (BOOL)isFacebookComposerSupported
{
	return NSClassFromString( @"SLComposeViewController" ) != nil;
}


+ (BOOL)userCanUseFacebookComposer
{
	Class slComposer = NSClassFromString( @"SLComposeViewController" );
	if( slComposer && [slComposer performSelector:@selector(isAvailableForServiceType:) withObject:@"com.apple.social.facebook"] )
		return YES;
	return NO;
}


- (id)init
{
	if( ( self = [super init] ) )
	{
		// if we have an appId tucked away, set it now
		if( [[NSUserDefaults standardUserDefaults] objectForKey:kFacebookAppIdKey] )
			self.appId = [[NSUserDefaults standardUserDefaults] objectForKey:kFacebookAppIdKey];
	}
	return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSNotifications

- (void)applicationDidFinishLaunching:(NSNotification*)note
{
	// did we get launched with a userInfo dict?
	if( note.userInfo )
	{
		NSURL *url = [note.userInfo objectForKey:UIApplicationLaunchOptionsURLKey];
		if( url )
		{
			NSLog( @"recovered URL from jettisoned app. going to attempt login" );
			[self handleOpenURL:url];
		}
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Private/Internal

- (BOOL)handleOpenURL:(NSURL*)url
{
	NSLog( @"url used to open app: %@", url );
	BOOL res = [FBSession.activeSession handleOpenURL:url];
	
	return res;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - SLComposer

- (void)showFacebookComposerWithMessage:(NSString*)message image:(UIImage*)image link:(NSString*)link
{
#if USE_UNITY_3_5
	if( ![FacebookManager userCanUseFacebookComposer] )
		return;
	
	Class slComposerClass = NSClassFromString( @"SLComposeViewController" );
	UIViewController *slComposer = [slComposerClass performSelector:@selector(composeViewControllerForServiceType:) withObject:@"com.apple.social.facebook"];
	
	if( !slComposer )
		return;
	
	// Add a tweet message
	[slComposer performSelector:@selector(setInitialText:) withObject:message];
	
	// add an image
	if( image )
		[slComposer performSelector:@selector(addImage:) withObject:image];
	
	// add a link
	if( link )
		[slComposer performSelector:@selector(addURL:) withObject:[NSURL URLWithString:link]];
	
	// set a blocking handler for the tweet sheet
	[slComposer performSelector:@selector(setCompletionHandler:) withObject:^( NSInteger result )
	{
		UnityPause( false );
		[UnityGetGLViewController() dismissModalViewControllerAnimated:YES];
		
		if( result == 1 )
			UnitySendMessage( "FacebookManager", "facebookComposerCompleted", "1" );
		else if( result == 0 )
			UnitySendMessage( "FacebookManager", "facebookComposerCompleted", "0" );
	}];
	
	// Show the tweet sheet
	UnityPause( true );
	[UnityGetGLViewController() presentModalViewController:slComposer animated:YES];
#endif
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Public

- (void)setAppId:(NSString*)newAppId
{
	[_appId release];	
	_appId = [newAppId copy];
	
	// tuck this sucker in the NSUserDefaults to make SSO more robust
	[[NSUserDefaults standardUserDefaults] setObject:newAppId forKey:kFacebookAppIdKey];
	
	[FBSession setDefaultAppID:newAppId];
	
	if( [FBSession openActiveSessionWithAllowLoginUI:NO ] )
	{
		NSLog( @"Facebook session automatically started" );
		facebook = [[Facebook alloc] initWithAppId:FBSession.activeSession.appID andDelegate:nil];
		self.facebook.accessToken = FBSession.activeSession.accessToken;
		self.facebook.expirationDate = FBSession.activeSession.expirationDate;
	}
	else
	{
		NSLog( @"no Facebook session available" );
	}
}


- (BOOL)isLoggedIn
{
	return FBSession.activeSession.isOpen;
}


- (NSString*)accessToken
{
    return FBSession.activeSession.accessToken;
}


- (void)loginWithRequestedPermissions:(NSArray*)permissions urlSchemeSuffix:(NSString*)urlSchemeSuffix
{
	if( [self isLoggedIn] )
	{
		UnitySendMessage( "FacebookManager", "facebookLoginSucceeded", "" );
		return;
	}

	
	FBSession *facebookSession = [[FBSession alloc] initWithAppID:_appId permissions:permissions urlSchemeSuffix:urlSchemeSuffix tokenCacheStrategy:nil];
	[FBSession setActiveSession:facebookSession];
	[facebookSession openWithBehavior:FBSessionLoginBehaviorWithFallbackToWebView completionHandler:^( FBSession *sess, FBSessionState status, NSError *error )
	{
		if( FB_ISSESSIONOPENWITHSTATE( status ) )
		{
			// setup the old, deprecated Facebook object
			self.facebook = [[Facebook alloc] initWithAppId:FBSession.activeSession.appID andDelegate:nil];
			self.facebook.accessToken = FBSession.activeSession.accessToken;
			self.facebook.expirationDate = FBSession.activeSession.expirationDate;
			
			UnitySendMessage( "FacebookManager", "facebookLoginSucceeded", FBSession.activeSession.accessToken.UTF8String );
		}
		else
		{
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:kFacebookLibAccessToken];
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:kFacebookLibAccessTokenExpirationDate];
			[[NSUserDefaults standardUserDefaults] synchronize];

			UnitySendMessage( "FacebookManager", "facebookLoginDidFail", "" );
		}
	}];
}


- (void)logout
{
	[FBSession.activeSession closeAndClearTokenInformation];
	//[FBSession.activeSession close];
}


- (void)showDialog:(NSString*)dialogType withParms:(NSMutableDictionary*)dict
{
	// add the apiKey
	if( !dict )
		dict = [NSMutableDictionary dictionary];
	
	[dict setObject:_appId forKey:@"api_key"];
	[self.facebook dialog:dialogType andParams:dict andDelegate:self];
}


- (void)requestWithGraphPath:(NSString*)path httpMethod:(NSString*)method params:(NSMutableDictionary*)params
{
	[FBRequestConnection startWithGraphPath:path parameters:params HTTPMethod:method completionHandler:^( FBRequestConnection *conn, id result, NSError *error )
	{
		if( error )
		{
			UnitySendMessage( "FacebookManager", "facebookCustomRequestDidFail", [[error localizedDescription] UTF8String] );
		}
		else
		{
			NSString *json = nil;
			if( [result isKindOfClass:[NSDictionary class]] )
			{
				NSDictionary *dictionary = (NSDictionary*)result;
				json = [dictionary JSONString];
			}
			else if( [result isKindOfClass:[NSArray class]] )
			{
				NSArray *arr = (NSArray*)result;
				json = [arr JSONString];
			}
			UnitySendMessage( "FacebookManager", "facebookDidReceiveCustomRequest", json.UTF8String );
		}
	}];
}


- (void)requestWithRestMethod:(NSString*)restMethod httpMethod:(NSString*)method params:(NSMutableDictionary*)params
{
	FBRequest *req = [[[FBRequest alloc] initWithSession:FBSession.activeSession restMethod:restMethod parameters:params HTTPMethod:method] autorelease];
	FBRequestConnection *connection = [[FBRequestConnection alloc] init];
	[connection addRequest:req completionHandler:^( FBRequestConnection *conn, id result, NSError *error )
	{
		if( error )
		{
			UnitySendMessage( "FacebookManager", "facebookCustomRequestDidFail", [[error localizedDescription] UTF8String] );
		}
		else
		{
			NSString *json = nil;
			if( [result isKindOfClass:[NSDictionary class]] )
			{
				NSDictionary *dictionary = (NSDictionary*)result;
				json = [dictionary JSONString];
			}
			else if( [result isKindOfClass:[NSArray class]] )
			{
				NSArray *arr = (NSArray*)result;
				json = [arr JSONString];
			}
			UnitySendMessage( "FacebookManager", "facebookDidReceiveCustomRequest", json.UTF8String );
		}
		[conn autorelease];
	}];
	[connection start];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark FBDialogDelegate

- (void)dialogDidComplete:(FBDialog*)dialog
{
	UnitySendMessage( "FacebookManager", "facebookDialogDidComplete", "" );
}


- (void)dialogCompleteWithUrl:(NSURL*)url
{
	UnitySendMessage( "FacebookManager", "facebookDialogDidCompleteWithUrl", url.absoluteString.UTF8String );
}


- (void)dialogDidNotComplete:(FBDialog*)dialog
{
	UnitySendMessage( "FacebookManager", "facebookDialogDidNotComplete", "" );
}


- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError*)error
{
	NSLog( @"error description: %@", [error description] );
	NSLog( @"error userInfo: %@", [error userInfo] );
	
	UnitySendMessage( "FacebookManager", "facebookDialogDidFailWithError", [[error localizedDescription] UTF8String] );
}


@end





#import "AppController.h"


@implementation AppController(FacebookURLHandler)

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)url
{
	BOOL res = [[FacebookManager sharedManager] handleOpenURL:url];
	return res;
}


// For iOS 4.2+ support
- (BOOL)application:(UIApplication*)application
			openURL:(NSURL*)url
  sourceApplication:(NSString*)sourceApplication
		 annotation:(id)annotation
{
    BOOL res = [[FacebookManager sharedManager] handleOpenURL:url];
    return res;
}

@end


