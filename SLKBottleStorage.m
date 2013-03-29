//
//  SLKBottleStorage.m
//  SKAP
//
//  Created by Åsa Persson on 2013-03-29.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKBottleStorage.h"
#import "SLKCoreDataService.h"
#import "Bottle.h"
@implementation SLKBottleStorage
{
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
    
}


+(SLKBottleStorage*) sharedStorage
{
    static SLKBottleStorage *sharedStorage;
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


-(Bottle *)createBottleWithStringValue:(NSString *)stringValue mililitres:(NSNumber *)milliLitres minutes:(NSNumber *)minutes
{
    Bottle *b = [NSEntityDescription insertNewObjectForEntityForName:@"Bottle"
                                            inManagedObjectContext:context];
    
    
    b.stringValue = stringValue;
    b.milliLitres = milliLitres;
    b.minutes = minutes;
    
    NSLog(@"Feeded baby with  %@", b);
    
    return b;
}

-(void)removeBottle:(Bottle *)bottle
{
    [context deleteObject:bottle];
}

@end
