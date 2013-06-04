//
//  SLKPiiStorage.m
//  SKAP
//
//  Created by Åsa Persson on 2013-03-30.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKPiiStorage.h"
#import "SLKCoreDataService.h"
#import "Pii.h"
#import <Parse/Parse.h>
#import "SLKPARSEService.h"
#import "SLKConstants.h"
@implementation SLKPiiStorage
{
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
    
}


+(SLKPiiStorage*) sharedStorage
{
    static SLKPiiStorage *sharedStorage;
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


-(Pii *)createPiiWithId:(NSString *)piiId dirty:(BOOL)dirty
{
    Pii *p = [NSEntityDescription insertNewObjectForEntityForName:kPii
                                           inManagedObjectContext:context];
    
    p.dirty = [NSNumber numberWithBool:dirty];
    p.piiId = piiId;
    
    if (dirty == YES) {
        {
            NSLog(@"\n\n Post and clean the poo  %@\n\n", p.piiId);
            PFObject *pfPii = [PFObject objectWithClassName:kPii];
            [pfPii setObject: p.piiId forKey:kPiiId];
            
            [SLKPARSEService postObject:pfPii onSuccess:^(PFObject *obj) {
                NSLog(@"\n\n IS IT POSTED??? \n\n");
                
                NSLog(@"Suceccfully posted pii with id %@",[obj objectForKey:kPiiId]);
                
                Pii *piiToClean = [self getPiiWithiD:[obj objectForKey:kPiiId]];
                
                piiToClean.dirty = [NSNumber numberWithBool:NO];
                
            } onFailure:^(PFObject *obj) {
                NSLog(@"\n\n Failed to save object in Parse\n\n");
            }];
        }
    }
    NSLog(@"Baby did poo:  %@", p);
    return p;
}
-(Pii *)getPiiWithiD:(NSString *)piiId
{
    NSArray *arr = [[SLKCoreDataService sharedService] fetchDataWithEntity:kPii
                                                              andPredicate:[NSPredicate predicateWithFormat:@"piiId == %@", piiId]
                                                        andSortDescriptors:nil];
    
    return [arr count] > 0 ? [arr lastObject] : nil;
    
}


-(void)removePii:(Pii *)pii
{
    [context deleteObject:pii];
}

@end
