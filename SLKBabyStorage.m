//
//  SLKBabyStorage.m
//  SKAP
//
//  Created by Student vid Yrkeshögskola C3L on 3/19/13.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//
#import "SLKCoreDataService.h"
#import "SLKBabyStorage.h"
#import "Baby.h"
#import "SLKUserDefaults.h"
#import "SLKPARSEService.h"
#import "SLKConstants.h"
#import <Parse/Parse.h>
#import "SLKuser.h"

@implementation SLKBabyStorage
{
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
   
}

+(SLKBabyStorage*) sharedStorage
{
    static SLKBabyStorage *sharedStorage;
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

-(Baby *)createBabyWithName:(NSString *)name babyId:(NSString *)babyId date:(NSDate *)date type:(NSString *)type color:(NSString *)color dirty:(BOOL)dirty
{
    Baby *b;
    Baby *babeInStorage = [self getBabyWithiD:babyId];
    if (babeInStorage) {
     
        b = babeInStorage;
        
    } else {
    b = [NSEntityDescription insertNewObjectForEntityForName:kBaby
                                                      inManagedObjectContext:context];
    }
    
    b.name = name;
    b.babyId = babyId;
    b.date = date;
    b.type = type;
    b.babysColor = color;
    b.dirty = [NSNumber numberWithBool:dirty];
    
   // NSLog(@"There's a new (or a updated babe) baby in town! name: %@  id: %@", b.name, b.babyId);
    [self setCurrentBaby:b];
    
    PFObject *babyObject = [PFObject objectWithClassName:kBaby];
    [babyObject setObject:b.name forKey:@"name"];
//    [babyObject setObject:b.date forKey:@"birthday"];
    [babyObject setObject:b.babyId forKey:kBabyId];
    
  //  PFFile *profilePic = [PFFile fileWithData:data];
    [[PFUser currentUser] setObject:b.babyId forKey:kBabyId];
    [[PFUser currentUser] saveInBackground];
   // [[SLKuser currentUser] setBabyId:b.babyId];
    
    NSString* bId = [[PFUser currentUser] objectForKey:kBabyId];
    NSLog(@"babystorage: babyid::::::--->%@ pfuser:::%@", bId, [[PFUser currentUser] username]);
    
    
    [[PFUser currentUser] saveEventually];
    
    [SLKPARSEService postObject:babyObject onSuccess:^(PFObject *object)
     {
         Baby *babyToClean = [self getBabyWithiD:[object objectForKey:kBabyId]];
         babyToClean.dirty = [NSNumber numberWithBool:NO];
         NSLog(@"cleaned BABY! %@", [object objectForKey:@"name"]);
         
     } onFailure:^(PFObject *object)
     {
         //         NSLog(@"FAILED :((( ");
         //         UIAlertView *failAlert = [[UIAlertView alloc]
         //                                   initWithTitle:@"FAIL"
         //                                   message:@"Failed to add new baby for now. Please try again later" delegate:self
         //                                   cancelButtonTitle:@"OK"
         //                                   otherButtonTitles:nil, nil];
         //         [failAlert show];
     }];
    
    return b;
}




-(void)setCurrentBaby:(Baby *)baby
{
    [SLKUserDefaults setTheCurrentBabe:baby.babyId];
    NSLog(@"(baby storage) The current babe is: %@", baby.name);
}

-(Baby *)getCurrentBaby;
{
    return [self getBabyWithiD:[SLKUserDefaults getTheCurrentBabe]];
}

-(void)removeBaby:(Baby*)baby
{
    [context deleteObject:baby];
    PFObject *object = [PFObject objectWithoutDataWithClassName:kBaby
                                                       objectId:baby.babyId];
    [SLKPARSEService deleteObject:object];
}

-(void)removeAllBabies
{
    for (Baby *babe in [self babyArray]) {
        [self removeBaby:babe];
        
        PFObject *object = [PFObject objectWithoutDataWithClassName:kBaby
                                                 objectId:babe.babyId];
        [SLKPARSEService deleteObject:object];
    }
}

-(Baby *)getBabyWithiD:(NSString *)babyId
{
    NSArray *arr = [[SLKCoreDataService sharedService] fetchDataWithEntity:kBaby
                                                             andPredicate:[NSPredicate predicateWithFormat:@"babyId == %@", babyId]
                                                       andSortDescriptors:nil];
    
    return [arr count] > 0 ? [arr lastObject] : nil;
  
}

-(NSArray*)babyArray
{
  return [[SLKCoreDataService sharedService]fetchDataWithEntity:kBaby];
}



@end
