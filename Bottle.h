//
//  Bottle.h
//  SKAP
//
//  Created by Åsa Persson on 2013-03-29.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Bottle : NSManagedObject

@property (nonatomic, retain) NSNumber * milliLitres;
@property (nonatomic, retain) NSNumber * minutes;
@property (nonatomic, retain) NSString * stringValue;
@property (nonatomic, retain) Event *event;

@end
