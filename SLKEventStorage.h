//
//  SLKEventStorage.h
//  SKAP
//
//  Created by Åsa Persson on 2013-03-26.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Event, Baby, Tits, Bottle, Pii, Poo;
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
                    comments:(NSString*)comments;

-(Event *)createEventwithTit:(Tits*)tit date:(NSDate *)date eventId:(NSString *)eventId baby:(Baby*)baby;

-(Event *)createEvenWithdBottle:(Bottle*)bottle date:(NSDate *)date eventId:(NSString *)eventId baby:(Baby*)baby;

-(Event *)createEventwithPoo:(Poo*)poo date:(NSDate *)date eventId:(NSString *)eventId baby:(Baby*)baby;

-(Event *)createEventwithPii:(Pii*)pii date:(NSDate *)date eventId:(NSString *)eventId baby:(Baby*)baby;

//GETTERS
-(NSArray *)getEventBelomigTObaby:(Baby *)baby;

-(NSArray *)getEventBelomigTObaby:(Baby *)baby andDay:(NSDate*)day;

-(Event*)getEventWithiD:(NSString*)eventId;

-(void)removeEvent:(Event*)event;

-(NSArray*)getEventByDay:(NSDate*)date;

-(NSArray*)eventArray;


@end
