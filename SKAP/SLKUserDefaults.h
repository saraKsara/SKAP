//
//  SLKUserDefaults.h
//  SKAP
//
//  Created by Åsa Persson on 2013-03-26.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Baby, ParentFigures;
@interface SLKUserDefaults : NSObject

+(NSString*)getTheCurrentBabe;

+(void)setTheCurrentBabe:(NSString*)babyId;

+(void)setTheCurrentParent:(NSString *)parentId;

+(NSString*)getTheCurrentParent;

@end
