//
//  LoadingView.m
//  FreshlyPressed
//
//  Created by D. on 2018-01-11.
//  Copyright © 2018 Automattic. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView()
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation LoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.35]];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorView.center = CGPointMake(self.center.x, self.center.y);
    [_activityIndicatorView setHidesWhenStopped: YES];
    [_activityIndicatorView startAnimating];
    
    [self addSubview:_activityIndicatorView];
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    
    [_activityIndicatorView setHidden:hidden];
}

@end
