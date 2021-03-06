/*==============================================================================
 Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/

#import <UIKit/UIKit.h>
#import "AR_EAGLView.h"
#import "DPConstants.h"

@class ARViewController, OverlayViewController;

@interface ARParentViewController : UIViewController<ScreenshotWasTakenDelegate> {
    OverlayViewController* overlayViewController; // for the overlay view (buttons and action sheets)
    ARViewController* arViewController; // for the Augmented Reality view
    UIView *parentView; // a container view to allow use in tabbed views etc.
    
    CGRect arViewRect; // the size of the AR view
}

@property (nonatomic) CGRect arViewRect;
@property (nonatomic) enum DPCharacter currentCharacter;

@end
