//
//  SLKDateUtil.m
//  SKAP
//
//  Created by Åsa Persson on 2013-03-26.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKDateUtil.h"

@implementation SLKDateUtil

NSDateFormatter* utcTimestampDateFormatter = nil;
NSDateFormatter* yyyyMMddDateFormatter = nil;
NSDateFormatter* dateTitleFormatterStrings = nil;
NSDateFormatter* dateTitleFormatterThisYear = nil;
NSDateFormatter* dateTitleFormatterOtherYear = nil;

+(void)initialize
{
    utcTimestampDateFormatter = [[NSDateFormatter alloc] init ];
    [utcTimestampDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [utcTimestampDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    yyyyMMddDateFormatter = [[NSDateFormatter alloc] init];
    [yyyyMMddDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [yyyyMMddDateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    dateTitleFormatterStrings = [[NSDateFormatter alloc] init];
    [dateTitleFormatterStrings setDateStyle:NSDateFormatterMediumStyle];
    [dateTitleFormatterStrings setDoesRelativeDateFormatting:YES]; // enables "today", "tomorrow", "yesterday"
    
    dateTitleFormatterThisYear = [[NSDateFormatter alloc] init];
    [dateTitleFormatterThisYear setDateFormat:@"EEE dd MMM"];
    
    dateTitleFormatterOtherYear = [[NSDateFormatter alloc] init];
    [dateTitleFormatterOtherYear setDateFormat:@"dd MMM, yyyy"];
}

+(NSString*) formatDate:(NSDate*) date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    return [dateFormatter stringFromDate:date];
}

+(NSString*) formatDateWithoutYear:(NSDate*) date
{
    NSDateFormatter *monthandDayFormatter = [[NSDateFormatter alloc] init];
    [monthandDayFormatter setLocale:[NSLocale currentLocale]];
    [monthandDayFormatter setDateFormat:@"dd MMMM"];
    return [monthandDayFormatter stringFromDate:date];
}

+(NSString*) formatYearFromDate:(NSDate*) date
{
    NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
    [yearFormatter setDateFormat:@"yyyy"];
    return [yearFormatter stringFromDate:date];
}

@end
