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
    Poo *p = [NSEntityDescription insertNewObjectForEntityForName:@"Poo"
                                            inManagedObjectContext:context];
    
    p.dirty = [NSNumber numberWithBool:dirty];
    p.pooId = pooId;
//    p.didPoop = [NSNumber numberWithBool:normal];
//    p.comment = comment;
    NSLog(@"Baby did poo:  %@", p);
    
    return p;
}

-(void)removePoo:(Poo *)poo
{
    [context deleteObject:poo];
}
@end
