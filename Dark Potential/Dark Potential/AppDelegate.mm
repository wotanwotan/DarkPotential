//
//  AppDelegate.m
//  Dark Potential
//
//  Created by Joel Glanfield on 2012-11-01.
//  Copyright (c) 2012 Joel Glanfield. All rights reserved.
//

#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation AppDelegate

@synthesize currentCharacter;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    // Override point for customization after application launch.
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
    
    currentCharacter = DP_NONE;
    
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)playIntroVideo
{    
    //    NSLog( [NSString stringWithFormat:@"**** Video Path: %@", [[NSBundle mainBundle] idomaticPathForResource:@"SeedIntro" ofType:@"mp4"]]);
    NSURL *movieUrl = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:@"MWGIntro" ofType:@"mp4"]];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (screenSize.height > 480.0f) {
            movieUrl = nil;
            movieUrl = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:@"MWGIntro"/*SeedIntro-568h@2x"*/ ofType:@"mp4"]];
        }
    }
    
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    //        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    //        if (screenSize.height > 768.0f) {
    //            movieUrl = nil;
    //            movieUrl = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:@"SeedIntro@2x~ipad" ofType:@"mp4"]];
    //        }
    //    }
    MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:movieUrl];

    // Hide the video controls
    moviePlayerViewController.moviePlayer.controlStyle = MPMovieControlStyleNone;
    
    // black background
    moviePlayerViewController.moviePlayer.backgroundView.backgroundColor = [UIColor blackColor];
    
/*    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (screenSize.height > 480.0f) {
            moviePlayerViewController.moviePlayer.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Default-568h@2x" ofType:@"png"]]];
            
        }
    }*/
    
    // Cross-dissolve transition.
    moviePlayerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(introVideoDidFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [self.window.rootViewController presentModalViewController:moviePlayerViewController animated:NO];
}

- (void)introVideoDidFinish
{    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
//    [self.window.rootViewController dismissModalViewControllerAnimated:YES];
}

@end
