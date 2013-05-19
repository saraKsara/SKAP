//
//  SLKParentStorage.m
//  SKAP
//
//  Created by Åsa Persson on 2013-04-05.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKParentStorage.h"
#import "ParentFigures.h"
#import "SLKCoreDataService.h"
#import "SLKBabyStorage.h"
#import "Baby.h"
#import "SLKUserDefaults.h"
#import "SLKPARSEService.h"
#import "SLKConstants.h"
#import <Parse/Parse.h>
@implementation SLKParentStorage
{
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
    
}

+(SLKParentStorage*) sharedStorage
{
    static SLKParentStorage *sharedStorage;
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
-(ParentFigures *)createParentWithName:(NSString *)name signature:(NSString *)signature parentId:(NSString *)parentId number:(NSString *)number color:(NSString *)color babies:(NSSet *)babies dirty:(BOOL)dirty
{
    ParentFigures *p = [NSEntityDescription insertNewObjectForEntityForName:@"ParentFigures"
                                                     inManagedObjectContext:context];
    p.name = name;
    p.signature = signature;
    p.number = number;
    p.parentColor = color;
    p.parentId = parentId;
    p.dirty = [NSNumber numberWithBool:dirty];
    [p setBabies:babies];
    
    [self setCurrentParent:p];
    
    
    [self setCurrentParent:p];
    
    
    PFObject *parentObject = [PFObject objectWithClassName:@"ParentFigure"];
    [parentObject setObject:p.name forKey:@"name"];
    [parentObject setObject:p.signature forKey:@"signature"];
    [parentObject setObject:p.parentId forKey:@"parentId"];
    
    [[PFUser currentUser]setObject:p.parentId forKey:@"currentParent"];//????

    
    //[parentObject setObject:_setSignatureTextField.text forKey:@"signature"];
    //     [babyObject setObject:newBabyName forKey:@"date"];
    
    
    [SLKPARSEService postObject:parentObject onSuccess:^(PFObject *object)
     {
         ParentFigures *parentToClean = [self getParentWithiD:[object objectForKey:@"parentId"]];
         parentToClean.dirty = [NSNumber numberWithBool:NO];
         
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
    
    return p;
}

-(void)removeBaby:(Baby*)baby fromParent:(ParentFigures*)parent
{
    [parent removeBabiesObject:baby];
}

-(void)removeParent:(ParentFigures*)parent
{
    [context deleteObject:parent];
    PFObject *object = [PFObject objectWithoutDataWithClassName:@"ParentFigures"
                                                       objectId:parent.parentId];
    [SLKPARSEService deleteObject:object];
}

-(void)removeAllParents
{
    for (ParentFigures *parent in [self parentArray])
    {
        [self removeParent:parent];
        
        PFObject *object = [PFObject objectWithoutDataWithClassName:@"ParentFigures"
                                                           objectId:parent.parentId];
        [SLKPARSEService deleteObject:object];
    }
}


-(ParentFigures *)getParentWithiD:(NSString *)parentId
{
    NSArray *arr = [[SLKCoreDataService sharedService] fetchDataWithEntity:@"ParentFigures"
                                                              andPredicate:[NSPredicate predicateWithFormat:@"parentId == %@", parentId]
                                                        andSortDescriptors:nil];
    
    return [arr count] > 0 ? [arr lastObject] : nil;
}

-(NSArray*)parentArray
{
   return [[SLKCoreDataService sharedService]fetchDataWithEntity:@"ParentFigures"];
}

-(ParentFigures*)getCurrentParent
{
   return [self getParentWithiD:[SLKUserDefaults getTheCurrentParent]];
}

-(void)setCurrentParent:(ParentFigures*)parent
{
    [SLKUserDefaults setTheCurrentParent:parent.parentId];
    NSLog(@"The current parent is: %@", parent.name);
}
@end
