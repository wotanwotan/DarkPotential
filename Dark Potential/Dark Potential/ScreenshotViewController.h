//
//  ScreenshotViewController.h
//  Dark Potential
//
//  Created by Joel Glanfield on 2012-11-08.
//  Copyright (c) 2012 Joel Glanfield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ScreenshotViewController : UIViewController<MFMailComposeViewControllerDelegate>
{

}

@property (strong, nonatomic) IBOutlet UIImageView *screenshotImageView;
@property (strong, nonatomic) UIImage* screenshotImage;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;


- (IBAction)exitButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)mailButtonPressed:(id)sender;
- (IBAction)twitterButtonPressed:(id)sender;
- (IBAction)facebookButtonPressed:(id)sender;

@end
