//
//  Sleep.h
//  SKAP
//
//  Created by Student vid Yrkeshögskola C3L on 4/9/13.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Sleep : NSManagedObject

@property (nonatomic, retain) NSNumber * minutes;
@property (nonatomic, retain) Event *event;

@end
