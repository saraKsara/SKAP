//
//  SLKBabyStorage.h
//  SKAP
//
//  Created by Student vid Yrkeshögskola C3L on 3/19/13.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Baby;
@interface SLKBabyStorage : NSObject

+(SLKBabyStorage*) sharedStorage;

-(Baby*)createBabyWithName:(NSString*)name babyId:(NSString*)babyId date:(NSDate*)date type:(NSString*)type;

-(void)removeBaby:(Baby*)baby;

-(Baby*)getBabyWithiD:(NSString*)babyId;

-(NSArray*)babyArray;

-(Baby*)getCurrentBaby;

-(void)setCurrentBaby:(Baby*)baby;

@end
