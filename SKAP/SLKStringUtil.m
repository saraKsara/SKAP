//
//  SLKStringUtil.m
//  SKAP
//
//  Created by Åsa Persson on 2013-06-19.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKStringUtil.h"

@implementation SLKStringUtil

+(NSString*) uid
{
    return [[NSProcessInfo processInfo] globallyUniqueString];
}

+(BOOL)isBlank: (NSString*) str
{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0;
}

+(BOOL)isEmailValid:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

+(BOOL)isPasswordValid:(NSString *)password
{
    return [password length] >= 8;
}

+(NSString *)trim:(NSString *)str
{
    return [str stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+(NSString *)removeAllBlanksAndMakeLowerCase:(NSString *)str
{
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    NSArray *parts = [str.lowercaseString componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    return [filteredArray componentsJoinedByString:@""];
}

@end
