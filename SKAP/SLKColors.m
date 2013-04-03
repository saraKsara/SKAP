//
//  SLKColors.m
//  SKAP
//
//  Created by Åsa Persson on 2013-04-03.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//
//  UIColor+GSAdditions.m
//
//  Created by Simon Whitaker at Goo Software Ltd on 15/09/2011.
//
#import "SLKColors.h"

@implementation UIColor  (GSAdditions)

+ (UIColor*)colorWithHexValue:(NSString*)hexValue
{
    return [self colorWithHexValue:hexValue alpha:1.0];
}

+ (UIColor*)colorWithHexValue:(NSString*)hexValue alpha:(CGFloat) alpha {
    UIColor *defaultResult = [UIColor blackColor];
    
    // Strip leading # if there is one
    if ([hexValue hasPrefix:@"#"] && [hexValue length] > 1) {
        hexValue = [hexValue substringFromIndex:1];
    }
    
    NSUInteger componentLength = 0;
    if ([hexValue length] == 3)
        componentLength = 1;
    else if ([hexValue length] == 6)
        componentLength = 2;
    else
        return defaultResult;
    
    BOOL isValid = YES;
    CGFloat components[3];
    
    for (NSUInteger i = 0; i < 3; i++) {
        NSString *component = [hexValue substringWithRange:NSMakeRange(componentLength * i, componentLength)];
        if (componentLength == 1) {
            component = [component stringByAppendingString:component];
        }
        NSScanner *scanner = [NSScanner scannerWithString:component];
        unsigned int value;
        isValid &= [scanner scanHexInt:&value];
        components[i] = (CGFloat)value / 256.0;
    }
    
    if (!isValid) {
        return defaultResult;
    }
    
    return [UIColor colorWithRed:components[0]
                           green:components[1]
                            blue:components[2]
                           alpha:alpha];
}



@end