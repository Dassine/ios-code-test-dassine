//
//  CompactPostTableViewCell.h
//  FreshlyPressed
//
//  Copyright © 2018 Automattic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompactPostTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *title;

- (void)setupWithTitle:(NSString*)aTitle;

@end
