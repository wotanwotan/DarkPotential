//
//  ViewController.h
//  Dark Potential
//
//  Created by Joel Glanfield on 2012-11-01.
//  Copyright (c) 2012 Joel Glanfield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DPConstants.h"
#import "DPCharacterViewController.h"

@interface DPMainMenuViewController : UIViewController<AVAudioPlayerDelegate,DPCharacterViewClosedDelegate>

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (nonatomic) enum DPCharacter currentCharacter;
@property (strong, nonatomic) IBOutlet UIButton *experienceBtn1;
@property (strong, nonatomic) IBOutlet UIButton *experienceBtn2;
@property (strong, nonatomic) IBOutlet UIButton *experienceBtn3;

- (IBAction)experienceButtonPressed:(id)sender;

@end