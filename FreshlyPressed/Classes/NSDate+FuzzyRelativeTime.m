//
//  NSDate+FuzzyRelativeTime.m
//
//  Copyright (c) 2014 Automattic. All rights reserved.
//

#import "NSDate+FuzzyRelativeTime.h"

@implementation NSDate (FuzzyRelativeTime)

- (NSString *)fuzzyRelativeTimeFromDate:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |
    NSCalendarUnitDay | NSCalendarUnitHour |
    NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:self
                                                  toDate:date
                                                 options:0];
    
    NSString *dateComponentType;
    NSInteger stringNumber = 0;
    if ([components year]) {
        stringNumber = [components year];
        dateComponentType = NSLocalizedString(@"year", @"");
    } else if ([components month]) {
        stringNumber = [components month];
        dateComponentType = NSLocalizedString(@"month", @"");
    } else if ([components day]) {
        stringNumber = [components day];
        dateComponentType = NSLocalizedString(@"day", @"");
    } else if ([components hour]) {
        stringNumber = [components hour];
        dateComponentType = NSLocalizedString(@"hour", @"");
    } else if ([components minute]) {
        stringNumber = [components minute];
        dateComponentType = NSLocalizedString(@"minute", @"");
    }
    
    NSString *returnValue;
    if (dateComponentType) {
        NSString *stringFormat = [NSString stringWithFormat:@"%@ %%d %@%@ %@", NSLocalizedString(@"about", nil), dateComponentType, (stringNumber>1) ? @"s" : @"", NSLocalizedString(@"ago", nil)];
        returnValue = [NSString stringWithFormat:NSLocalizedString(stringFormat, @""), stringNumber];
    } else {
        returnValue = NSLocalizedString(@"Just now", @"");
    }
    
    return returnValue;
}

- (NSString*)fuzzyRelativeTimeFromNow
{
    return [self fuzzyRelativeTimeFromDate:[NSDate date]];;
}

@end
