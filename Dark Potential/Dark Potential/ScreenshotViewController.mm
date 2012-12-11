//
//  ScreenshotViewController.m
//  Dark Potential
//
//  Created by Joel Glanfield on 2012-11-08.
//  Copyright (c) 2012 Joel Glanfield. All rights reserved.
//

#import "ScreenshotViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ScreenshotViewController ()

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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view from its nib.
    
    [self.screenshotImageView setImage:screenshotImage];
    [self.screenshotImageView.layer setCornerRadius:10.0];
    [self.screenshotImageView.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [self.screenshotImageView.layer setBorderWidth: 3.0];
    [self.screenshotImageView.layer setMasksToBounds:YES];
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
@end
