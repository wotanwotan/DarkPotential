//
//  CharacterViewController.m
//  Dark Potential
//
//  Created by Joel Glanfield on 2012-11-04.
//  Copyright (c) 2012 Joel Glanfield. All rights reserved.
//

#import "CharacterViewController.h"
#import "AppDelegate.h"
#import "Bios.h"

@interface CharacterViewController ()

@end

@implementation CharacterViewController

@synthesize delegate, bioView;

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

- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate* appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    switch ([appDel currentCharacter])
    {
        case DP_NONE:
            [bioView setText:@"ERROR: no character selected"];
            break;
        case DP_XLANTHOS:
            [bioView setText:DP_XLANTHOS_BIO];
            break;
        case DP_RECLAIMER:
            [bioView setText:DP_RECLAIMERS_BIO];
            break;
    }
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
- (void)viewDidUnload {
    [self setBioView:nil];
    [super viewDidUnload];
}
@end
