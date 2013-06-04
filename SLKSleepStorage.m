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
#import <Parse/Parse.h>
#import "SLKPARSEService.h"
#import "SLKConstants.h"

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

-(Sleep *)createSleepWithId:(NSString *)sleepId minutes:(NSNumber *)minutes dirty:(BOOL)dirty
{
    Sleep *z = [NSEntityDescription insertNewObjectForEntityForName:kSleep inManagedObjectContext:context];
    z.minutes = minutes;
    z.dirty = [NSNumber numberWithBool:dirty];
    z.sleepId = sleepId;
    
    if (dirty == YES) {
        {
            NSLog(@"\n\n Post and clean the sleep  %@\n\n", z.sleepId);
            PFObject *pfSleep = [PFObject objectWithClassName:kSleep];
            [pfSleep setObject: z.sleepId forKey:kSleepId];
              [pfSleep setObject: z.minutes forKey:@"minutes"];
            
            [SLKPARSEService postObject:pfSleep onSuccess:^(PFObject *obj) {
                NSLog(@"\n\n IS IT POSTED??? \n\n");
                
                NSLog(@"Suceccfully posted sleep with id %@",[obj objectForKey:kSleepId]);
                
                Sleep *sleepToClean = [self getSleepWithiD:[obj objectForKey:kSleepId]];
                
                sleepToClean.dirty = [NSNumber numberWithBool:NO];
                
            } onFailure:^(PFObject *obj) {
                NSLog(@"\n\n Failed to save object in Parse\n\n");
            }];
        }
    }
    NSLog(@"Baby did sleep:  %@", z);
    return z;
}
-(Sleep *)getSleepWithiD:(NSString *)sleepId
{
    NSArray *arr = [[SLKCoreDataService sharedService] fetchDataWithEntity:kSleep
                                                              andPredicate:[NSPredicate predicateWithFormat:@"sleepId == %@", sleepId]
                                                        andSortDescriptors:nil];
    
    return [arr count] > 0 ? [arr lastObject] : nil;
    
}

@end
