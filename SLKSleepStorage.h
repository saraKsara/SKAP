//
//  SLKSleepStorage.h
//  SKAP
//
//  Created by Student vid Yrkeshögskola C3L on 4/9/13.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Sleep;
@interface SLKSleepStorage : NSObject

+(SLKSleepStorage*) sharedStorage;

-(Sleep*)createSleepWithId:(NSString*)sleepId minutes:(NSNumber*)minutes dirty:(BOOL)dirty;

@end
