//
//  NSDate+FuzzyRelativeTime.h
//
//  Copyright (c) 2014 Automattic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (FuzzyRelativeTime)

- (NSString *)fuzzyRelativeTimeFromDate:(NSDate *)date;
- (NSString*)fuzzyRelativeTimeFromNow;

@end
