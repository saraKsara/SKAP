//
//  SLKMedzStorage.m
//  SKAP
//
//  Created by Åsa Persson on 2013-04-03.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKMedzStorage.h"
#import "SLKCoreDataService.h"
#import "Medz.h"
#import "Event.h"
@implementation SLKMedzStorage
{
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
    
}


+(SLKMedzStorage*) sharedStorage
{
    static SLKMedzStorage *sharedStorage;
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


-(Medz *)createMedzWithId:(NSString *)medsId Temp:(NSNumber *)temp adDrop:(BOOL)adDrop paracetamol:(BOOL)paracetamol ibuprofen:(BOOL)ibuprofen more:(NSSet *)more dirty:(BOOL)dirty
{
    Medz *m = [NSEntityDescription insertNewObjectForEntityForName:@"Medz"
                                            inManagedObjectContext:context];
    m.temp = temp;
    m.adDrop =[NSNumber numberWithBool:adDrop];
    m.paracetamol = [NSNumber numberWithBool:paracetamol];
    m.ibuprofen = [NSNumber numberWithBool:ibuprofen];
    m.more = more;
    m.dirty = [NSNumber numberWithBool:dirty];
    m.medzId = medsId;
    
    NSLog(@"Gave baby some meds:  %@", m);
    
    return m;
}
-(void)removeMedz:(Medz *)medecine
{
    [context deleteObject:medecine];
}
@end
