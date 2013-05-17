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
#import "SLKPARSEService.h"
#import <Parse/Parse.h>
#import "SLKConstants.h"
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


-(Bottle *)createBottleWithId:(NSString *)bottleId stringValue:(NSString *)stringValue mililitres:(NSNumber *)milliLitres minutes:(NSNumber *)minutes dirty:(BOOL)dirty
{
    Bottle *b = [NSEntityDescription insertNewObjectForEntityForName:kBottle
                                            inManagedObjectContext:context];
    
    
    b.stringValue = stringValue;
    b.milliLitres = milliLitres;
    b.minutes = minutes;
    b.bottleId = bottleId;
    b.dirty = [NSNumber numberWithBool:dirty];
    
    
    PFObject *pfBottle = [PFObject objectWithClassName:kBottle];
    //[pfBottle setObject: b.stringValue forKey:@"stringValue"];
    [pfBottle setObject: b.milliLitres forKey:@"milliLitres"];
    [pfBottle setObject: b.bottleId forKey:@"bottleId"];
    
    // [pfBottle saveEventually];
    [SLKPARSEService postObject:pfBottle onSuccess:^(PFObject *obj) {
        
        Bottle *bottleToClean = [self getBottleWithiD:[obj objectForKey:@"bottleId"]];
        bottleToClean.dirty = [NSNumber numberWithBool:NO];
    } onFailure:^(PFObject *obj) {
        
    }];

    NSLog(@"Feeded baby with  %@", b);
    
    return b;
}
-(Bottle *)getBottleWithiD:(NSString *)bottleId
{
    NSArray *arr = [[SLKCoreDataService sharedService] fetchDataWithEntity:@"Bottle"
                                                              andPredicate:[NSPredicate predicateWithFormat:@"bottleId == %@", bottleId]
                                                        andSortDescriptors:nil];
    
    return [arr count] > 0 ? [arr lastObject] : nil;
    
}
-(void)removeBottle:(Bottle *)bottle
{
    [context deleteObject:bottle];
}

@end
