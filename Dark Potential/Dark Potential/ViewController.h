//
//  ViewController.h
//  Dark Potential
//
//  Created by Joel Glanfield on 2012-11-01.
//  Copyright (c) 2012 Joel Glanfield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CharacterViewController.h"

@interface ViewController : UIViewController<AVAudioPlayerDelegate,CharacterViewClosedDelegate>
{
    int currentButtonToAnimate;
    int numButtonsToAnimate;
    NSArray* animatedButtons;
}

@property (strong, nonatomic) IBOutlet UIButton *experienceBtn1;
@property (strong, nonatomic) IBOutlet UIButton *experienceBtn2;
@property (strong, nonatomic) IBOutlet UIButton *experienceBtn3;
@property (strong, nonatomic) IBOutlet UIButton *mwgLogo;

- (IBAction)launchMWGWebsite:(id)sender;
- (IBAction)experienceButtonPressed:(id)sender;


@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end
