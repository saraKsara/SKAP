//
//  Poo.h
//  SKAP
//
//  Created by Åsa Persson on 2013-04-27.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Poo : NSManagedObject

@property (nonatomic, retain) NSNumber * didPoop;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) Event *event;

@end
