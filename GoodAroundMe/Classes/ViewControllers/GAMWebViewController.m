//
//  GiveViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/11/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "GAMWebViewController.h"
#import "AppConstants.h"

@interface GAMWebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation GAMWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.webview.delegate = self;
    [self.webview scalesPageToFit];
    
    self.activityIndicator.hidesWhenStopped = YES;
    
    [self loadRequest];
}

- (void)loadRequest
{
    if (self.urlString) {
        NSURL *url = [NSURL URLWithString:self.urlString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [self.webview loadRequest:urlRequest];
    }
}

#pragma mark - Storyboard

- (IBAction)refresh:(id)sender
{
    [self loadRequest];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.statusLabel.text = @"Loading...";
    [self.activityIndicator startAnimating];
    NSLog(@"[DEBUG] <GiveViewController> webViewDidStartLoad for url %@ ", self.urlString);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
    self.statusLabel.hidden = YES;
    NSLog(@"[DEBUG] <GiveViewController> webViewDidFinishLoad for url %@ ", self.urlString);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
    [self.activityIndicator stopAnimating];
    self.statusLabel.text = @"Error loading";
    self.statusLabel.textColor = [UIColor redColor];
}

@end
