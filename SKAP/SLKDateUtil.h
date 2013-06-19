//
//  SLKDateUtil.h
//  SKAP
//
//  Created by Åsa Persson on 2013-03-26.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLKDateUtil : NSObject
+(NSString*) formatDate:(NSDate*) date;
+(NSString*) formatDateWithoutYear:(NSDate*) date;
+(NSString*) formatDateWithDay:(NSDate*) date;
+(NSString*) formatDateWithDayMonthAndYear:(NSDate*) date;
+(NSString*) formatYearFromDate:(NSDate*) date;
+(NSString*) formatTimeFromDate:(NSDate*) date;
@end
