//
//  SLKJSONService.m
//  SKAP
//
//  Created by Åsa Persson on 2013-03-22.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKPARSEService.h"
#import "SLKBabyStorage.h"
#import "Baby.h"
#import "SLKAppDelegate.h"
#import "SLKPfSingupViewController.h"
#import "SLKUserDefaults.h"
#import "SLKParentStorage.h"
#import "ParentFigures.h"
#import "Event.h"
#import "SLKEventStorage.h"
#import <Parse/Parse.h>
#import "SLKTittStorage.h"
#import "Tits.h"
#import "SLKConstants.h"
#import "SLKBottleStorage.h"
#import "Bottle.h"
#import "Poo.h"
#import "Pii.h"
#import "SLKPooStorage.h"
#import "SLKPiiStorage.h"
#import "Sleep.h"
#import "Medz.h"
#import "SLKSleepStorage.h"
#import "SLKMedzStorage.h"
@implementation SLKPARSEService


+(void)getNewEvents
{
    NSString* bId = [[PFUser currentUser] objectForKey:kBabyId];
    NSDate *latestEventUpdate = [SLKUserDefaults getLatestEvent];
    NSLog(@"getNewEvents, latestEvent: %@", latestEventUpdate);
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"babyId = %@", bId];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"updatedAt > %@", latestEventUpdate];
    NSArray *subpredicates = [NSArray arrayWithObjects:predicate1, predicate2, nil];
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
    PFQuery *q = [PFQuery queryWithClassName:kEvent predicate:predicate];
    
    [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *eventIds = [[NSMutableArray alloc] init];
            if (objects.count > 0)
            {
                
                for (int i = 0; i < [objects count]; i++)
                {
                    [eventIds addObject:[[objects objectAtIndex:i] objectForKey:kEventId]];
                }
                [self getAllEventswithId:eventIds];
                
            }
            else{
                //   [self getAllEventswithId:nil];
                NSLog(@"User aldready up tp date");
            }
        }
    }];
}

