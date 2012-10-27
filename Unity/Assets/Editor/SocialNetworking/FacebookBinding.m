//
//  FacebookBinding.m
//  Facebook
//
//  Created by Mike on 9/13/10.
//  Copyright 2010 Prime31 Studios. All rights reserved.
//

#import "FacebookManager.h"
#import "JSONKit.h"


// Converts NSString to C style string by way of copy (Mono will free it)
#define MakeStringCopy( _x_ ) ( _x_ != NULL && [_x_ isKindOfClass:[NSString class]] ) ? strdup( [_x_ UTF8String] ) : NULL

// Converts C style string to NSString
#define GetStringParam( _x_ ) ( _x_ != NULL ) ? [NSString stringWithUTF8String:_x_] : [NSString stringWithUTF8String:""]

// Converts C style string to NSString as long as it isnt empty
#define GetStringParamOrNil( _x_ ) ( _x_ != NULL && strlen( _x_ ) ) ? [NSString stringWithUTF8String:_x_] : nil


void _facebookInit( const char * appId )
{
	[FacebookManager sharedManager].appId = GetStringParam( appId );
}


bool _facebookIsLoggedIn()
{
	return [[FacebookManager sharedManager] isLoggedIn];
}


const char * _facebookGetFacebookAccessToken()
{
	return MakeStringCopy( [[FacebookManager sharedManager] accessToken] );
}


void _facebookLoginWithRequestedPermissions( const char * perms, const char * urlSchemeSuffix )
{
	NSString *permsString = GetStringParam( perms );
	NSArray *permissions = [permsString componentsSeparatedByString:@","];
	
	[[FacebookManager sharedManager] loginWithRequestedPermissions:permissions
												   urlSchemeSuffix:GetStringParam( urlSchemeSuffix )];
}


void _facebookLogout()
{
	[[FacebookManager sharedManager] logout];
}


void _facebookShowDialog( const char * dialogType, const char * json )
{
	// make sure we have a legit dictionary
	NSString *jsonString = GetStringParamOrNil( json );
	NSMutableDictionary *dict = nil;
	
	if( jsonString && [jsonString isKindOfClass:[NSString class]] && jsonString.length )
		dict = [[jsonString objectFromJSONString] mutableCopy];
	
	[[FacebookManager sharedManager] showDialog:GetStringParam( dialogType ) withParms:dict];
}


void _facebookRestRequest( const char * restMethod, const char * httpMethod, const char * jsonDict )
{
	// make sure we have a legit dictionary
	NSString *jsonString = GetStringParam ( jsonDict );
	NSMutableDictionary *dict = [jsonString mutableObjectFromJSONString];
	
	if( ![dict isKindOfClass:[NSMutableDictionary class]] )
		return;
	
	[[FacebookManager sharedManager] requestWithRestMethod:GetStringParam( restMethod )
												httpMethod:GetStringParam( httpMethod )
													params:dict];
}


void _facebookGraphRequest( const char * graphPath, const char * httpMethod, const char * jsonDict )
{
	// make sure we have a legit dictionary
	NSString *jsonString = GetStringParam ( jsonDict );
	NSMutableDictionary *dict = [jsonString objectFromJSONString];
	
	if( ![dict isKindOfClass:[NSMutableDictionary class]] )
		return;
	
	[[FacebookManager sharedManager] requestWithGraphPath:GetStringParam( graphPath )
											   httpMethod:GetStringParam( httpMethod )
												   params:dict];
}



// Facebook Composer methods
bool _facebookIsFacebookComposerSupported()
{
	return [FacebookManager isFacebookComposerSupported];
}


bool _facebookCanUserUseFacebookComposer()
{
	return [FacebookManager userCanUseFacebookComposer];
}


void _facebookShowFacebookComposer( const char * message, const char * imagePath, const char * link )
{
	NSString *path = GetStringParamOrNil( imagePath );
	UIImage *image = nil;
	if( [[NSFileManager defaultManager] fileExistsAtPath:path] )
		image = [UIImage imageWithContentsOfFile:path];
	
	[[FacebookManager sharedManager] showFacebookComposerWithMessage:GetStringParam( message ) image:image link:GetStringParamOrNil( link )];
}


