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


-(Medz *)createMedzWithTemp:(NSNumber *)temp adDrop:(BOOL)adDrop paracetamol:(BOOL)paracetamol ibuprofen:(BOOL)ibuprofen more:(NSSet *)more
{
    Medz *m = [NSEntityDescription insertNewObjectForEntityForName:@"Medz"
                                            inManagedObjectContext:context];
    m.temp = temp;
    m.adDrop =[NSNumber numberWithBool:adDrop];
    m.paracetamol = [NSNumber numberWithBool:paracetamol];
    m.ibuprofen = [NSNumber numberWithBool:ibuprofen];
  //  m.more = more;
    
    NSLog(@"Gave baby some meds:  %@", m);
    
    return m;
}
-(void)removeTitmilk:(Tits*)tit
{
    [context deleteObject:tit];
}
@end
