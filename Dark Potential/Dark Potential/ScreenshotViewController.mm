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
#import "AppDelegate.h"


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
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    screenshotImage = nil;
}

- (IBAction)exitButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    SLComposeViewController *tweetViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    // Set the initial tweet text. See the framework for additional properties that can be set.
    [tweetViewController setInitialText:@"Check out my #DarkPotential AR app picture!"];
    [tweetViewController addImage:self.screenshotImage];
    
    // Create the completion handler block.
    [tweetViewController setCompletionHandler:^(SLComposeViewControllerResult result) {
/*        NSString *output;
        
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                // The cancel button was tapped.
                output = @"Tweet cancelled.";
                break;
            case SLComposeViewControllerResultDone:
                // The tweet was sent.
                output = @"Tweet done.";
                break;
            default:
                break;
        }
*/        
        // Dismiss the tweet composition view controller.
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    // Present the tweet composition view controller modally.
    [self presentViewController:tweetViewController animated:YES completion:nil];
}

#pragma mark Facebook

- (IBAction)facebookButtonPressed:(id)sender
{
    // if iOS6, then just use the composer (if the user set up FB in the settings)
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
    {
        NSLog(@"iOS6");
        // Set up the built-in twitter composition view controller.
        SLComposeViewController *fbViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        // Set the initial tweet text. See the framework for additional properties that can be set.
        [fbViewController setInitialText:@"Check out my #DarkPotential AR app picture!"];
        [fbViewController addImage:self.screenshotImage];
        
        // Create the completion handler block.
        [fbViewController setCompletionHandler:^(SLComposeViewControllerResult result) {
/*            NSString *output;
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    // The cancel button was tapped.
                    output = @"FB cancelled.";
                    break;
                case SLComposeViewControllerResultDone:
                    // The tweet was sent.
                    output = @"FB done.";
                    break;
                default:
                    break;
            }
*/
            // Dismiss the tweet composition view controller.
//            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        // Present the tweet composition view controller modally.
        [self presentViewController:fbViewController animated:YES completion:nil];
    }
    
    // otherwise, resort to using the app (or browser) ...
    else
    {    
        // open a session if we don't have one already
        if (!FBSession.activeSession.isOpen)
        {
            AppDelegate* appDel = [[UIApplication sharedApplication] delegate];
            [appDel openSessionWithAllowLoginUI:YES];
        }
        
        // otherwise, check if we have publish permissions
        else if (![FBSession.activeSession.permissions containsObject:@"publish_actions"])
        {
            // get publishing permissions
            NSArray* permissions = [[NSArray alloc] initWithObjects:@"publish_actions", nil];
            [FBSession.activeSession reauthorizeWithPublishPermissions:permissions
                                                       defaultAudience:FBSessionDefaultAudienceFriends
                                                     completionHandler:^(FBSession *session,
                                                                         NSError *error) {
                                                         NSLog(@"done getting publish permissions");
                                                     }];
        }
        
        // otherwise, just post the photo
        else
        {
            [self postPhotoToFacebook];
        }
    }

}

- (void)sessionStateChanged:(NSNotification*)notification
{
    // if we have an open session, then ask for publish permissions
    if (FBSession.activeSession.isOpen)
    {
        NSLog(@"Do we have publish permissions?");
        NSArray* permissions = FBSession.activeSession.permissions;
        bool canPublish = [permissions containsObject:@"publish_actions"];
        
        if (!canPublish)
        {
            NSLog(@"No. Get PUBLISHING permissions!!");

            permissions = [[NSArray alloc] initWithObjects:@"publish_actions", nil];
            [FBSession.activeSession reauthorizeWithPublishPermissions:permissions
                                                       defaultAudience:FBSessionDefaultAudienceFriends
                                                     completionHandler:^(FBSession *session,
                                                                         NSError *error) {
                                                     NSLog(@"DONE getting publish permissions");

                                                 }];
        }
        else
        {
            NSLog(@"Yes. Post the photo.");
            // try to publish the photo
            [self postPhotoToFacebook];
        }
    }
}

- (void) postPhotoToFacebook
{
    UIImage *img = [screenshotImageView image];
    
/*    // if it is available to us, we will post using the native dialog
    BOOL displayedNativeDialog =
        [FBNativeDialogs presentShareDialogModallyFrom:self initialText:@"Check out my Dark Potential AR pic!" image:img url:nil handler:nil];
    
    if (!displayedNativeDialog)*/
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Posting photo..." message:@"" delegate:nil
                                                  cancelButtonTitle:nil otherButtonTitles:nil];
        UIActivityIndicatorView *progress= [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 50, 30, 30)];
        progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        
        [alertView addSubview:progress];
        [progress startAnimating];
        [alertView show];
        
        NSLog(@"No access to native dialog, so we just post...");
        
        FBRequestConnection *connection = [[FBRequestConnection alloc] init];
        FBRequest *request = [FBRequest requestForUploadPhoto:img];
        
        [connection addRequest:request completionHandler:
         ^(FBRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"Photo posted successfully!");
                 UIAlertView *alertView = [[UIAlertView alloc]
                                           initWithTitle:@"Facebook"
                                           message:@"Photo posted successfully!"
                                           delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
                 [alertView show];
             }
             else
                 NSLog(@"Error: %@", [error localizedDescription]);
             
             [progress stopAnimating];
             [alertView dismissWithClickedButtonIndex:0 animated:YES];
         }
                batchEntryName:@"photopost"
         ];
        
        [connection start];
    }
}

@end
