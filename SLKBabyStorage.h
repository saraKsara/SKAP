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

-(Baby*)createBabyWithName:(NSString*)name babyId:(NSString*)babyId pii:(NSNumber*)pii poo:(NSNumber*)poo feedTimespan:(NSNumber*)feedTimespan bottle:(NSNumber*)bottle breast:(NSNumber*)breast date:(NSDate*)date;


-(void)removeBaby:(Baby*)baby;

-(Baby*)getBabyWithiD:(NSString*)babyId;

-(NSArray*)babyArray;


//TODO: make class methods of theese:
-(Baby*)getCurrentBaby;
-(void)setCurrentBaby:(Baby*)baby;

@property (weak, nonatomic)  Baby *currentBaby;
@end
