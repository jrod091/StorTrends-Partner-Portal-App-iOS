//
//  ViewController.m
//  StorTrends Partner Portal
//
//  Created by Jorge Rodriguez on 8/5/14.
//  Copyright (c) 2014 American Megatrends, Inc. All rights reserved.
//

#import "ViewController.h"

static const CGFloat kLabelHeight = 50.0f;
static const CGFloat kMargin = 10.0f;
static const CGFloat kSpacer = 2.0f;

@interface ViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *back;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stop;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refresh;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forward;

@property (strong, nonatomic) UILabel *pageTitle;

- (void)loadRequestFromString:(NSString*)urlString;
- (void)updateButtons;
- (void)informError:(NSError*)error;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.webView.delegate = self;
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    [self.view setFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height)];
    
    NSString* pageTitle = @"StorTrends Partner Portal";
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    CGRect labelFrame = CGRectMake(kMargin, kSpacer, navBar.bounds.size.width -2*kMargin, kLabelHeight);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor redColor];
    [navBar addSubview:label];
    self.pageTitle = label;
    self.pageTitle.text = pageTitle;
    
    [self loadRequestFromString:@"http://www.stortrends.com/registration/login/"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRequestFromString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}

- (void)updateButtons
{
    self.forward.enabled = self.webView.canGoForward;
    self.back.enabled = self.webView.canGoBack;
    self.stop.enabled = self.webView.loading;
}

- (void)informError:(NSError *)error
{
    NSString* localizedDescription = [error localizedDescription];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Title for error alert.") message:localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK button in error alert") otherButtonTitles:nil];
    [alertView show];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateButtons];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([error code] != -999) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self updateButtons];
        [self informError:error];
    }
}

@end
