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
    Pii *p = [NSEntityDescription insertNewObjectForEntityForName:@"Pii"
                                           inManagedObjectContext:context];
    
    p.dirty = [NSNumber numberWithBool:dirty];
    p.piiId = piiId;
    
//    p.didPee = [NSNumber numberWithBool:normal];
//    p.comment = comment;
    NSLog(@"Baby did pii:  %@", p);
    
    return p;
}

-(void)removePii:(Pii *)pii
{
    [context deleteObject:pii];
}

@end
