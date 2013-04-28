//
//  Diaper.h
//  SKAP
//
//  Created by Åsa Persson on 2013-04-27.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Diaper : NSManagedObject

@property (nonatomic, retain) NSNumber * piied;
@property (nonatomic, retain) NSNumber * pooped;
@property (nonatomic, retain) Event *event;

@end
