//
//  ViewController.m
//  Dark Potential
//
//  Created by Joel Glanfield on 2012-11-01.
//  Copyright (c) 2012 Joel Glanfield. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    [[UINavigationBar appearance] setTitleView:logoView];
    
    UIButton *logoView = [[UIButton alloc] initWithFrame:CGRectMake(0,0,85,40)];
    [logoView setBackgroundImage:[UIImage imageNamed:@"dp-logo.png"] forState:UIControlStateNormal];
    [logoView setUserInteractionEnabled:NO];
    
    self.navigationItem.titleView = logoView;

    if ([self.navigationController.navigationBar
         respondsToSelector:@selector(shadowImage)]) {
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    }

}

- (IBAction)launchDPWebsite:(id)sender
{
    NSURL *url = [ [ NSURL alloc ] initWithString: @"http://www.darkpotential.com" ];
    
    [[UIApplication sharedApplication] openURL:url];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
