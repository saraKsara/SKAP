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

-(Baby*)createBabyWithName:(NSString*)name babyId:(NSString*)babyId date:(NSDate*)date type:(NSString*)type
{
    Baby *b;
    Baby *babeInStorage = [self getBabyWithiD:babyId];
    if (babeInStorage) {
     
        b = babeInStorage;
        
    } else {
    b = [NSEntityDescription insertNewObjectForEntityForName:@"Baby"
                                                      inManagedObjectContext:context];
    }
    
    b.name = name;
    b.babyId = babyId;
    b.date = date;
    b.type = type;
    
   // NSLog(@"There's a new (or a updated babe) baby in town! name: %@  id: %@", b.name, b.babyId);
      
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
