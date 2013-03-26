//
//  SLKEventStorage.h
//  SKAP
//
//  Created by Åsa Persson on 2013-03-26.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Event;
@interface SLKEventStorage : NSObject

+(SLKEventStorage*) sharedStorage;

-(Event*)createEventwithDate:(NSDate*)date eventId:(NSString*)eventId tits:(NSString*)tits pii:(NSString*)pii poo:(NSString*)poo bottle:(NSNumber*)bottle adDrop:(BOOL)adDrop otherMedz:(NSString*)medz temperature:(NSNumber*)temp type:(NSString*)type timeSpan:(NSNumber*)timeSpan baby:(Baby*)baby;

-(Event*)getEventWithiD:(NSString*)eventId;

-(void)removeEvent:(Event*)event;

-(NSArray*)getEventByDay:(NSDate*)date;

-(NSArray*)eventArray;


@end
