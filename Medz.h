//
//  Medz.h
//  SKAP
//
//  Created by Åsa Persson on 2013-05-14.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Medz : NSManagedObject

@property (nonatomic, retain) NSNumber * adDrop;
@property (nonatomic, retain) NSNumber * ibuprofen;
@property (nonatomic, retain) id more;
@property (nonatomic, retain) NSNumber * paracetamol;
@property (nonatomic, retain) NSNumber * temp;
@property (nonatomic, retain) NSString * medzId;
@property (nonatomic, retain) NSNumber * dirty;
@property (nonatomic, retain) Event *event;

@end
