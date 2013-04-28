//
//  SLKPooStorage.h
//  SKAP
//
//  Created by Åsa Persson on 2013-03-30.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Poo;
@interface SLKPooStorage : NSObject
+(SLKPooStorage*) sharedStorage;

-(Poo*)createPoo;

-(void)removePoo:(Poo*)poo;

//-(Poo*)getPooThatBelongsToEvent:(Poo*)poo;

//-(NSArray*)pooArray;
@end
