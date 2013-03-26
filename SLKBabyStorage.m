//
//  SLKBabyStorage.m
//  SKAP
//
//  Created by Student vid Yrkeshögskola C3L on 3/19/13.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//
#import "SLKCoreDataService.h"
#import "SLKBabyStorage.h"
#import "Baby.h"
#import "SLKUserDefaults.h"

@implementation SLKBabyStorage
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

-(Baby *)createBabyWithName:(NSString *)name babyId:(NSString *)babyId pii:(NSNumber *)pii poo:(NSNumber *)poo feedTimespan:(NSNumber *)feedTimespan bottle:(NSNumber *)bottle breast:(NSNumber *)breast date:(NSDate *)date
{
    Baby *b;
    Baby *babeInStorage = [self getBabyWithiD:babyId];
    if (babeInStorage) {
        NSLog(@"the baby already exists in core data, skipping creating a new, and updates existing baby instead.");
        b = babeInStorage;
        
    } else {
    b = [NSEntityDescription insertNewObjectForEntityForName:@"Baby"
                                                      inManagedObjectContext:context];
    }
    
    b.name = name;
    b.babyId = babyId;
    b.pii = pii;
    b.poo = poo;
    b.feedTimespan = feedTimespan;
    b.bottle = bottle;
    b.breast = breast;
    b.date = date;
    
    NSLog(@"There's a new (or a updated babe) baby in town! name: %@", b.name);
        NSLog(@"There's a new (or a updated babe) baby in town! breast: %@", b.poo);
    return b;
}
-(void)setCurrentBaby:(Baby *)baby
{
    [SLKUserDefaults setTheCurrentBabe:baby.babyId];
    NSLog(@"(baby storage) The current babe is: %@", baby.name);
}
-(Baby *)getCurrentBaby;
{
    return [self getBabyWithiD:[SLKUserDefaults getTheCurrentBabe]];
}

-(void)removeBaby:(Baby*)baby
{
    [context deleteObject:baby];
}

-(Baby *)getBabyWithiD:(NSString *)babyId
{
    NSArray *arr = [[SLKCoreDataService sharedService] fetchDataWithEntity:@"Baby"
                                                             andPredicate:[NSPredicate predicateWithFormat:@"babyId == %@", babyId]
                                                       andSortDescriptors:nil];
    
    return [arr count] > 0 ? [arr lastObject] : nil;
  
}

-(NSArray*)babyArray
{
  return [[SLKCoreDataService sharedService]fetchDataWithEntity:@"Baby"];
}



@end
