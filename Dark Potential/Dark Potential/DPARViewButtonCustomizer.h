//
//  DPARViewButton.h
//  Dark Potential
//
//  Created by Joel Glanfield on 2013-01-21.
//  Copyright (c) 2013 Joel Glanfield. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPARViewButtonCustomizer : NSObject

@property (strong, nonatomic) UIButton* customButton;

-(id)initWithButton:(UIButton *)theButton;
- (CGSize)size;
- (void)drawNormalState;
- (void)drawHighlightedState;

@end