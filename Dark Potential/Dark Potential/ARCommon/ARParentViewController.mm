/*==============================================================================
 Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/

#import "ARParentViewController.h"
#import "ARViewController.h"
#import "OverlayViewController.h"
#import "DPScreenshotViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "QCARutils.h"
#import "EAGLView.h"
#import "DPARViewCameraButtonCustomizer.h"
#import "DPARViewTorchButtonCustomizer.h"
#import "DPARViewBackButtonCustomizer.h"
#import <AVFoundation/AVFoundation.h>


@implementation ARParentViewController

@synthesize arViewRect;

- (void)setup{
    QCARutils *qUtils = [QCARutils getInstance];
    
    // Provide a list of targets we're expecting - the first in the list is the default
    [qUtils addTargetName:@"Stones & Chips" atPath:@"StonesAndChips.xml"];
//    [qUtils addTargetName:@"Tarmac" atPath:@"Tarmac.xml"];
//    [qUtils addTargetName:@"XlanthosSSTop" atPath:@"Dark_Potential.xml"];
    [qUtils addTargetName:@"ReclaimerSSTop" atPath:@"Dark_Potential.xml"];
    
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
    [backButton setFrame:CGRectMake (10, 10, 36, 36)];
    [backButton setTag:0];
    [backButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [[DPARViewBackButtonCustomizer alloc] initWithButton:backButton];

    
    // torch button - if available
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    UIButton *torchButton = nil;
    if ([device hasTorch])
    {
        torchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [torchButton setFrame:CGRectMake (200, 10, 36, 36)];
        [torchButton setTag:1];
        [torchButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [[DPARViewTorchButtonCustomizer alloc] initWithButton:torchButton];
    }
    
    // camera button
    UIButton *camButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [camButton setFrame:CGRectMake (270, 10, 36, 36)];
    [camButton setTag:2];
    [camButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [[DPARViewCameraButtonCustomizer alloc] initWithButton:camButton];
    
    [overlayViewController.view addSubview:backButton];
    if (torchButton)
        [overlayViewController.view addSubview:torchButton];
    
    [overlayViewController.view addSubview:camButton];
    // END: custom UI stuff
    
    [parentView addSubview: overlayViewController.view];
    
    UIButton* btn = [[UIButton alloc] init];
    [btn setTitle:@"Beans" forState:UIControlStateNormal];
    [parentView addSubview:btn];
    
    self.view = parentView;
    
    // it's important to do this from here as arViewController has the wrong idea of orientation
    [arViewController handleARViewRotation:self.interfaceOrientation];
    // we also have to set the overlay view to the correct width/height for the orientation
    [overlayViewController handleViewRotation:self.interfaceOrientation];
    
    [[arViewController arView] setDelegate:self];
}

- (IBAction)buttonPressed:(id)sender
{
    NSLog(@"ARParentViewController: buttonPressed: %d", [sender tag]);
    switch ([sender tag])
    {
        case 0:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case 1:
        {
            QCARutils *qUtils = [QCARutils getInstance];
            BOOL newTorchMode = ![qUtils cameraTorchOn];
            [qUtils cameraSetTorchMode:newTorchMode];
            break;
        }
        case 2:
        {
            [[arViewController arView] setShouldTakeScreenshot:YES];
            break;
        }
    }
}

- (void) takeScreenshot
{
    UIImage *screenshotImage = [self glToUIImage];
    
    // now, show the photo-share view
    DPScreenshotViewController *pictureView;
    
//    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"])
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        pictureView = [[DPScreenshotViewController alloc] initWithNibName:@"DPScreenshotViewController-iPad" bundle:nil];
    else
        pictureView = [[DPScreenshotViewController alloc] initWithNibName:@"DPScreenshotViewController" bundle:nil];
    
    [pictureView setScreenshotImage:screenshotImage];
    
    QCARutils *qUtils = [QCARutils getInstance];
    [qUtils pauseAR];
    
    [self presentViewController:pictureView animated:YES completion:nil];
}

- (void) screenshotWasTaken:(UIImage*)theScreenshot
{    
    [self takeScreenshot];
}

- (UIImage*) glToUIImage
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGRect s;
    
    // need to swap width/height because Vuforia assumes landscape but the app is portrait
    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"])
        s = CGRectMake(0, 0, 1024.0f * scale, (768.0f) * scale);
    else
        s = CGRectMake(0, 0, 480.0f * scale, (320.0f) * scale);
    
    uint8_t *buffer = (uint8_t *) malloc(s.size.width * s.size.height * 4);
    
    glReadPixels(0, 0, s.size.width, s.size.height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    
    CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, buffer, s.size.width * s.size.height * 4, NULL);
    
    CGImageRef iref = CGImageCreate(s.size.width, s.size.height, 8, 32, s.size.width * 4, CGColorSpaceCreateDeviceRGB(),
                                    kCGBitmapByteOrderDefault, ref, NULL, true, kCGRenderingIntentDefault);
    
    size_t width = CGImageGetWidth(iref);
    size_t height = CGImageGetHeight(iref);
    size_t length = width * height * 4;
    uint32_t *pixels = (uint32_t *)malloc(length);
    
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * 4,
                                                 CGImageGetColorSpace(iref), kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Big);

    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), iref);
    CGImageRef outputRef = CGBitmapContextCreateImage(context);
    UIImage* tempImage = [[UIImage alloc] initWithCGImage:outputRef scale:(CGFloat)1.0 orientation:UIImageOrientationLeftMirrored];
  
    // need to redraw in context so that the thumbnail in the photo album is correct
    CGRect rect = CGRectMake(0,0,height,width);
    UIGraphicsBeginImageContext(rect.size);
    [tempImage drawInRect:rect];
    UIImage* outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGDataProviderRelease(ref);
    CGImageRelease(iref);
    CGContextRelease(context);
    CGImageRelease(outputRef);
    free(pixels);
    free(buffer);
    
    NSLog(@"Screenshot size: %d, %d", (int)[outputImage size].width, (int)[outputImage size].height);

    return outputImage;
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
    
    arViewController.currentCharacter = self.currentCharacter;
    
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
