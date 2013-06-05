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

-(Event *)createEventwithDate:(NSDate *)date eventId:(NSString *)eventId tits:(NSSet *)tits pii:(NSSet *)pii poo:(NSSet *)poo bottles:(NSSet *)bottle adDrop:(BOOL)adDrop otherMedz:(NSString *)medz temperature:(NSNumber *)temp type:(NSString *)type timeSpan:(NSNumber *)timeSpan baby:(Baby *)baby sleep:(NSNumber*)sleep comments:(NSString *)comments
{
    NSLog(@"\n\n ÅSA TESTAR ATT HÄMTA DETTA EVENT::: %@ \n\n", eventId);
    Event *e;
    Event *eventInStorage = [self getEventWithiD:eventId];
    if (eventInStorage) {
        NSLog(@"the event already exists in core data, skipping creating a new, and updates existing baby instead.");
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
    
    return e;
}



-(Event *)createEvenWithHappening:(NSManagedObject *)happening withComment:(NSString *)comment date:(NSDate *)date eventId:(NSString *)eventId baby:(Baby *)baby dirty:(BOOL)dirty
{
    Event *e = [NSEntityDescription insertNewObjectForEntityForName:kEvent
                                             inManagedObjectContext:context];
    NSLog(@"\n\n ÅSA TESTAR ATT HÄMTA DETTA EVENT::: %@ \n\n", eventId);
    NSLog(@"Trying to createt:\n happening: %@ \n comment: %@\n date: %@ \n eventID: %@ \n baby: %@", happening, comment, date, eventId,baby.babyId);
    
    e.eventId = eventId;
    e.baby = baby;
    e.date = date;
    e.dirty = [NSNumber numberWithBool:dirty];
    
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
    
   
    
   // NSDictionary *paramDict =  @{@"objectId":@"qQnTDiem5K"};

//    [PFCloud callFunction:@"getBabies" withParameters:paramDict];
//    [PFCloud callFunctionInBackground:@"getBabies" withParameters:paramDict block:^(id object, NSError *error) {
//        if (!error) {
//            NSLog(@"Men hurray! %@", object);
//           
    
            
//            PFUser *user = [PFUser currentUser];
//            PFRelation *relation = [user relationforKey:@"posts"];
//            [relation addObject:post];
//            [user saveInBackground];
            
                     
            
//        } else {
//            NSLog(@"Men nooo!%@ %@", object, error);
//            
//            //avgPoint = nil;
//            //[avgButton setTitle:@"Sorry, not available!" forState:UIControlStateNormal];
//        }
//    }];
//    PFObject *babyObject = [PFObject objectWithClassName:@"Baby"];
//    [babyObject setObject:baby.name forKey:@"name"];
//    [babyObject setObject:baby.babyId forKey:@"objectId"];
    
 
    NSLog(@"Created event with tit: %@, to baby: %@", [happening class], baby.name);
    NSLog(@"Created event with titID: %@::", eventId);

    return e;
}


-(Event *)createNEEEWEvenWithType:(NSString *)type withComment:(NSString *)comment date:(NSDate *)date eventId:(NSString *)eventId baby:(NSString *)baby dirty:(BOOL)dirty
{
    
    
    Event *e = [NSEntityDescription insertNewObjectForEntityForName:kEvent
                                             inManagedObjectContext:context];
    
    e.eventId = eventId;
    e.baby.babyId = baby;
    e.date = date;
    e.dirty = [NSNumber numberWithBool:dirty];
    
    e.type = type;
    
    PFObject *pfEventObject = [PFObject objectWithClassName:kEvent];
    [pfEventObject setObject:baby forKey:kBabyId];
    
    [pfEventObject setObject:e.eventId forKey:@"eventId"];
    [pfEventObject setObject:e.date forKey:@"eventDate"];
    
    if ([type isEqualToString:kEventType_TitFood])
    {
        
       // [e addTitiesObject:(Tits*)happening];
        
        [pfEventObject setObject:kEventType_TitFood forKey:@"type"];
        [pfEventObject setObject:e.eventId forKey:@"titId"];
        [pfEventObject saveEventually];
        
        
    } else   if ([type isEqualToString:kEventType_BottleFood])
    {
      //  [e addBottlesObject:(Bottle*)happening];
        [pfEventObject setObject:e.eventId forKey:@"bottleId"];
        [pfEventObject setObject:kEventType_BottleFood forKey:@"type"];
        
        
    }  else   if ([type isEqualToString:kEventType_Poo])
    {
        if (comment)  e.comments = comment;
        //[e addPoosObject:(Poo*)happening];
    } else    if ([type isEqualToString:kEventType_Pii])
    {
      //  [e addPiisObject:(Pii*)happening];
        if (comment)  e.comments = comment;
        
    } else    if ([type isEqualToString:kEventType_Medz])
    {
        if (comment)  e.comments = comment;
       // [e addMedzObject:(Medz*)happening];
        
    } else    if ([type isEqualToString:kEventType_Sleep])
    {
        if (comment)  e.comments = comment;
        //[e addSleepsObject:(Sleep*)happening];
    } else    if ([type isEqualToString:kEventType_Diaper])
    {
        if (comment)  e.comments = comment;
        //[e addDiapersObject:(Diaper*)happening];
    }
    
    
    
//    NSLog(@"Created NEEEW event with tit: %@, to baby: %@", [happening class], baby);
    NSLog(@"Created NEEEW %@ event with titID: %@::",type , eventId);
    
    return e;
}

-(NSArray *)getEventBelomigTObaby:(Baby *)baby
{
    NSArray *arr = [[SLKCoreDataService sharedService] fetchDataWithEntity:kEvent
                                                                         andPredicate:[NSPredicate predicateWithFormat:@"baby == %@", baby]
                                                                   andSortDescriptors:nil];
    
    return [arr count] > 0 ? arr : nil;
}

-(NSArray *)getEventBelomigTObaby:(Baby *)baby andDay:(NSDate *)day{
    NSArray *allEventOfBaby = [[SLKCoreDataService sharedService] fetchDataWithEntity:kEvent
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
-(NSArray *)getEventByDay:(NSDate *)date
{
    NSArray *arr = [[SLKCoreDataService sharedService] fetchDataWithEntity:kEvent
                                                              andPredicate:[NSPredicate predicateWithFormat:@"date == %@", date]
                                                        andSortDescriptors:nil];
    
    return [arr count] > 0 ? [arr lastObject] : nil;
}

-(NSArray *)eventArray
{
//    for (Event *event in [self eventArray])
//    {
//        if (event.eventId) {
//           NSLog(@"ebebbbebe%@", event.eventId);
//        }
//        
//    }
    return [[SLKCoreDataService sharedService]fetchDataWithEntity:kEvent];
}

-(NSMutableSet *)eventIdsSet
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (Event *event in [self eventArray])
    {
        if (event.eventId) {
            [arr addObject:event.eventId];
        }
    }
    NSMutableSet *eventset = [NSMutableSet setWithArray:arr];
   // NSLog(@"eventIdsSet--- %@", eventset);

   return eventset;
}

@end