+(void)getAllEventswithId:(NSMutableArray *)eventIds
{
    PFQuery *query = [PFQuery queryWithClassName:kEvent];
    if (eventIds)
    {
        [query whereKey:kEventId containedIn:eventIds]; //only new events
        NSLog(@"getAllEventswithId, only new events");
    }
    else //first time user, get all events belonging to the baby... Or??
    {
        NSString* bId = [[PFUser currentUser] objectForKey:kBabyId];
        NSLog(@"getAllEventswithId");
        
        [query whereKey:kBabyId equalTo:bId]; //TODO, this is only for one baby...
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"\nfindObjectsInBackgroundWithBlock: %@, %dst\n", objects.class, objects.count);
            
            /*
             Set timestamp!
             How often should we check for new events?? Or only listen to push??
             */
            if (objects.count > 0) {
                
                NSLog(@"Successfully retrieved: %@", objects.class);
                
                for (int i = 0; i < [objects count]; i++)
                {
                    NSMutableSet *events = [[SLKEventStorage sharedStorage] eventIdsSet];
                    
                    //If there's no event with that id in eventstorage, create it!
                    if (![events containsObject:[[objects objectAtIndex:i] objectForKey:@"eventId"]])
                    {
                        Baby *currentBaby = [[SLKBabyStorage sharedStorage] getCurrentBaby];
                        
                        if ([[[objects objectAtIndex:i]objectForKey:@"type"] isEqualToString: kEventType_TitFood]) {
                            
                            [self getObjectId:[[objects objectAtIndex:i]objectForKey:@"eventId"] forKey:kTitId withClassName:kTits onSuccess:^(NSManagedObject *obj) {
                                //                        [self getTitsWithId:[[objects objectAtIndex:i]objectForKey:@"eventId"] onSuccess:^(NSManagedObject *obj)
                                //                         {
                                Tits *tittie = (Tits*)obj;
                                [[SLKEventStorage sharedStorage]createEvenWithHappening:tittie
                                                                            withComment:@"a fake comment"//[[objects objectAtIndex:i] objectForKey:@"comment"]
                                                                                   date:[[objects objectAtIndex:i] objectForKey:@"eventDate"]
                                                                                eventId:[[objects objectAtIndex:i]objectForKey:@"eventId"]
                                                                                   baby:currentBaby
                                                                                  dirty:NO];
                            } onFailure:^(NSManagedObject *obj)
                             {
                             }];
                        }
                        else if ([[[objects objectAtIndex:i]objectForKey:@"type"] isEqualToString: kEventType_BottleFood])
                        {
                            [self getBottleWithId:[[objects objectAtIndex:i]objectForKey:@"eventId"] onSuccess:^(NSManagedObject *obj)
                             {
                                 Bottle *bottle = (Bottle*)obj;
                                 NSLog(@"\n\n ON SUCCESS: %@ \n\n", bottle.bottleId);
                                 
                                 NSLog(@"\n\n can I still reach objects??? %@ \n\n",[[objects objectAtIndex:i]objectForKey:@"milliLitres"]);
                                 
                                 
                                 [[SLKEventStorage sharedStorage]createEvenWithHappening:bottle
                                                                             withComment:@"a fake comment"//[[objects objectAtIndex:i] objectForKey:@"comment"]
                                                                                    date:[[objects objectAtIndex:i] objectForKey:@"eventDate"]
                                                                                 eventId:[[objects objectAtIndex:i]objectForKey:@"eventId"]
                                                                                    baby:currentBaby
                                                                                   dirty:NO];
                                 
                             } onFailure:^(NSManagedObject *obj)
                             {
                             }];
                        }
                        else if ([[[objects objectAtIndex:i]objectForKey:@"type"] isEqualToString: kEventType_Poo])
                        {
                            [self getPooWithId:[[objects objectAtIndex:i]objectForKey:@"eventId"] onSuccess:^(NSManagedObject *obj)
                             {
                                 Poo *p = (Poo*)obj;
                                 NSLog(@"\n\n ON SUCCESS: %@ \n\n", p.pooId);
                                 
                                 [[SLKEventStorage sharedStorage]createEvenWithHappening:p
                                                                             withComment:@"a fake comment"//[[objects objectAtIndex:i] objectForKey:@"comment"]
                                                                                    date:[[objects objectAtIndex:i] objectForKey:@"eventDate"]
                                                                                 eventId:[[objects objectAtIndex:i]objectForKey:@"eventId"]
                                                                                    baby:currentBaby
                                                                                   dirty:NO];
                                 
                             } onFailure:^(NSManagedObject *obj)
                             {
                             }];
                        }
                        else if ([[[objects objectAtIndex:i]objectForKey:@"type"] isEqualToString: kEventType_Pii])
                        {
                            [self getPiiWithId:[[objects objectAtIndex:i]objectForKey:@"eventId"] onSuccess:^(NSManagedObject *obj)
                             {
                                 Pii *p = (Pii*)obj;
                                 NSLog(@"\n\n ON SUCCESS: %@ \n\n", p.piiId);
                                 
                                 [[SLKEventStorage sharedStorage]createEvenWithHappening:p
                                                                             withComment:@"a fake comment"//[[objects objectAtIndex:i] objectForKey:@"comment"]
                                                                                    date:[[objects objectAtIndex:i] objectForKey:@"eventDate"]
                                                                                 eventId:[[objects objectAtIndex:i]objectForKey:@"eventId"]
                                                                                    baby:currentBaby
                                                                                   dirty:NO];
                                 
                             } onFailure:^(NSManagedObject *obj)
                             {
                             }];
                        }
                        else if ([[[objects objectAtIndex:i]objectForKey:@"type"] isEqualToString: kEventType_Medz])
                        {
                            [self getMedzWithId:[[objects objectAtIndex:i]objectForKey:@"eventId"] onSuccess:^(NSManagedObject *obj)
                             {
                                 Medz *med = (Medz*)obj;
                                 NSLog(@"\n\n ON SUCCESS: %@ \n\n", med.medzId);
                                 
                                 [[SLKEventStorage sharedStorage]createEvenWithHappening:med
                                                                             withComment:@"a fake comment"//[[objects objectAtIndex:i] objectForKey:@"comment"]
                                                                                    date:[[objects objectAtIndex:i] objectForKey:@"eventDate"]
                                                                                 eventId:[[objects objectAtIndex:i]objectForKey:@"eventId"]
                                                                                    baby:currentBaby
                                                                                   dirty:NO];
                                 
                             } onFailure:^(NSManagedObject *obj)
                             {
                             }];
                        }
                        else if ([[[objects objectAtIndex:i]objectForKey:@"type"] isEqualToString: kEventType_Sleep])
                        {
                            [self getSleepWithId:[[objects objectAtIndex:i]objectForKey:@"eventId"] onSuccess:^(NSManagedObject *obj)
                             {
                                 Sleep *sleep = (Sleep*)obj;
                                 NSLog(@"\n\n ON SUCCESS: %@ \n\n", sleep.sleepId);
                                 
                                 [[SLKEventStorage sharedStorage]createEvenWithHappening:sleep
                                                                             withComment:@"a fake comment"//[[objects objectAtIndex:i] objectForKey:@"comment"]
                                                                                    date:[[objects objectAtIndex:i] objectForKey:@"eventDate"]
                                                                                 eventId:[[objects objectAtIndex:i]objectForKey:@"eventId"]
                                                                                    baby:currentBaby
                                                                                   dirty:NO];
                                 
                             } onFailure:^(NSManagedObject *obj)
                             {
                             }];
                        }
                        [SLKUserDefaults setLatestEvent:[NSDate date]]; //TODO: move this to blockcallbaack???
                        
                        
                    } else {
                        NSLog(@"\n\n Event with %@ already exists, does SKIPPING to create it\n\n",[[objects objectAtIndex:i] objectForKey:@"eventId"]);
                    }
                }
                
            }
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error, could not get all events: %@", errorString);
            
        }
    }];
    
}
+(void)getPooWithId:(NSString *)pooId onSuccess:(void (^)(NSManagedObject *))successObject onFailure:(void (^)(NSManagedObject *))failureObject
{
    PFQuery *pQuery = [PFQuery queryWithClassName:kPoo];
    [pQuery whereKey:kPooId equalTo:pooId];
    
    [pQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved getPoosWithId: %d", objects.count);
            Poo *p;
            for (int i = 0; i < [objects count]; i++)
            {
                NSLog(@"got this poo : %@", [objects objectAtIndex:i]);
                
                p = [[SLKPooStorage sharedStorage] createPooWithId:[[objects objectAtIndex:i] objectForKey:kPooId] dirty:NO];
                
            }
            successObject(p);
            
            
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}
+(void)getPiiWithId:(NSString *)piiId onSuccess:(void (^)(NSManagedObject *))successObject onFailure:(void (^)(NSManagedObject *))failureObject
{
    PFQuery *pQuery = [PFQuery queryWithClassName:kPii];
    [pQuery whereKey:kPiiId equalTo:piiId];
    
    [pQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved getPiisWithId: %d", objects.count);
            Pii *p;
            for (int i = 0; i < [objects count]; i++)
            {
                NSLog(@"got this pii : %@", [objects objectAtIndex:i]);
                
                p = [[SLKPiiStorage sharedStorage] createPiiWithId:[[objects objectAtIndex:i] objectForKey:kPiiId] dirty:NO];
                
            }
            successObject(p);
            
            
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}
+(void)getMedzWithId:(NSString *)medzId onSuccess:(void (^)(NSManagedObject *))successObject onFailure:(void (^)(NSManagedObject *))failureObject
{
    PFQuery *pQuery = [PFQuery queryWithClassName:kMedz];
    [pQuery whereKey:kMedzId equalTo:medzId];
    
    [pQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved getMedsWithId: %d", objects.count);
            Medz *med;
            for (int i = 0; i < [objects count]; i++)
            {
                NSLog(@"got this med : %@", [objects objectAtIndex:i]);
                
                med = [[SLKMedzStorage sharedStorage] createMedzWithId:[[objects objectAtIndex:i] objectForKey:kMedzId]
                                                                  Temp:[[objects objectAtIndex:i] objectForKey:@"temp"]
                                                                adDrop:[[objects objectAtIndex:i] objectForKey:@"adDrop"]
                                                           paracetamol:[[objects objectAtIndex:i] objectForKey:@"paracetamol"]
                                                             ibuprofen:[[objects objectAtIndex:i] objectForKey:@"ibuprofen"]
                                                                  more:[[objects objectAtIndex:i] objectForKey:@"more"]
                                                                 dirty:NO];
                
            }
            successObject(med);
            
            
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}
+(void)getSleepWithId:(NSString *)sleepId onSuccess:(void (^)(NSManagedObject *))successObject onFailure:(void (^)(NSManagedObject *))failureObject
{
    PFQuery *pQuery = [PFQuery queryWithClassName:kSleep];
    [pQuery whereKey:kSleepId equalTo:sleepId];
    
    [pQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved getsleepWithId: %d", objects.count);
            Sleep *sleep;
            for (int i = 0; i < [objects count]; i++)
            {
                NSLog(@"got this sleep : %@", [objects objectAtIndex:i]);
                
                sleep =  [[SLKSleepStorage sharedStorage] createSleepWithId:[[objects objectAtIndex:i] objectForKey:kSleepId]
                                                                    minutes:[[objects objectAtIndex:i] objectForKey:@"minutes"]
                                                                      dirty:NO];
                
            }
            successObject(sleep);
            
            
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}
+(void)getObjectId:(NSString *)objId forKey:(NSString*)key withClassName:(NSString*)className onSuccess:(void (^)(NSManagedObject *))successObject onFailure:(void (^)(NSManagedObject *))failureObject
{
    PFQuery *pQuery = [PFQuery queryWithClassName:className];
    [pQuery whereKey:key equalTo:objId];
    
    [pQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved object %d", objects.count);
            NSManagedObject *object;
            for (int i = 0; i < [objects count]; i++)
            {
                
                if ([className isEqualToString:kTits]) {
                }
                
                NSLog(@"got this object : %@", [objects objectAtIndex:i]);
                
                object = (Tits*)[[SLKTittStorage sharedStorage]
                                 createTittWithId:[[objects objectAtIndex:i] objectForKey:kTitId]
                                 StringValue:[[objects objectAtIndex:i] objectForKey:@"stringValue"]
                                 mililitres:nil
                                 minutes:nil
                                 leftBoob:(BOOL)[[objects objectAtIndex:i] valueForKey:@"rightBoob"]
                                 rightBoob:(BOOL)[[objects objectAtIndex:i] valueForKey:@"leftBoob"]
                                 dirty:NO];
                
            }
            successObject(object);
            
            
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}
+(void)getTitsWithId:(NSString *)titId onSuccess:(void (^)(NSManagedObject *))successObject onFailure:(void (^)(NSManagedObject *))failureObject
{
    PFQuery *pQuery = [PFQuery queryWithClassName:kTits];
    [pQuery whereKey:kTitId equalTo:titId];
    
    [pQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved getTitsWithId: %d", objects.count);
            Tits *tit;
            for (int i = 0; i < [objects count]; i++)
            {
                NSLog(@"got this tit : %@", [objects objectAtIndex:i]);
                
                tit =  [[SLKTittStorage sharedStorage]
                        createTittWithId:[[objects objectAtIndex:i] objectForKey:kTitId]
                        StringValue:[[objects objectAtIndex:i] objectForKey:@"stringValue"]
                        mililitres:nil
                        minutes:nil
                        leftBoob:(BOOL)[[objects objectAtIndex:i] valueForKey:@"rightBoob"]
                        rightBoob:(BOOL)[[objects objectAtIndex:i] valueForKey:@"leftBoob"]
                        dirty:NO];
                
            }
            successObject(tit);
            
            
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}

+(void)getBottleWithId:(NSString *)bottleId onSuccess:(void (^)(NSManagedObject *))successObject onFailure:(void (^)(NSManagedObject *))failureObject
{
    PFQuery *pQuery = [PFQuery queryWithClassName:kBottle];
    [pQuery whereKey:kBottleId equalTo:bottleId];
    
    [pQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved getBOTTLEWithId: %d", objects.count);
            Bottle *bottle;
            for (int i = 0; i < [objects count]; i++)
            {
                NSLog(@"got this bottle : %@", [objects objectAtIndex:i]);
                // NSLog(@"BABY : %@", [[objects objectAtIndex:i] allKeys]);
                
                bottle = [[SLKBottleStorage sharedStorage] createBottleWithId:[[objects objectAtIndex:i] objectForKey:kBottleId]
                                                                  stringValue:[[objects objectAtIndex:i] objectForKey:@"stringValue"] mililitres:[[objects objectAtIndex:i] objectForKey:@"milliLitres"] minutes:[[objects objectAtIndex:i] objectForKey:@"minutes"]
                                                                        dirty:NO];
                NSLog(@"sending bottle to success: %@", bottle);
                
            }
            successObject(bottle);
            
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}
+(void)getBabyWithId:(NSString*)babyId onSuccess:(void (^)(PFObject *))successObject onFailure:(void (^)(PFObject *))failureObject
{
    PFQuery *pQuery = [PFQuery queryWithClassName:kBaby];
    [pQuery whereKey:kBabyId equalTo:babyId];
    
    NSString* bId = [[PFUser currentUser] objectForKey:kBabyId];
    NSLog(@"babbyID belonging to parent in parseservice: %@", bId);
    
    [pQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved babies %d", objects.count);
            // NSLog(@"----------%@",[objects objectAtIndex:0]);
            if (objects.count > 0){
                for (int i = 0; i < [objects count]; i++)
                {
                    NSLog(@"Getting BABYname : %@", [[objects objectAtIndex:i] objectForKey:@"name"]);
                    NSLog(@" getting BABY : %@", [[objects objectAtIndex:i] allKeys]);
                    [[SLKBabyStorage sharedStorage] createBabyWithName:[[objects objectAtIndex:i] objectForKey:@"name"]
                                                                babyId:[[objects objectAtIndex:i] objectForKey:kBabyId]
                                                                  date:[NSDate date]
                                                                  type:[[objects objectAtIndex:i] objectForKey:@"type"]
                                                                 color:[[objects objectAtIndex:i] objectForKey:@"color"]
                                                                 dirty:NO];
                }
                successObject([objects lastObject]);
            } else NSLog(@"There is no baby with id %@", babyId);
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
    
}



+(void)getParentWithUserName:(NSString*)pName
{
    //SLKPfSingupViewController  *suv;
    // NSMutableString *s = suv.usernamefromSignUp;
    
    PFQuery *pQuery = [PFQuery queryWithClassName:@"PFUser"];
    [pQuery whereKey:@"username" equalTo:pName];
    NSLog(@"----%@", pName);
    
    
    [pQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved: %@", objects.class);
            for (int i = 0; i < [objects count]; i++)
            {
                
                [[SLKParentStorage sharedStorage]createParentWithName:[[objects objectAtIndex:i] objectForKey:@"username"]
                                                            signature:nil
                                                             parentId:[[objects objectAtIndex:i]objectId]
                                                               number:nil
                                                                color:nil
                                                               babies:nil
                                                                dirty:NO];
                
            }
            
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}

+(void)postObject:(PFObject *)object onSuccess:(void (^)(PFObject *))successObject onFailure:(void (^)(PFObject *))failureObject
{
    [object saveEventually:^(BOOL succeeded, NSError *error) {
        
        if (succeeded){
            //TODO: what to do when there is no internet connection?? saveEventually whe no internet, and save wit block if there IS connection
            NSLog(@"Object Uploaded: %@", object);
            successObject(object);
        }
        else{
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
        
    }];
}

+(void)deleteObject:(PFObject *)object
{
    [object deleteInBackground];
    
}


@end