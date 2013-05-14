//
//  SLKTittStorage.h
//  SKAP
//
//  Created by Åsa Persson on 2013-03-29.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Tits, Event;
@interface SLKTittStorage : NSObject

+(SLKTittStorage*) sharedStorage;

//TODO: add left and right breast propery on tits

-(Tits*)createTittWithId:(NSString*)titId StringValue:(NSString*)stringValue mililitres:(NSNumber*)milliLitres minutes:(NSNumber*)minutes leftBoob:(BOOL)leftBoob rightBoob:(BOOL)rightBoob dirty:(BOOL)dirty;

-(void)removeTitmilk:(Tits*)tit;

-(Tits*)getTitThatBelongsToEvent:(Event*)event;

-(Tits *)getTitWithiD:(NSString *)titId;
//-(NSArray*)titArray;

@end
