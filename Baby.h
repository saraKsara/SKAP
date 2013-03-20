//
//  Baby.h
//  SKAP
//
//  Created by Student vid Yrkeshögskola C3L on 3/19/13.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Baby : NSManagedObject

@property (nonatomic, retain) NSNumber * pii;
@property (nonatomic, retain) NSNumber * poo;
@property (nonatomic, retain) NSNumber * feedTimespan;
@property (nonatomic, retain) NSNumber * bottle;
@property (nonatomic, retain) NSNumber * breast;
@property (nonatomic, retain) NSDate * date;

@end
