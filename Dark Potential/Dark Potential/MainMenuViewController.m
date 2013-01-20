//
//  ViewController.m
//  Dark Potential
//
//  Created by Joel Glanfield on 2012-11-01.
//  Copyright (c) 2012 Joel Glanfield. All rights reserved.
//

#import "MainMenuViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MainMenuViewController ()

- (void) playMWGAudio;
- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
- (void) playAudioWithName:(NSString*)audioFileName;

@end

@implementation MainMenuViewController

+(void)initialize
{
    UILabel *proxyLabel = [UILabel appearance];
    
    [proxyLabel setFont:[UIFont fontWithName:@"bebas" size:16]];
    
    /*if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"])
     [bioTextView setFont:[UIFont fontWithName:@"bebas" size:18]];
     else
     [bioTextView setFont:[UIFont fontWithName:@"bebas" size:12]];*/
    
    
    /*UISwitch *proxySwitch = [UISwitch appearance];
     
     if ([proxySwitch respondsToSelector:@selector(setTintColor:)])
     [proxySwitch setTintColor:[UIColor orangeColor]];
     
     if ([proxySwitch respondsToSelector:@selector(setOnTintColor:)])
     [proxySwitch setOnTintColor:[UIColor blackColor]];*/
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.currentCharacter = DP_NONE;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"%@", segue.identifier);
	if (segue.identifier != NULL && [segue.identifier rangeOfString:@"ShowCharacterPageSegue"].location != NSNotFound)
	{
        CharacterViewController* controller = segue.destinationViewController;
		controller.delegate = self;
        controller.currentCharacter = self.currentCharacter;
	}
}

/*- (void) animateButton:(UIButton*)theButton animateFromLeft:(BOOL)fromLeft
{    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect btnFrame = theButton.frame;
    CGRect finalFrame = CGRectMake(btnFrame.origin.x, btnFrame.origin.y, btnFrame.size.width, btnFrame.size.height);
    
    // move button off screen
    if (fromLeft)
        theButton.frame = CGRectMake(finalFrame.origin.x - screenBounds.size.width, finalFrame.origin.y, finalFrame.size.width, finalFrame.size.height);
    else
        theButton.frame = CGRectMake(finalFrame.origin.x + screenBounds.size.width, finalFrame.origin.y, finalFrame.size.width, finalFrame.size.height);

    // un-hide the button
    [theButton setHidden:NO];
    
    float dur = 0.2;
    float delay = currentButtonToAnimate == 0 ? 0.4 : 0.2;
    
    // animate the button
    [UIView animateWithDuration:dur delay:delay options:UIViewAnimationOptionAllowUserInteraction animations:^{
        theButton.frame = finalFrame;
    } completion:^(BOOL finished){
        if (finished)
        {
            currentButtonToAnimate++;
            if (currentButtonToAnimate < numButtonsToAnimate)
            {
                BOOL fromLeft = currentButtonToAnimate % 2 == 0;
                [self animateButton:[animatedButtons objectAtIndex:currentButtonToAnimate] animateFromLeft:fromLeft];
            }
            else // animate the logo
            {
                [self animateMWGLogo];
            }
        }
    }];
}*/

- (void) playAudioWithName:(NSString*)audioFileName
{
    NSString* resourcesPath = [[NSBundle mainBundle] resourcePath];
    NSString* pathToAudio = [resourcesPath stringByAppendingFormat:@"/%@", audioFileName];
    NSURL* url = [NSURL fileURLWithPath:pathToAudio];//[NSString stringWithFormat:@"%@/MWGIntro.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSLog(@"Resource path: %@", [[NSBundle mainBundle] resourcePath]);
    
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.audioPlayer.delegate = self;
    self.audioPlayer.numberOfLoops = 0;
    self.audioPlayer.volume = 1.0;
    
    [self.audioPlayer play];
}

- (void) playMWGAudio
{
    [self playAudioWithName:@"MWGIntro.mp3"];
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.audioPlayer stop]; // necessary?
}

- (IBAction)launchMWGWebsite:(id)sender
{
    NSURL *url = [[NSURL alloc] initWithString: @"http://miniwargaming.com"];
    
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)experienceButtonPressed:(id)sender
{
    [self playAudioWithName:@"menu_whoosh_in.mp3"];
    
/*    [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.experienceBtn1.transform = CGAffineTransformMakeScale(0.8, 0.8);

    } completion:^(BOOL finished){
        if (finished)
        {
            [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                self.experienceBtn1.transform = CGAffineTransformMakeScale(1,1);
            } completion:nil
            ];
        }
    }];
*/

    switch ([sender tag])
    {
        case 0:
            self.currentCharacter = DP_XLANTHOS;
            break;
        case 1:
            self.currentCharacter = DP_RECLAIMER;
            break;
        case 2:
            // TBD
            self.currentCharacter = DP_CORPORATION;
            break;
    }
}

- (void) characterViewDidClose:(CharacterViewController*)controller
{
    [self playAudioWithName:@"menu_whoosh_in.mp3"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setExperienceBtn1:nil];
    [self setExperienceBtn2:nil];
    [self setExperienceBtn3:nil];
    [super viewDidUnload];
}

@end