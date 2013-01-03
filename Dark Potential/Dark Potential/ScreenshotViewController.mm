//
//  ScreenshotViewController.m
//  Dark Potential
//
//  Created by Joel Glanfield on 2012-11-08.
//  Copyright (c) 2012 Joel Glanfield. All rights reserved.
//

#import "ScreenshotViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Twitter/Twitter.h>


@interface ScreenshotViewController ()
{
    UIActivityIndicatorView* activityView;
}
@end

@implementation ScreenshotViewController

@synthesize screenshotImage, screenshotImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    [self.screenshotImageView setImage:screenshotImage];
    [self.screenshotImageView.layer setCornerRadius:10.0];
    [self.screenshotImageView.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [self.screenshotImageView.layer setBorderWidth: 3.0];
    [self.screenshotImageView.layer setMasksToBounds:YES];
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityView setCenter:CGPointMake(320.0/2.0, 480.0/2.0)]; // I do this because I'm in landscape mode
    [self.view addSubview:activityView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view from its nib.
    
    [self setScreenshotImage:[screenshotImageView image]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    screenshotImage = nil;
}

- (IBAction)exitButtonPressed:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark Save

- (IBAction)saveButtonPressed:(id)sender
{
    [activityView startAnimating];
    
    UIImageWriteToSavedPhotosAlbum(screenshotImage, self, @selector(photo:didFinishSavingWithError:contextInfo:), nil);
}

- (void)photo:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo;
{
    [activityView stopAnimating];
    
    UIAlertView *alertView = [UIAlertView alloc];
    if (error)
    {
        alertView = [[UIAlertView alloc]
                     initWithTitle:@"Error" message:error.localizedDescription
                     delegate:nil
                     cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    else
    {
        alertView = [[UIAlertView alloc]
                     initWithTitle:@"Action Completed"
                     message:@"Picture Saved!"
                     delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
    }
    
    [alertView show];
}

#pragma mark Email

- (IBAction)mailButtonPressed:(id)sender
{
    if (![MFMailComposeViewController canSendMail])
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Email"
                                  message:@"No email accounts are set up on this device!"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        
        return;
    }
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"Dark Potential AR picture"];
    [picker addAttachmentData:UIImagePNGRepresentation(screenshotImage) mimeType:@"image/png" fileName:@"image.png"];
    
    // Fill out the email body text
    NSString *emailBody = @"Check out my Dark Potential AR picture!";
    [picker setMessageBody:emailBody isHTML:NO];
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    UIAlertView *alertView = [UIAlertView alloc];
    
    if (error)
    {
        alertView = [[UIAlertView alloc]
                     initWithTitle:@"Error" message:error.localizedDescription
                     delegate:nil
                     cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else if (result == MFMailComposeResultSent)
    {
        alertView = [[UIAlertView alloc]
                     initWithTitle:@"Action Completed"
                     message:@"Picture Sent!"
                     delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
        
        [alertView show];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Twitter

- (IBAction)twitterButtonPressed:(id)sender
{
    // Set up the built-in twitter composition view controller.
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    
    // Set the initial tweet text. See the framework for additional properties that can be set.
    [tweetViewController setInitialText:@"Check out my #DarkPotential AR app picture!"];
    [tweetViewController addImage:self.screenshotImage];
    
    // Create the completion handler block.
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        NSString *output;
        
        switch (result) {
            case TWTweetComposeViewControllerResultCancelled:
                // The cancel button was tapped.
                output = @"Tweet cancelled.";
                break;
            case TWTweetComposeViewControllerResultDone:
                // The tweet was sent.
                output = @"Tweet done.";
                break;
            default:
                break;
        }
        
        //        [self performSelectorOnMainThread:@selector(displayText:) withObject:output waitUntilDone:NO];
        
        // Dismiss the tweet composition view controller.
        [self dismissModalViewControllerAnimated:YES];
    }];
    
    // Present the tweet composition view controller modally.
    [self presentViewController:tweetViewController animated:YES completion:nil];
}

@end
