//
//  SLKColors.h
//  SKAP
//
//  Created by Åsa Persson on 2013-04-03.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (GSAdditions)

+ (UIColor*)colorWithHexValue:(NSString*)hexValue;
+ (UIColor*)colorWithHexValue:(NSString*)hexValue alpha:(CGFloat) alpha;

@end

