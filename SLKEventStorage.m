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
#import "Medz.h"
#import "SLKConstants.h"
#import "SLKPARSEService.h"
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

#pragma mark CREATE methods

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
-(Event *)createEvenWithHappening:(NSManagedObject *)happening date:(NSDate *)date eventId:(NSString *)eventId baby:(Baby *)baby
{
    Event *e = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                             inManagedObjectContext:context];
   
    if ([happening isKindOfClass:[Tits class]] )
    {
        e.type = kEventType_TitFood;
        [e addTitiesObject:(Tits*)happening];
        
    } else if ([happening isKindOfClass:[Bottle class]] )
    {
        e.type = kEventType_BottleFood;
        [e addBottlesObject:(Bottle*)happening];
        
    }  else if ([happening isKindOfClass:[Poo class]] )
    {
        e.type = kEventType_Poo;
        [e addPoosObject:(Poo*)happening];
    } else if ([happening isKindOfClass:[Pii class]] )
    {
        e.type = kEventType_Pii;
        [e addPiisObject:(Pii*)happening];
    } else if ([happening isKindOfClass:[Medz class]] )
    {
        e.type = kEventType_Medz;
        [e addMedzObject:(Medz*)happening];
    }
    
    e.eventId = eventId;
    e.baby = baby;
    e.date = date;
 
    NSLog(@"Created event with tit: %@, to baby: %@", [happening class], baby.name);
    return e;
}
-(Event *)createEventwithTit:(Tits *)tit date:(NSDate *)date eventId:(NSString *)eventId baby:(Baby *)baby
{
    Event *e = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                            inManagedObjectContext:context];
    [e addTitiesObject:tit];
    e.eventId = eventId;
    e.baby = baby;
    e.date = date;
     e.type = kEventType_TitFood;
    NSLog(@"Created event with tit: %@, to baby: %@", tit.milliLitres, baby.name);
    return e;
}

-(Event *)createEvenWithdBottle:(Bottle *)bottle date:(NSDate *)date eventId:(NSString *)eventId baby:(Baby *)baby
{
    Event *e = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                             inManagedObjectContext:context];
    [e addBottlesObject:bottle];
    e.eventId = eventId;
    e.baby = baby;
    e.date = date;
     e.type = kEventType_BottleFood;
    NSLog(@"Created event with tit: %@, to baby: %@", bottle, baby.name);
    return e;
}

-(Event *)createEventwithPoo:(Poo *)poo date:(NSDate *)date eventId:(NSString *)eventId baby:(Baby *)baby
{
    Event *e = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                             inManagedObjectContext:context];
    [e addPoosObject:poo];
    e.eventId = eventId;
    e.baby = baby;
    e.date = date;
     e.type = kEventType_Poo;
    NSLog(@"Created event with tit: %@, to baby: %@", poo, baby.name);
    return e;
}

-(Event *)createEventwithPii:(Pii *)pii date:(NSDate *)date eventId:(NSString *)eventId baby:(Baby *)baby
{
    Event *e = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                             inManagedObjectContext:context];
    [e addPiisObject:pii];
    e.eventId = eventId;
    e.baby = baby;
    e.date = date;
    e.type = kEventType_Pii;
    NSLog(@"Created event with tit: %@, to baby: %@", pii, baby.name);
    return e;
}
-(Event *)createEventwithMedz:(Medz *)medz date:(NSDate *)date eventId:(NSString *)eventId baby:(Baby *)baby
{
    
    Event *e = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                             inManagedObjectContext:context];
    [e addMedzObject:medz];
    e.eventId = eventId;
    e.baby = baby;
    e.date = date;
    e.type = kEventType_Pii;
    NSLog(@"Created event with tit: %@, to baby: %@", medz, baby.name);
    return e;
}



-(NSArray *)getEventBelomigTObaby:(Baby *)baby
{
    NSArray *arr = [[SLKCoreDataService sharedService] fetchDataWithEntity:@"Event"
                                                                         andPredicate:[NSPredicate predicateWithFormat:@"baby == %@", baby]
                                                                   andSortDescriptors:nil];
    
    return [arr count] > 0 ? arr : nil;
}

-(NSArray *)getEventBelomigTObaby:(Baby *)baby andDay:(NSDate *)day{
    NSArray *allEventOfBaby = [[SLKCoreDataService sharedService] fetchDataWithEntity:@"Event"
                                                              andPredicate:[NSPredicate predicateWithFormat:@"baby == %@", baby]
                                                        andSortDescriptors:nil];
      
    
       NSMutableArray *returnArray = [NSMutableArray array];
    
    
    for (Event *event in allEventOfBaby)
    {
        NSDate *dateOfEvent = event.date;
        
        [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&dateOfEvent interval:NULL forDate:dateOfEvent];
        [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&day interval:NULL forDate:day];
        
        NSComparisonResult compareParemeterStartDateWithParameterEndDate = [dateOfEvent compare:day];
        
        if (compareParemeterStartDateWithParameterEndDate == NSOrderedSame)
        {
            [returnArray addObject:event];
        }
    }
    
    NSArray *sortedArray = [[NSArray alloc] init];
    sortedArray = [returnArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(Event*)a date];
        NSDate *second = [(Event*)b date];
        return [first compare:second];
    }];
    
    if ([sortedArray count] >= 1)
    {
        return sortedArray;
    }
    
    return nil;
}

-(NSArray *)getEventBelomigTObaby:(Baby *)baby andDay:(NSDate *)day withTypes:(NSArray*)types{
    NSArray *events;
     NSMutableArray *allEvents = [NSMutableArray array];
    for (NSString *type in types)
    {
   events = [[SLKCoreDataService sharedService] fetchDataWithEntity:@"Event"
                                                                         andPredicate:[NSPredicate predicateWithFormat:@"baby == %@ and type == %@", baby, type]
                                                                   andSortDescriptors:nil];
        
        for (Event *event in events){
        [allEvents addObject:event];
        }
    }
    
    NSMutableArray *returnArray = [NSMutableArray array];
    
    
    for (Event *event in allEvents)
    {
        NSDate *dateOfEvent = event.date;
        
        [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&dateOfEvent interval:NULL forDate:dateOfEvent];
        [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&day interval:NULL forDate:day];
        
        NSComparisonResult compareParemeterStartDateWithParameterEndDate = [dateOfEvent compare:day];
        
        if (compareParemeterStartDateWithParameterEndDate == NSOrderedSame)
        {
            [returnArray addObject:event];
        }
    }
    
    NSArray *sortedArray = [[NSArray alloc] init];
    sortedArray = [returnArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(Event*)a date];
        NSDate *second = [(Event*)b date];
        return [first compare:second];
    }];
    
    if ([sortedArray count] >= 1)
    {
        return sortedArray;
    }
    
    return nil;
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
    PFObject *object = [PFObject objectWithoutDataWithClassName:@"Event"
                                                       objectId:event.eventId];
    [SLKPARSEService deleteObject:object];
}

-(void)removeAllEvents
{
    for (Event *event in [self eventArray])
    {
        [self removeEvent:event];
    }
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
