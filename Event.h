//
//  Event.h
//  SKAP
//
//  Created by Åsa Persson on 2013-05-14.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Baby, Bottle, Diaper, Medz, Pii, Poo, Sleep, Tits;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSNumber * adDrop;
@property (nonatomic, retain) NSNumber * bottle;
@property (nonatomic, retain) NSString * comments;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * eventId;
@property (nonatomic, retain) NSString * otherMedz;
@property (nonatomic, retain) NSString * pii;
@property (nonatomic, retain) NSString * poo;
@property (nonatomic, retain) NSNumber * sleep;
@property (nonatomic, retain) NSNumber * temperature;
@property (nonatomic, retain) NSNumber * timespan;
@property (nonatomic, retain) NSString * tits;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * dirty;
@property (nonatomic, retain) Baby *baby;
@property (nonatomic, retain) NSSet *bottles;
@property (nonatomic, retain) NSSet *diapers;
@property (nonatomic, retain) NSSet *medz;
@property (nonatomic, retain) NSSet *piis;
@property (nonatomic, retain) NSSet *poos;
@property (nonatomic, retain) NSSet *sleeps;
@property (nonatomic, retain) NSSet *tities;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addBottlesObject:(Bottle *)value;
- (void)removeBottlesObject:(Bottle *)value;
- (void)addBottles:(NSSet *)values;
- (void)removeBottles:(NSSet *)values;

- (void)addDiapersObject:(Diaper *)value;
- (void)removeDiapersObject:(Diaper *)value;
- (void)addDiapers:(NSSet *)values;
- (void)removeDiapers:(NSSet *)values;

- (void)addMedzObject:(Medz *)value;
- (void)removeMedzObject:(Medz *)value;
- (void)addMedz:(NSSet *)values;
- (void)removeMedz:(NSSet *)values;

- (void)addPiisObject:(Pii *)value;
- (void)removePiisObject:(Pii *)value;
- (void)addPiis:(NSSet *)values;
- (void)removePiis:(NSSet *)values;

- (void)addPoosObject:(Poo *)value;
- (void)removePoosObject:(Poo *)value;
- (void)addPoos:(NSSet *)values;
- (void)removePoos:(NSSet *)values;

- (void)addSleepsObject:(Sleep *)value;
- (void)removeSleepsObject:(Sleep *)value;
- (void)addSleeps:(NSSet *)values;
- (void)removeSleeps:(NSSet *)values;

- (void)addTitiesObject:(Tits *)value;
- (void)removeTitiesObject:(Tits *)value;
- (void)addTities:(NSSet *)values;
- (void)removeTities:(NSSet *)values;

@end
