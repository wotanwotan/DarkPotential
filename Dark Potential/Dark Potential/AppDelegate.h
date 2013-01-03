//
//  AppDelegate.h
//  Dark Potential
//
//  Created by Joel Glanfield on 2012-11-01.
//  Copyright (c) 2012 Joel Glanfield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

extern NSString* const FBSessionStateChangedNotification;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    enum DPCharacter {
        DP_NONE,
        DP_XLANTHOS,
        DP_RECLAIMER
    };
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) enum DPCharacter currentCharacter;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;

@end
