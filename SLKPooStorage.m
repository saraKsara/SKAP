//
//  SLKPooStorage.m
//  SKAP
//
//  Created by Åsa Persson on 2013-03-30.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKPooStorage.h"
#import "SLKCoreDataService.h"
#import "Poo.h"
#import <Parse/Parse.h>
#import "SLKPARSEService.h"
#import "SLKConstants.h"
@implementation SLKPooStorage
{
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
    
}


+(SLKPooStorage*) sharedStorage
{
    static SLKPooStorage *sharedStorage;
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


-(Poo *)createPooWithId:(NSString *)pooId dirty:(BOOL)dirty
{
    Poo *p = [NSEntityDescription insertNewObjectForEntityForName:kPoo
                                            inManagedObjectContext:context];
    
    p.dirty = [NSNumber numberWithBool:dirty];
    p.pooId = pooId;
//    p.didPoop = [NSNumber numberWithBool:normal];
//    p.comment = comment;
     if (dirty == YES) {
         {
             NSLog(@"\n\n Post and clean the poo  %@\n\n", p.pooId);
             PFObject *pfPoo = [PFObject objectWithClassName:kPoo];
             [pfPoo setObject: p.pooId forKey:kPooId];
             
             [SLKPARSEService postObject:pfPoo onSuccess:^(PFObject *obj) {
                 NSLog(@"\n\n IS IT POSTED??? \n\n");
                 
                 NSLog(@"Suceccfully posted poo with id %@",[obj objectForKey:kPooId]);
                 
                 Poo *pooToClean = [self getPooWithiD:[obj objectForKey:kPooId]];
                 
                 pooToClean.dirty = [NSNumber numberWithBool:NO];
                 
             } onFailure:^(PFObject *obj) {
                 NSLog(@"\n\n Failed to save object in Parse\n\n");
             }];
         }
     }
    NSLog(@"Baby did poo:  %@", p);
    
    return p;
}
-(Poo *)getPooWithiD:(NSString *)pooId
{
    NSArray *arr = [[SLKCoreDataService sharedService] fetchDataWithEntity:kPoo
                                                              andPredicate:[NSPredicate predicateWithFormat:@"pooId == %@", pooId]
                                                        andSortDescriptors:nil];
    
    return [arr count] > 0 ? [arr lastObject] : nil;
    
}

-(void)removePoo:(Poo *)poo
{
    [context deleteObject:poo];
}
@end
