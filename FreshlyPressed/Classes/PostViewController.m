//
//  DetailViewController.m
//
//  Copyright (c) 2014 Automattic. All rights reserved.
//

#import "PostViewController.h"
#import "LoadingView.h"

@interface PostViewController() <UIWebViewDelegate>
@property (nonatomic, strong) LoadingView *loadingView;
@end

@implementation PostViewController

#pragma mark - Managing the detail item

- (void)setPost:(Post *)post
{
    if (_post != post) {
        _post = post;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Set Loading view
    _loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_loadingView];
    [_loadingView setHidden:NO];
    
    [self.view bringSubviewToFront:_loadingView];
    
    self.title = self.post.title;
    
    NSURL *url = [NSURL URLWithString:self.post.short_URL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:requestObj];
}

#pragma mark - WebView Delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_loadingView setHidden:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_loadingView setHidden:YES];
}

@end
