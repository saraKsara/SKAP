//
//  SLKEventStorage.h
//  SKAP
//
//  Created by Åsa Persson on 2013-03-26.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Event, Baby, Tits, Bottle, Pii, Poo, Medz, Sleep, Diaper;
@interface SLKEventStorage : NSObject

+(SLKEventStorage*) sharedStorage;

-(Event*)createEventwithDate:(NSDate*)date eventId:(NSString*)eventId
                        tits:(NSSet*)tits
                         pii:(NSSet*)pii
                         poo:(NSSet*)poo
                     bottles:(NSSet*)bottle
                      adDrop:(BOOL)adDrop
                   otherMedz:(NSString*)medz
                 temperature:(NSNumber*)temp
                        type:(NSString*)type
                    timeSpan:(NSNumber*)timeSpan
                        baby:(Baby*)baby
                       sleep:(NSNumber*)sleep
                    comments:(NSString*)comments
                       dirty:(BOOL)dirty;

-(Event *)createEvenWithHappening:(NSManagedObject*)happening withComment:(NSString*)comment date:(NSDate *)date eventId:(NSString *)eventId baby:(Baby*)baby dirty:(BOOL)dirty;

-(Event *)createNEEEWEvenWithType:(NSString *)type withComment:(NSString *)comment date:(NSDate *)date eventId:(NSString *)eventId baby:(NSString *)baby dirty:(BOOL)dirty;

//GETTERS
-(NSArray *)getEventBelomigTObaby:(Baby *)baby;

-(NSArray *)getEventBelomigTObaby:(Baby *)baby andDay:(NSDate*)day;

-(NSArray *)getEventBelomigTObaby:(Baby *)baby andDay:(NSDate *)day withTypes:(NSArray*)types;

-(NSArray *)getEventBelomigTObaby:(Baby *)baby fromDate:(NSDate*)fromDate toDate:(NSDate*)toDate;

-(Event*)getEventWithiD:(NSString*)eventId;

-(void)removeEvent:(Event*)event;

-(void)removeAllEvents;

-(NSArray*)getEventByDay:(NSDate*)date;

-(NSMutableDictionary*)getAllDaysWithEventforBaby:(Baby*)baby;

-(NSArray *)getEventBelomigTObabyWithID:(NSString *)babyId;

-(NSMutableSet *)eventIdsSet;

-(void)setLatestEvent:(NSDate*)date;

-(NSDate*)getLatestEvent;

@end
