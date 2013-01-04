//
//  WebViewController.m
//  Dark Potential
//
//  Created by Joel Glanfield on 2013-01-03.
//  Copyright (c) 2013 Joel Glanfield. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize webPageURL, webView, activity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

}

- (void)viewDidAppear:(BOOL)animated
{
    webView.delegate = self;
    webView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webPageURL]]];
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    [activity startAnimating];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView
{
    [activity stopAnimating];
}

-(void) viewDidDisappear:(BOOL)animated
{
    self.webPageURL = @"none";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setActivity:nil];
    [super viewDidUnload];
}

@end
