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
-(ParentFigures *)createParentWithName:(NSString *)name parentId:(NSString *)parentId number:(NSString *)number color:(NSString *)color babies:(NSSet *)babies
{
    ParentFigures *p = [NSEntityDescription insertNewObjectForEntityForName:@"ParentFigures"
                                                     inManagedObjectContext:context];
    p.name = name;
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


//-(Baby*)getParentWithiD:(NSString*)babyId; //TODO: addprentid?

-(NSArray*)parentArray
{
   return [[SLKCoreDataService sharedService]fetchDataWithEntity:@"ParentFigures"];
}

-(ParentFigures*)getCurrentParent
{
    return nil;
}
-(void)setCurrentParent:(ParentFigures*)parent
{
    
}
@end
