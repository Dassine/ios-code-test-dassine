//
//  NSString+ISO8601DateFormatter.m
//
//  Copyright (c) 2014 Automattic. All rights reserved.
//

#import "NSString+ISO8601DateFormatter.h"

@implementation NSString (ISO8601DateFormatter)

- (NSDate *)iso8601Value
{
    NSString *theDate = self;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    NSDate *date = [formatter dateFromString:theDate];
    
    return date;
}

@end
