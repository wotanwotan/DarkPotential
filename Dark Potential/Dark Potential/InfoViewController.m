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
@end
