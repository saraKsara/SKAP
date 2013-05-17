//
//  SLKTittStorage.m
//  SKAP
//
//  Created by Åsa Persson on 2013-03-29.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKTittStorage.h"
#import "SLKCoreDataService.h"
#import "Tits.h"
#import "Event.h"
#import <Parse/Parse.h>
#import "SLKPARSEService.h"
#import "SLKConstants.h"

@implementation SLKTittStorage
{
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
    
}


+(SLKTittStorage*) sharedStorage
{
    static SLKTittStorage *sharedStorage;
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


-(Tits *)createTittWithId:(NSString *)titId StringValue:(NSString *)stringValue mililitres:(NSNumber *)milliLitres minutes:(NSNumber *)minutes leftBoob:(BOOL)leftBoob rightBoob:(BOOL)rightBoob dirty:(BOOL)dirty
{
   Tits *t = [NSEntityDescription insertNewObjectForEntityForName:kTits
                                          inManagedObjectContext:context];
    
    t.titId = titId;
    t.stringValue = stringValue;
    t.milliLitres = milliLitres;
    t.minutes = minutes;
    t.leftBoob = [NSNumber numberWithBool:leftBoob];
    t.rightBoob = [NSNumber numberWithBool:rightBoob];
    t.dirty = [NSNumber numberWithBool:dirty];
    
    PFObject *pfTits = [PFObject objectWithClassName:kTits];
    [pfTits setObject: t.stringValue forKey:@"stringValue"];
    [pfTits setObject: [NSNumber numberWithBool:rightBoob] forKey:@"rightBoob"];
    [pfTits setObject: [NSNumber numberWithBool:leftBoob] forKey:@"leftBoob"];
    [pfTits setObject: t.titId forKey:@"titId"];
    
   // [pfTits saveEventually];
    [SLKPARSEService postObject:pfTits onSuccess:^(PFObject *obj) {
        
   Tits *titToClean = [self getTitWithiD:[obj objectForKey:@"titId"]];
        
       titToClean.dirty = [NSNumber numberWithBool:NO];
        
    } onFailure:^(PFObject *obj) {
     NSLog(@"Failed to save object in Parse");
    }];
    
  NSLog(@"Feeded baby with  %@", t);
    
    return t;
}

-(Tits *)getTitWithiD:(NSString *)titId
{
    NSArray *arr = [[SLKCoreDataService sharedService] fetchDataWithEntity:@"Tits"
                                                              andPredicate:[NSPredicate predicateWithFormat:@"titId == %@", titId]
                                                        andSortDescriptors:nil];
    
    return [arr count] > 0 ? [arr lastObject] : nil;
    
}

-(Tits *)getTitThatBelongsToEvent:(Event *)event
{
    NSArray *arr = [[SLKCoreDataService sharedService] fetchDataWithEntity:@"Tits"
                                                              andPredicate:[NSPredicate predicateWithFormat:@"event == %@", event]
                                                        andSortDescriptors:nil];
    
    return [arr count] > 0 ? [arr lastObject] : nil;
}
-(void)removeTitmilk:(Tits*)tit
{
        [context deleteObject:tit];
}
@end
