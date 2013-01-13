//
//  WebViewController.h
//  Dark Potential
//
//  Created by Joel Glanfield on 2013-01-03.
//  Copyright (c) 2013 Joel Glanfield. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSString *webPageURL;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;

- (IBAction)backButtonPressed:(id)sender;

@end
