//
//  CharacterViewController.m
//  Dark Potential
//
//  Created by Joel Glanfield on 2012-11-04.
//  Copyright (c) 2012 Joel Glanfield. All rights reserved.
//

#import "CharacterViewController.h"

@interface CharacterViewController ()

@end

@implementation CharacterViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exitButtonPressed:(id)sender
{
    if (delegate != nil && [delegate respondsToSelector:@selector(characterViewDidClose:)])
        [self.delegate characterViewDidClose:self];
}
@end
