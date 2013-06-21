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
#import "Sleep.h"
#import "SLKConstants.h"
#import "SLKPARSEService.h"
#import "Diaper.h"
#import "SLKPARSEService.h"
#import <Parse/Parse.h>
#import "SLKConstants.h"
#import "SLKDates.h"
#import "SLKDateUtil.h"
#import "SLKStringUtil.h"

@implementation SLKEventStorage
{
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
    NSDate *latestEvent;
    
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
        //  latestEvent = [[NSDate alloc] init];
        
    }
    return self;
}

#pragma mark CREATE methods

-(Event *)createEventwithDate:(NSDate *)date eventId:(NSString *)eventId tits:(NSSet *)tits pii:(NSSet *)pii poo:(NSSet *)poo bottles:(NSSet *)bottle adDrop:(BOOL)adDrop otherMedz:(NSString *)medz temperature:(NSNumber *)temp type:(NSString *)type timeSpan:(NSNumber *)timeSpan baby:(Baby *)baby sleep:(NSNumber*)sleep comments:(NSString *)comments
{
    Event *e;
    Event *eventInStorage = [self getEventWithiD:eventId];
    
    [self setLatestEvent:date];
    
    if (eventInStorage) {
        NSLog(@"the event already exists in core data, skipping creating a new, and updates existing object instead.");
        e = eventInStorage;
        
    } else {
        e = [NSEntityDescription insertNewObjectForEntityForName:kEvent
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
    e.sleep = sleep;
    e.dirty = [NSNumber numberWithBool:YES];
    e.day = [SLKStringUtil removeAllBlanksAndMakeLowerCase:[SLKDateUtil formatDateWithDayMonthAndYear:date]];

    
    return e;
}



-(Event *)createEvenWithHappening:(NSManagedObject *)happening withComment:(NSString *)comment date:(NSDate *)date eventId:(NSString *)eventId baby:(Baby *)baby dirty:(BOOL)dirty
{
    Event *e = [NSEntityDescription insertNewObjectForEntityForName:kEvent
                                             inManagedObjectContext:context];
    NSLog(@"Createt:\n happening: %@ \n comment: %@\n date: %@ \n eventID: %@ \n baby: %@", happening, comment, date, eventId,baby.babyId);
    
    e.eventId = eventId;
    e.baby = baby;
    e.date = date;
    e.dirty = [NSNumber numberWithBool:dirty];
    e.day = [SLKStringUtil removeAllBlanksAndMakeLowerCase:[SLKDateUtil formatDateWithDayMonthAndYear:date]];
    NSLog(@"daydayday: %@", e.day);
    // [self setLatestEvent:[NSDate date]];
    
    PFObject *pfEventObject = [PFObject objectWithClassName:kEvent];
    
    if (dirty == YES)
    {
        [pfEventObject setObject:baby.babyId forKey:kBabyId];
        [pfEventObject setObject:e.eventId forKey:@"eventId"];
        [pfEventObject setObject:e.date forKey:@"eventDate"];
    }
    
    if ([happening isKindOfClass:[Tits class]] )
    {
        e.type = kEventType_TitFood;
        [e addTitiesObject:(Tits*)happening];
        
        if (dirty == YES)
        {
            [pfEventObject setObject:kEventType_TitFood forKey:@"type"];
            [pfEventObject setObject:e.eventId forKey:kTitId];
            [pfEventObject saveEventually];
        }
        
        
    } else if ([happening isKindOfClass:[Bottle class]] )
    {
        e.type = kEventType_BottleFood;
        [e addBottlesObject:(Bottle*)happening];
        if (dirty == YES)
        {
            [pfEventObject setObject:e.eventId forKey:kBottleId];
            [pfEventObject setObject:kEventType_BottleFood forKey:@"type"];
            [pfEventObject saveEventually];
        }
        
        
    }  else if ([happening isKindOfClass:[Poo class]] )
    {
        e.type = kEventType_Poo;
        if (comment)  e.comments = comment;
        [e addPoosObject:(Poo*)happening];
        
        if (dirty == YES)
        {
            [pfEventObject setObject:kEventType_Poo forKey:@"type"];
            [pfEventObject setObject:e.eventId forKey:kPooId];
            [pfEventObject saveEventually];
        }
        
        
    } else if ([happening isKindOfClass:[Pii class]] )
    {
        e.type = kEventType_Pii;
        [e addPiisObject:(Pii*)happening];
        if (comment)  e.comments = comment;
        if (dirty == YES)
        {
            [pfEventObject setObject:kEventType_Pii forKey:@"type"];
            [pfEventObject setObject:e.eventId forKey:kPiiId];
            [pfEventObject saveEventually];
        }
        
    } else if ([happening isKindOfClass:[Medz class]] )
    {
        e.type = kEventType_Medz;
        if (comment)  e.comments = comment;
        [e addMedzObject:(Medz*)happening];
        if (dirty == YES)
        {
            [pfEventObject setObject:kEventType_Medz forKey:@"type"];
            [pfEventObject setObject:e.eventId forKey:kMedzId];
            [pfEventObject saveEventually];
        }
        
    } else if ([happening isKindOfClass:[Sleep class]])
    {
        if (comment)  e.comments = comment;
        e.type = kEventType_Sleep;
        [e addSleepsObject:(Sleep*)happening];
        if (dirty == YES)
        {
            [pfEventObject setObject:kEventType_Sleep forKey:@"type"];
            [pfEventObject setObject:e.eventId forKey:kSleep];
            [pfEventObject saveEventually];
        }
    } else if ([happening isKindOfClass:[Diaper class]])
    {
        if (comment)  e.comments = comment;
        e.type = kEventType_Diaper;
        [e addDiapersObject:(Diaper*)happening];
    }
    NSLog(@"Created event with tit: %@, to baby: %@", [happening class], baby.name);
    NSLog(@"Created event with titID: %@::", eventId);
    
    return e;
}

-(NSArray *)getEventBelomigTObaby:(Baby *)baby
{
    NSArray *arr = [[SLKCoreDataService sharedService] fetchDataWithEntity:kEvent
                                                              andPredicate:[NSPredicate predicateWithFormat:@"baby == %@", baby]
                                                        andSortDescriptors:nil];
   // NSLog(@"\n\n\n getEventBelomigTObabyarr.count %d, BABYNAME: %@ \n\n", arr.count, baby.name);

    
    return [arr count] > 0 ? arr : nil;
}

-(NSArray *)getEventBelomigTObaby:(Baby *)baby andDay:(NSDate *)day
{
    NSArray *allEventOfBaby = [self getEventBelomigTObaby:baby];
    NSLog(@"allEventOfBabyallEventOfBaby: %d", allEventOfBaby.count);
    //[[SLKCoreDataService sharedService] fetchDataWithEntity:kEvent
//                                                                         andPredicate:[NSPredicate predicateWithFormat:@"baby == %@", baby]
//                                                                   andSortDescriptors:nil];
//    
    
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
        events = [[SLKCoreDataService sharedService] fetchDataWithEntity:kEvent
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

//Returns day (i.e 16june2013) event belonging to current baby
-(NSMutableArray*)getAllBabysEventSortedByDayAndDateBaby:(Baby *)baby
{
    NSArray *arry = [[self getAllDaysWithEventforBaby:baby] allValues];
    //  NSArray *arr = [[self getAllDaysWithEventforBaby:baby] allKeys];
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
   
    
    NSArray *sortedArray = [[NSArray alloc] init];
    
    sortedArray = [arry sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(Event*)b date];
        NSDate *second = [(Event*)a date];
        return [first compare:second];
    }];
    
    for (Event *event in sortedArray)
    {
        [returnArray addObject:event.day];
    }
    return returnArray;
}

-(NSMutableDictionary *)getAllDaysWithEventforBaby:(Baby *)baby
{
    NSArray *allEventOfBaby = [self getEventBelomigTObaby:baby];

    NSMutableDictionary *eventDict = [[NSMutableDictionary alloc] init];
    
    NSMutableSet *setOfDays = [[NSMutableSet alloc] init];
    for (Event *event in allEventOfBaby)
    {
        [setOfDays addObject:[SLKDateUtil formatDateWithDay: event.date]];
        NSString *dateKey = [SLKStringUtil removeAllBlanksAndMakeLowerCase:[SLKDateUtil formatDateWithDayMonthAndYear: event.date]];
        
        [eventDict setObject:event forKey:dateKey];
        //ex event with key 16 Jun 2013 

  }
    return eventDict;
}
//FOR WEEK
-(NSArray *)getEventBelomigTObaby:(Baby *)baby fromDate:(NSDate*)fromDate toDate:(NSDate*)toDate
{
    NSArray *allEventOfBaby = [[SLKCoreDataService sharedService] fetchDataWithEntity:kEvent
                                                                         andPredicate:[NSPredicate predicateWithFormat:@"baby == %@", baby]
                                                                   andSortDescriptors:nil];
    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (Event *event in allEventOfBaby)
    {
        NSComparisonResult compareParameterfromDateWithDateOfEvent = [fromDate compare:event.date];
        NSComparisonResult compareParametertoDateWithDateOfBlock = [toDate compare:event.date];
        
        if ((compareParameterfromDateWithDateOfEvent == NSOrderedAscending || compareParameterfromDateWithDateOfEvent== NSOrderedSame) && (compareParametertoDateWithDateOfBlock == NSOrderedDescending || compareParametertoDateWithDateOfBlock == NSOrderedSame))
        {
            [returnArray addObject:event];
        }
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    [returnArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    if ([returnArray count] == 0)  return nil;
    else      return returnArray;
    
}


-(Event *)getEventWithiD:(NSString *)eventId
{
    NSArray *arr = [[SLKCoreDataService sharedService] fetchDataWithEntity:kEvent
                                                              andPredicate:[NSPredicate predicateWithFormat:@"eventId == %@", eventId]
                                                        andSortDescriptors:nil];
    
    return [arr count] > 0 ? [arr lastObject] : nil;
    
}
-(void)removeEvent:(Event *)event
{
    [context deleteObject:event];
    PFObject *object = [PFObject objectWithoutDataWithClassName:kEvent
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
-(NSArray *)getEventByDate:(NSDate *)date
{
    NSArray *arr = [[SLKCoreDataService sharedService] fetchDataWithEntity:kEvent
                                                              andPredicate:[NSPredicate predicateWithFormat:@"date == %@", date]
                                                        andSortDescriptors:nil];
    
    return [arr count] > 0 ? [arr lastObject] : nil;
}

-(NSArray *)getEventByDay:(NSString *)day
{
    
    NSArray *arr = [[SLKCoreDataService sharedService] fetchDataWithEntity:kEvent
                                                              andPredicate:[NSPredicate predicateWithFormat:@"day == %@", day]
                                                        andSortDescriptors:nil];
    
    return [arr count] > 0 ? arr : nil;
}

-(NSArray *)getEventBelomigTObabyWithID:(NSString *)babyId
{
    Baby *currentBaby = [[SLKBabyStorage sharedStorage] getCurrentBaby];
    
    return [self getEventBelomigTObaby:currentBaby];
    
}

-(void)setLatestEvent:(NSDate *)date
{
    latestEvent = date;
    [SLKUserDefaults setLatestEvent:date];
    NSLog(@"latestevent == %@", latestEvent);
}

-(NSDate *)getLatestEvent
{
    return [SLKUserDefaults getLatestEvent];
    //return latestEvent;
}

-(NSArray *)eventArray
{
    return [[SLKCoreDataService sharedService] fetchDataWithEntity:kEvent
                                                      andPredicate:nil
                                                andSortDescriptors:nil];
}
-(NSMutableSet *)eventIdsSet
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (Event *event in [self getEventBelomigTObabyWithID:[SLKUserDefaults getTheCurrentBabe]])
    {
        if (event.eventId) {
            [arr addObject:event.eventId];
        }
    }
    NSMutableSet *eventset = [NSMutableSet setWithArray:arr];
    
    return eventset;
}

@end
