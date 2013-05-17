//
//  Sleep.h
//  SKAP
//
//  Created by Åsa Persson on 2013-05-14.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Sleep : NSManagedObject

@property (nonatomic, retain) NSNumber * minutes;
@property (nonatomic, retain) NSString * sleepId;
@property (nonatomic, retain) NSNumber * dirty;
@property (nonatomic, retain) Event *event;

@end
