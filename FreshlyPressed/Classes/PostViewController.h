//
//  DetailViewController.h
//
//  Copyright (c) 2014 Automattic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface PostViewController : UIViewController

@property (nonatomic, strong) Post *post;

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@end
