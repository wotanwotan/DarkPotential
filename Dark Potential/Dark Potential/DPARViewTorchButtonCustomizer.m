//
//  DPARViewTorchButtonCustomizer.m
//  Dark Potential
//
//  Created by Joel Glanfield on 2013-01-21.
//  Copyright (c) 2013 Joel Glanfield. All rights reserved.
//

#import "DPARViewTorchButtonCustomizer.h"

@implementation DPARViewTorchButtonCustomizer

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
    UIColor* shadow = isHighlighted ? [UIColor lightTextColor] : [UIColor colorWithRed: 0.31 green: 0.31 blue: 0.31 alpha: 1];
    CGSize shadowOffset = CGSizeMake(2.1, 2.1);
    CGFloat shadowBlurRadius = 3;
    
    //// Group
    {
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
        
        CGContextBeginTransparencyLayer(context, NULL);
        
        
        //// Bezier Drawing
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(24, 2.5)];
        [bezierPath addLineToPoint: CGPointMake(6.5, 17.5)];
        [bezierPath addLineToPoint: CGPointMake(16.5, 17.5)];
        [bezierPath addLineToPoint: CGPointMake(6.5, 32.5)];
        [bezierPath addLineToPoint: CGPointMake(31.5, 14.29)];
        [bezierPath addLineToPoint: CGPointMake(19, 14.29)];
        [bezierPath addLineToPoint: CGPointMake(24, 2.5)];
        [[UIColor whiteColor] setFill];
        [bezierPath fill];
        [[UIColor blackColor] setStroke];
        bezierPath.lineWidth = 1;
        [bezierPath stroke];
        
        
        CGContextEndTransparencyLayer(context);
        CGContextRestoreGState(context);
    }
}

@end
