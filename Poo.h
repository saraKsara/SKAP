//
//  Poo.h
//  SKAP
//
//  Created by Åsa Persson on 2013-03-29.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Poo : NSManagedObject

@property (nonatomic, retain) NSNumber * normal;
@property (nonatomic, retain) NSNumber * tooMuch;
@property (nonatomic, retain) NSNumber * toLittle;
@property (nonatomic, retain) Event *event;

@end
