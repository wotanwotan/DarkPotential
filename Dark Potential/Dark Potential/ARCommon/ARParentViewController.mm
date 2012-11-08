/*==============================================================================
 Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/

#import "ARParentViewController.h"
#import "ARViewController.h"
#import "OverlayViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "QCARutils.h"


@implementation ARParentViewController

@synthesize arViewRect;

- (void)setup{
    QCARutils *qUtils = [QCARutils getInstance];
    
    // Provide a list of targets we're expecting - the first in the list is the default
    [qUtils addTargetName:@"Stones & Chips" atPath:@"StonesAndChips.xml"];
    [qUtils addTargetName:@"Tarmac" atPath:@"Tarmac.xml"];
    
    arViewRect.size = [[UIScreen mainScreen] bounds].size;
    arViewRect.origin.x = arViewRect.origin.y = 0;
}

// initialisation functions set up size of managed view
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self setup];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setup];    }
    return self;    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"ARParentVC: initWithCoder");
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}


/*- (void) loadView
{
    NSLog(@"ARParentVC: creating");
    parentView = [[UIView alloc] initWithFrame:arViewRect];
    
    // Add the EAGLView and the overlay view to the window
    arViewController = [[ARViewController alloc] init];
    
    // need to set size here to setup camera image size for AR
    arViewController.arViewSize = arViewRect.size;
    [parentView addSubview:arViewController.view];
    
    // Create an auto-rotating overlay view and its view controller (used for
    // displaying UI objects, such as the camera control menu)
    overlayViewController = [[OverlayViewController alloc] init];
    [parentView addSubview: overlayViewController.view];
    
    UIButton* btn = [[UIButton alloc] init];
    [btn setTitle:@"Beans" forState:UIControlStateNormal];
    [parentView addSubview:btn];
    
    self.view = parentView;
}*/

- (void)viewDidLoad
{
    NSLog(@"ARParentVC: viewDidLoad");
    parentView = [[UIView alloc] initWithFrame:arViewRect];
    
    // Add the EAGLView and the overlay view to the window
    arViewController = [[ARViewController alloc] init];
    
    // need to set size here to setup camera image size for AR
    arViewController.arViewSize = arViewRect.size;
    [parentView addSubview:arViewController.view];
    
    // Create an auto-rotating overlay view and its view controller (used for
    // displaying UI objects, such as the camera control menu)
    overlayViewController = [[OverlayViewController alloc] init];
    
    // BEGIN: custom UI stuff (by Joel)
    
    // back button
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake (10, 10, 30, 30)];
    [backButton setTitle:@"X" forState:UIControlStateNormal];
    [backButton setTag:0];
//    [backButton setImage:[UIImage imageNamed:@"button-info.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    CALayer *btnLayer = [backButton layer];
    [btnLayer setCornerRadius:15.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor whiteColor] CGColor]];

    // torch button
    //if (YES == cameraCapabilities.torch)
    //{
        UIButton *torchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [torchButton setFrame:CGRectMake (50, 10, 30, 30)];
        [torchButton setTitle:@"T" forState:UIControlStateNormal];
        [torchButton setTag:1];
        //    [torchButton setImage:[UIImage imageNamed:@"button-info.png"] forState:UIControlStateNormal];
        [torchButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        btnLayer = [torchButton layer];
        [btnLayer setCornerRadius:15.0f];
        [btnLayer setBorderWidth:1.0f];
        [btnLayer setBorderColor:[[UIColor whiteColor] CGColor]];
    //}
    
    [overlayViewController.view addSubview:backButton];
    [overlayViewController.view addSubview:torchButton];
    // END: custom UI stuff
    
    [parentView addSubview: overlayViewController.view];
    
    UIButton* btn = [[UIButton alloc] init];
    [btn setTitle:@"Beans" forState:UIControlStateNormal];
    [parentView addSubview:btn];
    
    self.view = parentView;
    
    NSLog(@"ARParentVC: loading");
    // it's important to do this from here as arViewController has the wrong idea of orientation
    [arViewController handleARViewRotation:self.interfaceOrientation];
    // we also have to set the overlay view to the correct width/height for the orientation
    [overlayViewController handleViewRotation:self.interfaceOrientation];
    
//    [self.view addSubview:[self blahButton]];
//    [arViewController.view addSubview:[self tempButton]];
}

- (IBAction)buttonPressed:(id)sender
{
    NSLog(@"ARParentViewController: buttonPressed: %d", [sender tag]);
    switch ([sender tag])
    {
        case 0:
            [self dismissModalViewControllerAnimated:YES];
            break;
        case 1:
            QCARutils *qUtils = [QCARutils getInstance];
            BOOL newTorchMode = ![qUtils cameraTorchOn];
            [qUtils cameraSetTorchMode:newTorchMode];
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    /*if (parentView == nil)
    {
        NSLog(@"ARParentVC: creating");
        parentView = [[UIView alloc] initWithFrame:arViewRect];
        
        // Add the EAGLView and the overlay view to the window
        arViewController = [[ARViewController alloc] init];
        
        // need to set size here to setup camera image size for AR
        arViewController.arViewSize = arViewRect.size;
        [parentView addSubview:arViewController.view];
        
        // Create an auto-rotating overlay view and its view controller (used for
        // displaying UI objects, such as the camera control menu)
        overlayViewController = [[OverlayViewController alloc] init];
        [parentView addSubview: overlayViewController.view];
        
        // note the insertion of the view - we expect a root view, to be compliant with Storyboards
        // iOS povides a default root view if no loadView is provided
        [self.view insertSubview:parentView atIndex:0];
    }*/
    
    NSLog(@"ARParentVC: appearing");
    // make sure we're oriented/sized properly before reappearing/restarting
    [arViewController handleARViewRotation:self.interfaceOrientation];
    [overlayViewController handleViewRotation:self.interfaceOrientation];
    [arViewController viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated 
{
    NSLog(@"ARParentVC: appeared");
    [arViewController viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"ARParentVC: dissappeared");
    [arViewController viewDidDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Support all orientations
    return YES;
    
    // Support both portrait orientations
    //return (UIInterfaceOrientationPortrait == interfaceOrientation ||
    //        UIInterfaceOrientationPortraitUpsideDown == interfaceOrientation);

    // Support both landscape orientations
    //return (UIInterfaceOrientationLandscapeLeft == interfaceOrientation ||
    //        UIInterfaceOrientationLandscapeRight == interfaceOrientation);
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    // ensure overlay size and AR orientation is correct for screen orientation
    [overlayViewController handleViewRotation:self.interfaceOrientation];
    [arViewController handleARViewRotation:interfaceOrientation];
}


// touch handlers
/*- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    
    if (1 == [touch tapCount])
    {
        // Show camera control action sheet
        [overlayViewController showOverlay];
    }
}*/

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // iOS requires all events handled if touchesBegan is handled and not forwarded
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // iOS requires all events handled if touchesBegan is handled and not forwarded
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // iOS requires all events handled if touchesBegan is handled and not forwarded
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
@end
