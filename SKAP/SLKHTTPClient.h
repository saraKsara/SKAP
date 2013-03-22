//
//  SLKHTTPClient.h
//  SKAP
//
//  Created by Åsa Persson on 2013-03-22.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

extern NSString * const kTraktAPIKey;
extern NSString * const kTraktBaseURLString;

@interface SLKHTTPClient: AFHTTPClient

+(SLKHTTPClient *)sharedClient;

@end
