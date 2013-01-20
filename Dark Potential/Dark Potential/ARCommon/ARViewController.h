/*==============================================================================
 Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/

#import <UIKit/UIKit.h>
#import "DPConstants.h"

@class EAGLView, QCARutils;

@interface ARViewController : UIViewController {
@public
    IBOutlet EAGLView *arView;  // the Augmented Reality view
    CGSize arViewSize;          // required view size

@private
    QCARutils *qUtils;          // QCAR utils singleton class
    UIView *parentView;         // Avoids unwanted interactions between UIViewController and EAGLView
    NSMutableArray* textures;   // DP-model 2D textures
    BOOL arVisible;             // State of visibility of the view
}

@property (nonatomic, strong) IBOutlet EAGLView *arView;
@property (nonatomic) CGSize arViewSize;
@property (nonatomic) enum DPCharacter currentCharacter;
           
- (void) handleARViewRotation:(UIInterfaceOrientation)interfaceOrientation;


@end
