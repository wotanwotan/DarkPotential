//
//  InfoViewController.m
//  Dark Potential
//
//  Created by Joel Glanfield on 2012-11-02.
//  Copyright (c) 2012 Joel Glanfield. All rights reserved.
//

#import "InfoViewController.h"
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
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)launchJGWebsite:(id)sender
{
    NSURL *url = [ [ NSURL alloc ] initWithString: @"http://www.joelglanfield.com" ];
    
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)launchSMWebsite:(id)sender
{
    NSURL *url = [ [ NSURL alloc ] initWithString: @"http://www.stephaniemunn.com" ];
    
    [[UIApplication sharedApplication] openURL:url];
}
@end
