//
//  DPARViewBackButtonCustomizer.m
//  Dark Potential
//
//  Created by Joel Glanfield on 2013-01-21.
//  Copyright (c) 2013 Joel Glanfield. All rights reserved.
//

#import "DPARViewBackButtonCustomizer.h"

@implementation DPARViewBackButtonCustomizer

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
    
    //// Shadow Declarations
    UIColor* shadow = isHighlighted ? [UIColor lightTextColor] : [UIColor darkTextColor];
    CGSize shadowOffset = CGSizeMake(2.1, 2.1);
    CGFloat shadowBlurRadius = 5;
    
    //// Group
    {
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
        
        CGContextBeginTransparencyLayer(context, NULL);
        
        
        //// Bezier Drawing
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(13.5, 16.7)];
        [bezierPath addCurveToPoint: CGPointMake(14.5, 20.5) controlPoint1: CGPointMake(13.75, 17.95) controlPoint2: CGPointMake(14.5, 20.5)];
        [bezierPath addCurveToPoint: CGPointMake(10.43, 15.19) controlPoint1: CGPointMake(14.5, 20.5) controlPoint2: CGPointMake(13.37, 17.68)];
        [bezierPath addCurveToPoint: CGPointMake(2.5, 10.5) controlPoint1: CGPointMake(7.5, 12.7) controlPoint2: CGPointMake(2.5, 10.5)];
        [bezierPath addCurveToPoint: CGPointMake(9.44, 6.96) controlPoint1: CGPointMake(2.5, 10.5) controlPoint2: CGPointMake(6.75, 8.76)];
        [bezierPath addCurveToPoint: CGPointMake(14.5, 2.5) controlPoint1: CGPointMake(12.12, 5.15) controlPoint2: CGPointMake(14.5, 2.5)];
        [bezierPath addCurveToPoint: CGPointMake(13.5, 5.97) controlPoint1: CGPointMake(14.5, 2.5) controlPoint2: CGPointMake(13.75, 4.72)];
        [bezierPath addCurveToPoint: CGPointMake(13.5, 8.5) controlPoint1: CGPointMake(13.25, 7.22) controlPoint2: CGPointMake(13.5, 8.5)];
        [bezierPath addCurveToPoint: CGPointMake(20.41, 9.72) controlPoint1: CGPointMake(13.5, 8.5) controlPoint2: CGPointMake(16.72, 8.77)];
        [bezierPath addCurveToPoint: CGPointMake(26.41, 11.95) controlPoint1: CGPointMake(22.41, 10.24) controlPoint2: CGPointMake(24.56, 10.96)];
        [bezierPath addCurveToPoint: CGPointMake(32.54, 17.93) controlPoint1: CGPointMake(29.8, 13.76) controlPoint2: CGPointMake(32.01, 14.75)];
        [bezierPath addCurveToPoint: CGPointMake(31.5, 21.5) controlPoint1: CGPointMake(32.79, 19.38) controlPoint2: CGPointMake(32.29, 20.25)];
        [bezierPath addCurveToPoint: CGPointMake(17.5, 33.5) controlPoint1: CGPointMake(26.25, 29.77) controlPoint2: CGPointMake(17.5, 33.5)];
        [bezierPath addCurveToPoint: CGPointMake(24.5, 20.5) controlPoint1: CGPointMake(17.5, 33.5) controlPoint2: CGPointMake(25.5, 25.25)];
        [bezierPath addCurveToPoint: CGPointMake(13.5, 14.5) controlPoint1: CGPointMake(23.5, 15.75) controlPoint2: CGPointMake(13.5, 14.5)];
        [bezierPath addCurveToPoint: CGPointMake(13.5, 16.7) controlPoint1: CGPointMake(13.5, 14.5) controlPoint2: CGPointMake(13.25, 15.45)];
        [bezierPath closePath];
        [[UIColor whiteColor] setFill];
        [bezierPath fill];
        [[UIColor blackColor] setStroke];
        bezierPath.lineWidth = 0.5;
        [bezierPath stroke];
        
        
        CGContextEndTransparencyLayer(context);
        CGContextRestoreGState(context);
    }
}

@end
