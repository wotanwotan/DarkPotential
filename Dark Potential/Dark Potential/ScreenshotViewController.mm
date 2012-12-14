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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view from its nib.
    
    [self.screenshotImageView setImage:screenshotImage];
    [self.screenshotImageView.layer setCornerRadius:10.0];
    [self.screenshotImageView.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [self.screenshotImageView.layer setBorderWidth: 3.0];
    [self.screenshotImageView.layer setMasksToBounds:YES];
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityView setCenter:CGPointMake(320.0/2.0, 480.0/2.0)]; // I do this because I'm in landscape mode
    [self.view addSubview:activityView];
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

- (IBAction)saveButtonPressed:(id)sender
{
    [activityView startAnimating];
    
    UIImageWriteToSavedPhotosAlbum(screenshotImage, self, @selector(photo:didFinishSavingWithError:contextInfo:), nil);
}

- (void)photo:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo;
{
    if (error)
        NSLog(@"Error saving to photo album.");
    else
        NSLog(@"Success!");
    
    [activityView stopAnimating];
}
@end
