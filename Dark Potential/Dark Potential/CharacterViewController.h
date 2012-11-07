//
//  CharacterViewController.h
//  Dark Potential
//
//  Created by Joel Glanfield on 2012-11-04.
//  Copyright (c) 2012 Joel Glanfield. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <AVFoundation/AVFoundation.h>

@class CharacterViewController;

@protocol CharacterViewClosedDelegate <NSObject>

- (void) characterViewDidClose:(CharacterViewController*)controller;

@end

@interface CharacterViewController : UIViewController
{
//    AVAudioPlayer* audioPlayer;
}

@property (nonatomic, strong) id <CharacterViewClosedDelegate> delegate;

- (IBAction)exitButtonPressed:(id)sender;

@end
