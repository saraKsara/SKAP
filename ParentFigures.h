//
//  ParentFigures.h
//  SKAP
//
//  Created by Åsa Persson on 2013-04-04.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Baby;

@interface ParentFigures : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * parentColor;
@property (nonatomic, retain) NSSet *baby;
@end

@interface ParentFigures (CoreDataGeneratedAccessors)

- (void)addBabyObject:(Baby *)value;
- (void)removeBabyObject:(Baby *)value;
- (void)addBaby:(NSSet *)values;
- (void)removeBaby:(NSSet *)values;

@end
