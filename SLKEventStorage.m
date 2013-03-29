//
//  SLKEventStorage.m
//  SKAP
//
//  Created by Åsa Persson on 2013-03-26.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//


#import "SLKCoreDataService.h"
#import "SLKBabyStorage.h"
#import "Baby.h"
#import "SLKUserDefaults.h"
#import "SLKEventStorage.h"
#import "Event.h"
#import "Tits.h"
#import "Bottle.h"
#import "Poo.h"
#import "Pii.h"
@implementation SLKEventStorage
{
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
    
}

+(SLKBabyStorage*) sharedStorage
{
    static SLKBabyStorage *sharedStorage;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sharedStorage = [[self alloc]init];
    });
    return sharedStorage;
    
}

- (id)init
{
    self = [super init];
    if(self)
    {
        model = [[SLKCoreDataService  sharedService] getModel];
        context = [[SLKCoreDataService sharedService] getContext];
        
    }
    return self;
}

-(Event *)createEventwithDate:(NSDate *)date eventId:(NSString *)eventId tits:(NSSet *)tits pii:(NSSet *)pii poo:(NSSet *)poo bottles:(NSSet *)bottle adDrop:(BOOL)adDrop otherMedz:(NSString *)medz temperature:(NSNumber *)temp type:(NSString *)type timeSpan:(NSNumber *)timeSpan baby:(Baby *)baby comments:(NSString *)comments
{
    Event *e;
    Event *eventInStorage = [self getEventWithiD:eventId];
    if (eventInStorage) {
        NSLog(@"the event already exists in core data, skipping creating a new, and updates existing baby instead.");
        e = eventInStorage;
        
    } else {
        e = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                          inManagedObjectContext:context];
    }
    
    e.date = date;
    e.eventId = eventId;
    [e addBottles:bottle];
    [e addPiis:pii];
    [e addPoos:poo];
    [e addTities:tits];
    e.comments = comments; //TODO: make entety of comments????
    e.adDrop = [NSNumber numberWithBool:adDrop];
    e.otherMedz = medz;
    e.temperature = temp;
    e.type = @"event";
    e.timespan = timeSpan;
    e.baby = baby;

    
    return e;
}

-(Event *)getEventWithiD:(NSString *)eventId
{
    NSArray *arr = [[SLKCoreDataService sharedService] fetchDataWithEntity:@"Event"
                                                              andPredicate:[NSPredicate predicateWithFormat:@"eventId == %@", eventId]
                                                        andSortDescriptors:nil];
    
    return [arr count] > 0 ? [arr lastObject] : nil;
   
}
-(void)removeEvent:(Event *)event
{
    [context deleteObject:event];
}

-(NSArray *)getEventByDay:(NSDate *)date
{
    NSArray *arr = [[SLKCoreDataService sharedService] fetchDataWithEntity:@"Event"
                                                              andPredicate:[NSPredicate predicateWithFormat:@"date == %@", date]
                                                        andSortDescriptors:nil];
    
    return [arr count] > 0 ? [arr lastObject] : nil;
    
}

-(NSArray *)eventArray
{
    return [[SLKCoreDataService sharedService]fetchDataWithEntity:@"Event"];
}



@end
