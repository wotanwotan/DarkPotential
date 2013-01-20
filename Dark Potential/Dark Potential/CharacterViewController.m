//
//  CharacterViewController.m
//  Dark Potential
//
//  Created by Joel Glanfield on 2012-11-04.
//  Copyright (c) 2012 Joel Glanfield. All rights reserved.
//

#import "CharacterViewController.h"
#import "ARParentViewController.h"
#import "Bios.h"

@interface CharacterViewController ()

@end

@implementation CharacterViewController

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
    
    /*if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"])
        [bioTextView setFont:[UIFont fontWithName:@"bebas" size:18]];
    else
        [bioTextView setFont:[UIFont fontWithName:@"bebas" size:12]];*/
}

- (void)viewWillAppear:(BOOL)animated
{
    switch (self.currentCharacter)
    {
        case DP_NONE:
            [self.bioTextView setText:@"ERROR: no character selected"];
            break;
        case DP_XLANTHOS:
            [self.bioTextView setText:DP_XLANTHOS_BIO];
            [self.bgImageView setImage:[UIImage imageNamed:@"info-xlanthos.png"]];
            [self.launchARButton setImage:[UIImage imageNamed:@"button-launch-xlanthos"] forState:UIControlStateNormal];
            break;
        case DP_RECLAIMER:
            [self.bioTextView setText:DP_RECLAIMERS_BIO];
            [self.bgImageView setImage:[UIImage imageNamed:@"info-reclaimers.png"]];
            [self.launchARButton setImage:[UIImage imageNamed:@"button-launch-reclaimers"] forState:UIControlStateNormal];
            break;
        case DP_CORPORATION:
            [self.bioTextView setText:DP_CORPORATION_BIO];
            [self.bgImageView setImage:[UIImage imageNamed:@"info-pmc.png"]];
            [self.launchARButton setImage:[UIImage imageNamed:@"button-launch-pmc"] forState:UIControlStateNormal];
            break;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SegueToAR"])
    {
        NSLog(@"SegueToAR");
        ARParentViewController *arVC = segue.destinationViewController;
        arVC.currentCharacter = self.currentCharacter;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exitButtonPressed:(id)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(characterViewDidClose:)])
        [self.delegate characterViewDidClose:self];
}

- (void)viewDidUnload
{
    [self setBioTextView:nil];
    [self setLaunchARButton:nil];
    [super viewDidUnload];
}
@end
