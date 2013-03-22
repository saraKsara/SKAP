//
//  SLKJSONService.h
//  SKAP
//
//  Created by Åsa Persson on 2013-03-22.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLKJSONService : NSObject
+(void)getAllPizzas;

//+(NSDictionary*)postOrder:(NSDictionary*)order;
+(void)postOrder:(NSDictionary*)order onSuccess:(void (^)(NSDictionary *))success onFailure:(void (^)(NSDictionary *, NSHTTPURLResponse*))failure;
@end
