//
//  ViewController.h
//  Dark Potential
//
//  Created by Joel Glanfield on 2012-11-01.
//  Copyright (c) 2012 Joel Glanfield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController<AVAudioPlayerDelegate>
{
    int currentButtonToAnimate;
    int numButtonsToAnimate;
    NSArray* animatedButtons;
}

@property (weak, nonatomic) IBOutlet UIButton *experienceBtn1;
@property (weak, nonatomic) IBOutlet UIButton *experienceBtn2;
@property (weak, nonatomic) IBOutlet UIButton *experienceBtn3;
@property (weak, nonatomic) IBOutlet UIButton *mwgLogo;

- (IBAction)launchDPWebsite:(id)sender;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end
