//
//  SLKSleepStorage.m
//  SKAP
//
//  Created by Student vid Yrkeshögskola C3L on 4/9/13.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKSleepStorage.h"
#import "Sleep.h"
#import "SLKCoreDataService.h"

@implementation SLKSleepStorage
{
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
}

+(SLKSleepStorage*)sharedStorage
{
    static SLKSleepStorage *sharedStorage;
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

-(Sleep*)createSleep:(NSNumber *)minutes
{
    Sleep *z = [NSEntityDescription insertNewObjectForEntityForName:@"Sleep" inManagedObjectContext:context];
    z.minutes = minutes;
    
    NSLog(@"created Sleep");
    return z;
}

@end
