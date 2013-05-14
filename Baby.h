//
//  Baby.h
//  SKAP
//
//  Created by Åsa Persson on 2013-05-14.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, ParentFigures;

@interface Baby : NSManagedObject

@property (nonatomic, retain) NSString * babyId;
@property (nonatomic, retain) NSString * babysColor;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * dirty;
@property (nonatomic, retain) NSSet *event;
@property (nonatomic, retain) NSSet *parents;
@end

@interface Baby (CoreDataGeneratedAccessors)

- (void)addEventObject:(Event *)value;
- (void)removeEventObject:(Event *)value;
- (void)addEvent:(NSSet *)values;
- (void)removeEvent:(NSSet *)values;

- (void)addParentsObject:(ParentFigures *)value;
- (void)removeParentsObject:(ParentFigures *)value;
- (void)addParents:(NSSet *)values;
- (void)removeParents:(NSSet *)values;

@end
