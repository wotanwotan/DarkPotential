//
//  AppDelegate.m
//  Dark Potential
//
//  Created by Joel Glanfield on 2012-11-01.
//  Copyright (c) 2012 Joel Glanfield. All rights reserved.
//

#import "DPAppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>

NSString* const FBSessionStateChangedNotification = @"com.miniwargaming.darkpotentialar:FBSessionStateChangedNotification";

@implementation DPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    // Override point for customization after application launch.
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar"]
//                                       forBarMetrics:UIBarMetricsDefault];
    
//    [[UINavigationBar appearance] setShadowImage:<#(UIImage *)#>]
    
//    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
    
    [self.window makeKeyAndVisible];
    
    [self playIntroVideo];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [FBSession.activeSession close];
}

- (void)playIntroVideo
{
//    NSURL *movieUrl = [[NSBundle mainBundle] URLForResource:@"MWGIntro" withExtension:@"m4v"];
    NSURL *movieUrl = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:@"MWGIntro" ofType:@"mp4"]];


    MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:movieUrl];

    // Hide the video controls
    moviePlayerViewController.moviePlayer.controlStyle = MPMovieControlStyleNone;
    
    // black background
    moviePlayerViewController.moviePlayer.backgroundView.backgroundColor = [UIColor blackColor];
    
    // Cross-dissolve transition.
    moviePlayerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(introVideoDidFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        
    [self.window.rootViewController presentViewController:moviePlayerViewController animated:NO completion:nil];
}

- (void)introVideoDidFinish
{    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"User session found");
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            NSLog(@"User session closed");
            break;
        default:
            NSLog(@"Something else has happened with the state");
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI
{   
    return [FBSession openActiveSessionWithReadPermissions:nil
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
}

/*
 * If we have a valid session at the time of openURL call, we handle
 * Facebook transitions by passing the url argument to handleOpenURL
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

@end
