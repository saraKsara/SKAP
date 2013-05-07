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
#import "SLKPARSEService.h"
#import <Parse/Parse.h>

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


-(Tits *)createTittWithStringValue:(NSString *)stringValue mililitres:(NSNumber *)milliLitres minutes:(NSNumber *)minutes leftBoob:(BOOL)leftBoob rightBoob:(BOOL)rightBoob
{
   Tits *t = [NSEntityDescription insertNewObjectForEntityForName:@"Tits"
                                          inManagedObjectContext:context];
    
    
    t.stringValue = stringValue;
    t.milliLitres = milliLitres;
    t.minutes = minutes;
    t.leftBoob = [NSNumber numberWithBool:leftBoob];
    t.rightBoob = [NSNumber numberWithBool:rightBoob];
    
       
  NSLog(@"Feeded baby with  %@", t);
    
    return t;
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
