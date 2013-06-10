//
//  SLKJSONService.h
//  SKAP
//
//  Created by Åsa Persson on 2013-03-22.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <CoreData/CoreData.h>
#import <CoreData/CoreData.h>
@class Event, Baby, Tits, Bottle, Pii, Poo, Medz, Sleep, Diaper;

@interface SLKPARSEService : NSObject

+(void)getAllEventswithId:(NSMutableArray*)eventIds;
+(void)getNewEvents;
+(void)getBabyWithId:(NSString*)babyId;
+(void)postObject:(PFObject*)object onSuccess:(void (^)(PFObject *))successObject onFailure:(void (^)(PFObject*))failureObject;
+(void)getParentWithUserName:(NSString*)pName;
+(void)getTitsWithId:(NSString*)titId  onSuccess:(void (^)(NSManagedObject *))successObject onFailure:(void (^)(NSManagedObject*))failureObject;
+(void)getBabyWithId:(NSString*)babiId onSuccess:(void (^)(PFObject *))successObject onFailure:(void (^)(PFObject *))failureObject;
+(void)deleteObject:(PFObject*)object;
@end
