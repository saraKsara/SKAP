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
-(ParentFigures *)createParentWithName:(NSString *)name signature:(NSString *)signature parentId:(NSString *)parentId number:(NSString *)number color:(NSString *)color babies:(NSSet *)babies
{
    ParentFigures *p = [NSEntityDescription insertNewObjectForEntityForName:@"ParentFigures"
                                                     inManagedObjectContext:context];
    p.name = name;
    p.signature = signature;
    p.number = number;
    p.parentColor = color;
    p.parentId = parentId;
    [p setBabies:babies];
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
    [SLKUserDefaults setTheCurrentBabe:parent.parentId];
    NSLog(@"(baby storage) The current parent is: %@", parent.name);
}
@end
