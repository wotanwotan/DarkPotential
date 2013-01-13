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
    
    // custom back button
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn setImage:[UIImage imageNamed:@"button-back"]
         forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backButton setCustomView:btn];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // customize navigation bar
    [self.navBar setBackgroundImage:[UIImage imageNamed:@"navbar"]
                      forBarMetrics:UIBarMetricsDefault];
    [self.navBar setTintColor:[UIColor darkGrayColor]];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webPageURL]]];
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    [self.activity startAnimating];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activity stopAnimating];
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
    [self setNavBar:nil];
    [self setBackButton:nil];
    [super viewDidUnload];
}

@end
