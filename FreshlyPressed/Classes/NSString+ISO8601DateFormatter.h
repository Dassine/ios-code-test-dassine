//
//  NSString+ISO8601DateFormatter.h
//
//  Copyright (c) 2014 Automattic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ISO8601DateFormatter)

- (NSDate *)iso8601Value;

@end
