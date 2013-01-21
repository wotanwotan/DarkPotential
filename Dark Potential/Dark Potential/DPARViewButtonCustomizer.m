//
//  DPARViewButton.m
//  Dark Potential
//
//  Created by Joel Glanfield on 2013-01-21.
//  Copyright (c) 2013 Joel Glanfield. All rights reserved.
//

#import "DPARViewButtonCustomizer.h"

@interface DPARViewButtonCustomizer ()

@property(retain) UIImage* onStateImage;
@property(retain) UIImage* offStateImage;

- (UIImage*)imageForSelector: (SEL)selector;

@end


@implementation DPARViewButtonCustomizer

//-(void)awakeFromNib
//{
//    [super awakeFromNib];
//    
//    
//    
//}

-(id)initWithButton:(UIButton *)theButton
{
    self = [super init];
    
    if (self)
    {
        _customButton = theButton;
        
        self.onStateImage = [self imageForSelector: @selector(drawNormalState)];
        self.offStateImage = [self imageForSelector: @selector(drawHighlightedState)];
        
        [self.customButton setBackgroundImage:self.onStateImage forState:UIControlStateNormal];
        [self.customButton setBackgroundImage:self.offStateImage forState:UIControlStateHighlighted];
    }
    
    return self;
}

- (UIImage*)imageForSelector: (SEL)selector
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
	
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector: selector];
#pragma clang diagnostic pop
	
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

- (CGSize)size
{
    return self.customButton.bounds.size;
}


- (void)drawNormalState
{

}

- (void)drawHighlightedState
{

}

@end