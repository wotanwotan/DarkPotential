//
//  ScreenshotViewController.h
//  Dark Potential
//
//  Created by Joel Glanfield on 2012-11-08.
//  Copyright (c) 2012 Joel Glanfield. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenshotViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *screenshotImageView;
@property (strong, nonatomic) UIImage* screenshotImage;

- (IBAction)exitButtonPressed:(id)sender;

@end
