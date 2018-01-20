//
//  PostTableViewCell.m
//
//  Copyright (c) 2014 Automattic. All rights reserved.
//

#import "PostTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation PostTableViewCell

- (void)setupWithTitle:(NSString*)aTitle date:(NSString*)aDate andImageUrl:(NSString*)anImageUrl
{
    self.title.text = aTitle;
    self.date.text = aDate;
    
    NSString *imageURLAsString = anImageUrl;
    UIImage *placeholderImage = [UIImage imageNamed: @"placeholder"];
    if (imageURLAsString != nil && imageURLAsString.length > 0) {
        NSURL *url = [NSURL URLWithString:imageURLAsString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        __weak PostTableViewCell *weakCell = self;
        
        [self.imageView setImageWithURLRequest:request
                              placeholderImage:placeholderImage
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           weakCell.image.image = image;
                                           [weakCell setNeedsLayout];
                                       } failure:nil];
    } else {
        self.image.image = placeholderImage;
    }
}

@end
