//
//  ViewController.m
//  Dark Potential
//
//  Created by Joel Glanfield on 2012-11-01.
//  Copyright (c) 2012 Joel Glanfield. All rights reserved.
//

#import "DPMainMenuViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DPMainMenuViewController ()

- (void) playMWGAudio;
- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
- (void) playAudioWithName:(NSString*)audioFileName;

@end

@implementation DPMainMenuViewController

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
        DPCharacterViewController* controller = segue.destinationViewController;
		controller.delegate = self;
        controller.currentCharacter = self.currentCharacter;
	}
}

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

- (IBAction)experienceButtonPressed:(id)sender
{
    [self playAudioWithName:@"menu_whoosh_in.mp3"];

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

- (void) characterViewDidClose:(DPCharacterViewController*)controller
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
