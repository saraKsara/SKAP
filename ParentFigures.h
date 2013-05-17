//
//  ParentFigures.h
//  SKAP
//
//  Created by Åsa Persson on 2013-05-14.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Baby;

@interface ParentFigures : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * parentColor;
@property (nonatomic, retain) NSString * parentId;
@property (nonatomic, retain) NSString * signature;
@property (nonatomic, retain) NSNumber * dirty;
@property (nonatomic, retain) NSSet *babies;
@end

@interface ParentFigures (CoreDataGeneratedAccessors)

- (void)addBabiesObject:(Baby *)value;
- (void)removeBabiesObject:(Baby *)value;
- (void)addBabies:(NSSet *)values;
- (void)removeBabies:(NSSet *)values;

@end
