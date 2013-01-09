//
//  InfoViewController.m
//  Dark Potential
//
//  Created by Joel Glanfield on 2012-11-02.
//  Copyright (c) 2012 Joel Glanfield. All rights reserved.
//

#import "InfoViewController.h"
#import "WebViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>

@interface InfoViewController ()

@end

@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
/*    CALayer *layer = self.supportButton.layer;
    layer.backgroundColor = [[UIColor clearColor] CGColor];
    layer.borderColor = [[UIColor darkGrayColor] CGColor];
    layer.borderWidth = 1.0f;*/
    
    CALayer *layer = self.playVideoButton.layer;
//    layer.backgroundColor = [[UIColor clearColor] CGColor];
    layer.borderColor = [[UIColor darkGrayColor] CGColor];
    layer.cornerRadius = 8.0f;
    layer.borderWidth = 2.0f;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playVideoButtonPressed:(id)sender
{
    [[UINavigationBar appearance] setBackgroundImage:nil
                                       forBarMetrics:UIBarMetricsDefault];
    
    NSString *videoURLString = @"http://miniwargaming.s3.amazonaws.com/The-Vault/DVDs/TutorialFlesh/Fleshdark1.mp4";
    NSURL *videoURL = [NSURL URLWithString:videoURLString];
    
    MPMoviePlayerViewController *movieView = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    
    [self presentMoviePlayerViewControllerAnimated:movieView];
}

- (IBAction)exitButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)launchWebView:(id)sender
{
    WebViewController *webView;
    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"])
        webView = [[WebViewController alloc] initWithNibName:@"WebViewController-iPad" bundle:nil];
    else
        webView = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    
    switch ([sender tag])
    {
        case 0:
            [webView setWebPageURL:@"http://www.darkpotential.com"];
            break;
        case 1:
            [webView setWebPageURL:@"https://www.facebook.com/DarkPotential"];
            break;
        case 2:
            [webView setWebPageURL:@"https://twitter.com/miniwargaming"];
            break;
        case 3:
            [webView setWebPageURL:@"http://www.youtube.com/miniwargaming"];
            break;
        case 4:
            [webView setWebPageURL:@"http://www.stephaniemunn.com"];
            break;
        case 5:
            [webView setWebPageURL:@"http://www.joelglanfield.com"];
            break;
    }
    
    [self presentViewController:webView animated:YES completion:nil];
}

- (IBAction)emailSupportButtonPressed:(id)sender
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
    
    [picker setToRecipients:[NSArray arrayWithObjects:@"apps@miniwargaming.com", nil]];
    [picker setSubject:@"Dark Potential AR Support"];
    
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
