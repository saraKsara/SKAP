//
//  SLKHTTPClient.m
//  SKAP
//
//  Created by Åsa Persson on 2013-03-22.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKHTTPClient.h"
#import "AFJSONRequestOperation.h"
//#import "AFHTTPClient.h"

//NSString * const kBaseURLString = @"http://asamaripersson.iriscouch.com/";
NSString * const kBaseURLString = @"http://admin:wandas@asamaripersson.iriscouch.com";

@implementation SLKHTTPClient

+(SLKHTTPClient *)sharedClient {
    static SLKHTTPClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseURLString]];
    });
    return _sharedClient;
}

-(id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    [self registerHTTPOperationClass:[SLKHTTPClient class]];
    
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    self.parameterEncoding = AFJSONParameterEncoding;
    return self;
}
@end
