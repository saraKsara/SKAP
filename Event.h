//
//  Event.h
//  SKAP
//
//  Created by Åsa Persson on 2013-03-29.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Baby;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSNumber * adDrop;
@property (nonatomic, retain) NSNumber * bottle;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * eventId;
@property (nonatomic, retain) NSString * otherMedz;
@property (nonatomic, retain) NSString * pii;
@property (nonatomic, retain) NSString * poo;
@property (nonatomic, retain) NSNumber * temperature;
@property (nonatomic, retain) NSNumber * timespan;
@property (nonatomic, retain) NSString * tits;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * comments;
@property (nonatomic, retain) Baby *baby;
@property (nonatomic, retain) NSSet *bottles;
@property (nonatomic, retain) NSSet *piis;
@property (nonatomic, retain) NSSet *poos;
@property (nonatomic, retain) NSSet *tities;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addBottlesObject:(NSManagedObject *)value;
- (void)removeBottlesObject:(NSManagedObject *)value;
- (void)addBottles:(NSSet *)values;
- (void)removeBottles:(NSSet *)values;

- (void)addPiisObject:(NSManagedObject *)value;
- (void)removePiisObject:(NSManagedObject *)value;
- (void)addPiis:(NSSet *)values;
- (void)removePiis:(NSSet *)values;

- (void)addPoosObject:(NSManagedObject *)value;
- (void)removePoosObject:(NSManagedObject *)value;
- (void)addPoos:(NSSet *)values;
- (void)removePoos:(NSSet *)values;

- (void)addTitiesObject:(NSManagedObject *)value;
- (void)removeTitiesObject:(NSManagedObject *)value;
- (void)addTities:(NSSet *)values;
- (void)removeTities:(NSSet *)values;

@end
