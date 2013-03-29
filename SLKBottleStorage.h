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

-(Bottle*)createBottleWithStringValue:(NSString*)stringValue mililitres:(NSNumber*)milliLitres minutes:(NSNumber*)minutes;

-(void)removeBottle:(Bottle*)bottle;

//-(Bottle*)getBottleThatBelongsToEvent:(Bottle*)bottle;

//-(NSArray*)titArray;
@end
