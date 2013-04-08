//
//  SLKParentStorage.h
//  SKAP
//
//  Created by Åsa Persson on 2013-04-05.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ParentFigures, Baby;
@interface SLKParentStorage : NSObject

+(SLKParentStorage*) sharedStorage;

-(ParentFigures*)createParentWithName:(NSString*)name signature:(NSString*)signature parentId:(NSString*)parentId number:(NSString*)number color:(NSString*)color babies:(NSSet*)babies;

-(void)removeBaby:(Baby*)baby fromParent:(ParentFigures*)parent;

-(void)removeParent:(ParentFigures*)parent;

-(void)removeAllParents;


-(ParentFigures*)getParentWithiD:(NSString*)parentId;

-(NSArray*)parentArray;

-(ParentFigures*)getCurrentParent;

-(void)setCurrentParent:(ParentFigures*)parent;
@end
