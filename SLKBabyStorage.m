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
    //TODO: only breate if baby witj id not already exists, otherwise just update them!!
    Baby *b = [NSEntityDescription insertNewObjectForEntityForName:@"Baby"
                                                      inManagedObjectContext:context];
    b.name = name;
    b.babyId = babyId;
    b.pii = pii;
    b.poo = poo;
    b.feedTimespan = feedTimespan;
    b.bottle = bottle;
    b.breast = breast;
    b.date = date;
    
    NSLog(@"There's a new baby in town! pee: %@", b.pii);
        NSLog(@"There's a new baby in town! poo: %@", b.poo);
    return b;
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
