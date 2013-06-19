//
//  SLKStringUtil.h
//  SKAP
//
//  Created by Åsa Persson on 2013-06-19.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLKStringUtil : NSObject

+(NSString *) uid;

+(BOOL) isBlank:(NSString *) str;

+(BOOL) isEmailValid:(NSString *) email;

+(BOOL) isPasswordValid:(NSString *) password;

+(NSString *) trim:(NSString *) str;

+(NSString *)removeAllBlanksAndMakeLowerCase:(NSString *)str;

@end
