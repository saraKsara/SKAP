//
//  Baby.h
//  SKAP
//
//  Created by Åsa Persson on 2013-04-04.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Baby, Event;

@interface Baby : NSManagedObject

@property (nonatomic, retain) NSString * babyId;
@property (nonatomic, retain) NSString * babysColor;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet *event;
@property (nonatomic, retain) NSSet *parentFigures;
@end

@interface Baby (CoreDataGeneratedAccessors)

- (void)addEventObject:(Event *)value;
- (void)removeEventObject:(Event *)value;
- (void)addEvent:(NSSet *)values;
- (void)removeEvent:(NSSet *)values;

- (void)addParentFiguresObject:(Baby *)value;
- (void)removeParentFiguresObject:(Baby *)value;
- (void)addParentFigures:(NSSet *)values;
- (void)removeParentFigures:(NSSet *)values;

@end
