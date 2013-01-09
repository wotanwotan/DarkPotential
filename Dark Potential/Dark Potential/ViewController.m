//
//  ViewController.m
//  Dark Potential
//
//  Created by Joel Glanfield on 2012-11-01.
//  Copyright (c) 2012 Joel Glanfield. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

- (void) playMWGAudio;
- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
- (void) playAudioWithName:(NSString*)audioFileName;

@end

@implementation ViewController

+(void)initialize
{
    UILabel *proxyLabel = [UILabel appearance];
    
    [proxyLabel setFont:[UIFont fontWithName:@"bebas" size:18]];
    
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
    
    UIButton *logoView = [[UIButton alloc] initWithFrame:CGRectMake(0,0,85,40)];
    [logoView setBackgroundImage:[UIImage imageNamed:@"dp-logo.png"] forState:UIControlStateNormal];
    [logoView setUserInteractionEnabled:NO];
    
    self.navigationItem.titleView = logoView;

    if ([self.navigationController.navigationBar
         respondsToSelector:@selector(shadowImage)]) {
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    }
    
    currentButtonToAnimate = 0;
    numButtonsToAnimate = 3;
    animatedButtons = [NSArray arrayWithObjects:self.experienceBtn1, self.experienceBtn2, self.experienceBtn3, nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"%@", segue.identifier);
	if (segue.identifier != NULL && [segue.identifier rangeOfString:@"ShowCharacterPageSegue"].location != NSNotFound)
	{
        CharacterViewController* controller = segue.destinationViewController;
		controller.delegate = self;
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
    
    AppDelegate* appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    switch ([sender tag])
    {
        case 0:
            [appDel setCurrentCharacter:DP_XLANTHOS];
            break;
        case 1:
            [appDel setCurrentCharacter:DP_RECLAIMER];
            break;
        case 2:
            // TBD
            [appDel setCurrentCharacter:DP_CORPORATION];
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
