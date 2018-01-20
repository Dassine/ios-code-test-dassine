//
//  PostTableViewCell.h
//
//  Copyright (c) 2014 Automattic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *image;
@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UILabel *date;

- (void)setupWithTitle:(NSString*)aTitle date:(NSString*)aDate andImageUrl:(NSString*)anImageUrl;

@end
