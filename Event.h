//
//  Event.h
//  SKAP
//
//  Created by Åsa Persson on 2013-03-26.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Baby;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * pii;
@property (nonatomic, retain) NSString * poo;
@property (nonatomic, retain) NSNumber * bottle;
@property (nonatomic, retain) NSString * tits;
@property (nonatomic, retain) NSNumber * adDrop;
@property (nonatomic, retain) NSString * otherMedz;
@property (nonatomic, retain) NSNumber * temperature;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * timespan;
@property (nonatomic, retain) NSString * eventId;
@property (nonatomic, retain) Baby *baby;

@end
