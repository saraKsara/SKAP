//
//  SLKBottleStorage.h
//  SKAP
//
//  Created by Åsa Persson on 2013-03-29.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Bottle;
@interface SLKBottleStorage : NSObject
+(SLKBottleStorage*) sharedStorage;

-(Bottle*)createBottleWithId:(NSString*)bottleId stringValue:(NSString*)stringValue mililitres:(NSNumber*)milliLitres minutes:(NSNumber*)minutes dirty:(BOOL)dirty;

-(void)removeBottle:(Bottle*)bottle;

-(Bottle *)getBottleWithiD:(NSString *)bottleId;
//-(Bottle*)getBottleThatBelongsToEvent:(Bottle*)bottle;

//-(NSArray*)titArray;
@end
