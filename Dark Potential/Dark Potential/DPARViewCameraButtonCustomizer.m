//
//  DPARViewCameraButton.m
//  Dark Potential
//
//  Created by Joel Glanfield on 2013-01-21.
//  Copyright (c) 2013 Joel Glanfield. All rights reserved.
//

#import "DPARViewCameraButtonCustomizer.h"

@implementation DPARViewCameraButtonCustomizer

-(id)initWithButton:(UIButton *)theButton
{
    return [super initWithButton:theButton];
}

- (void)drawNormalState
{
    [self drawButton:NO];
}
- (void)drawHighlightedState
{
    [self drawButton:YES];
}

- (void)drawButton:(BOOL)isHighlighted
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 0.31 green: 0.31 blue: 0.31 alpha: 1];
    
    //// Shadow Declarations
    UIColor* shadow = isHighlighted ? [UIColor lightTextColor] : color;
    CGSize shadowOffset = CGSizeMake(2.1, 2.1);
    CGFloat shadowBlurRadius = 1;
    
    //// Group
    {
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
        
        CGContextBeginTransparencyLayer(context, NULL);
        
        
        //// Rounded Rectangle 3 Drawing
        UIBezierPath* roundedRectangle3Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(5.5, 7.5, 5, 3) cornerRadius: 1.5];
        [[UIColor whiteColor] setFill];
        [roundedRectangle3Path fill];
        [[UIColor blackColor] setStroke];
        roundedRectangle3Path.lineWidth = 1;
        [roundedRectangle3Path stroke];
        
        
        //// Rounded Rectangle 2 Drawing
        UIBezierPath* roundedRectangle2Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(13.5, 3.5, 9, 7) cornerRadius: 3.5];
        [[UIColor whiteColor] setFill];
        [roundedRectangle2Path fill];
        [[UIColor blackColor] setStroke];
        roundedRectangle2Path.lineWidth = 1;
        [roundedRectangle2Path stroke];
        
        
        //// Rounded Rectangle Drawing
        UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(2.5, 10, 31, 20) cornerRadius: 4];
        [[UIColor whiteColor] setFill];
        [roundedRectanglePath fill];
        [[UIColor blackColor] setStroke];
        roundedRectanglePath.lineWidth = 1;
        [roundedRectanglePath stroke];
        
        
        //// Oval Drawing
        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(7, 8, 22, 23)];
        [[UIColor whiteColor] setFill];
        [ovalPath fill];
        [[UIColor blackColor] setStroke];
        ovalPath.lineWidth = 1;
        [ovalPath stroke];
        
        
        //// Oval 2 Drawing
        UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(10, 11, 16, 17.5)];
        [[UIColor lightGrayColor] setFill];
        [oval2Path fill];
        [[UIColor blackColor] setStroke];
        oval2Path.lineWidth = 1;
        [oval2Path stroke];
        
        
        CGContextEndTransparencyLayer(context);
        CGContextRestoreGState(context);
    }
}

@end