//
//  CharacterViewController.h
//  Dark Potential
//
//  Created by Joel Glanfield on 2012-11-04.
//  Copyright (c) 2012 Joel Glanfield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPConstants.h"
//#import <AVFoundation/AVFoundation.h>

@class DPCharacterViewController;

@protocol DPCharacterViewClosedDelegate <NSObject>

- (void) characterViewDidClose:(DPCharacterViewController*)controller;

@end

@interface DPCharacterViewController : UIViewController
{
//    AVAudioPlayer* audioPlayer;
}

- (IBAction)exitButtonPressed:(id)sender;

@property (nonatomic, strong) id <DPCharacterViewClosedDelegate> delegate;
@property (nonatomic) enum DPCharacter currentCharacter;
@property (strong, nonatomic) IBOutlet UITextView *bioTextView;
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) IBOutlet UIButton *launchARButton;


@end
