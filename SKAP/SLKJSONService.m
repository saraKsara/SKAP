//
//  SLKJSONService.m
//  SKAP
//
//  Created by Åsa Persson on 2013-03-22.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKJSONService.h"
#import "SLKHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "SLKBabyStorage.h"
#import "Baby.h"

@implementation SLKJSONService

+(void)getAllBabies
{
    //    NSString *listAllPizzas =@"pizzas";
    SLKHTTPClient *client = [SLKHTTPClient sharedClient];
    
    //    NSString* path =listAllPizzas;
    NSURLRequest* request = [client requestWithMethod:@"GET" path:@"?skap" parameters:nil];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
         NSLog(@"JSON  %@", JSON);
        // if ([[[SLKBabyStorage sharedStorage] babyArray] count] == 0) {
        
        for (NSDictionary *dict in JSON)
        {
            
            NSLog(@"JSON dich %@", dict);
            //
            //                [[SLKBabyStorage sharedStorage] createBabyWithName:[dict objectForKey:@"pee"]
            //                                                                            poo:[dict valueForKey:@"poo"]
            //                                                                   feedTimespan:[dict valueForKey:@"feedSpan"]
            //                                                                         bottle:[dict valueForKey:@"bottle"]
            //                                                                         breast:[dict valueForKey:@"breast"]
            //                                                                           date:[NSDate date]];
            
            
        }
        
        // }
        
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Fail, error: %@", error);
        NSLog(@"Fail, response: %d", response.statusCode);
        NSLog(@"Fail, JSON: %@", JSON);
    }];
    [operation start];
}

+(void)postOrder:(NSDictionary*)order onSuccess:(void (^)(NSDictionary *))success onFailure:(void (^)(NSDictionary *, NSHTTPURLResponse*))failure
{
    
    SLKHTTPClient *client = [SLKHTTPClient sharedClient];
    
    NSString* path =@"pizzaorders?param=val";
    
    NSURLRequest* request = [client requestWithMethod:@"POST" path:path parameters:order];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            success(JSON);
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            failure(JSON, response);
                                                                                            NSLog(@"FAILURE, JSON RESP %@", response);
                                                                                        }];
    [operation start];
    
}




@end
