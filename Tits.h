//
//  Tits.h
//  SKAP
//
//  Created by Åsa Persson on 2013-04-03.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Tits : NSManagedObject

@property (nonatomic, retain) NSNumber * milliLitres;
@property (nonatomic, retain) NSNumber * minutes;
@property (nonatomic, retain) NSString * stringValue;
@property (nonatomic, retain) NSNumber * leftBoob;
@property (nonatomic, retain) NSNumber * rightBoob;
@property (nonatomic, retain) Event *event;

@end
