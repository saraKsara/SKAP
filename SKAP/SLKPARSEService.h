//
//  SLKJSONService.h
//  SKAP
//
//  Created by Åsa Persson on 2013-03-22.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
@class Baby, Event;

@interface SLKPARSEService : NSObject

+(void)getAllObjects;
+(void)getAllEvents;
+(void)getNewevents;
+(void)getBabyWithId:(NSString*)babiId;
//+(NSDictionary*)postOrder:(NSDictionary*)order;
+(void)postObject:(PFObject*)object onSuccess:(void (^)(PFObject *))successObject onFailure:(void (^)(PFObject*))failureObject;
+(void)getParentWithUserName:(NSString*)pName;


+(void)deleteObject:(PFObject*)object;
@end
