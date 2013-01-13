//
//  InfoViewController.h
//  Dark Potential
//
//  Created by Joel Glanfield on 2012-11-02.
//  Copyright (c) 2012 Joel Glanfield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface InfoViewController : UIViewController<MFMailComposeViewControllerDelegate>

//@property (strong, nonatomic) IBOutlet UIButton *playVideoButton;


@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;

- (IBAction)playVideoButtonPressed:(id)sender;
- (IBAction)exitButtonPressed:(id)sender;
- (IBAction)launchWebView:(id)sender;
- (IBAction)emailSupportButtonPressed:(id)sender;

@end
