//
//  Pii.h
//  SKAP
//
//  Created by Åsa Persson on 2013-05-14.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Pii : NSManagedObject

@property (nonatomic, retain) NSNumber * didPee;
@property (nonatomic, retain) NSNumber * dirty;
@property (nonatomic, retain) NSString * piiId;
@property (nonatomic, retain) Event *event;

@end
