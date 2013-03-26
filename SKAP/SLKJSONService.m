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
     
    SLKHTTPClient *client = [SLKHTTPClient sharedClient];
    
    NSString *allDocs =@"skap/_all_docs?include_docs=true";
//    NSString* idTEST =@"skap/7cc6607def14d920e0dbaddf01000c38";//ONLY FOR TEST
//    NSString *skap = @"skap/";
    
    NSURLRequest* request = [client requestWithMethod:@"GET" path:allDocs parameters:nil];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        //if ([[[SLKBabyStorage sharedStorage] babyArray] count] == 0) {
        
        for (NSDictionary *dictionary in [JSON objectForKey:@"rows"])
        {

           NSDictionary *theBabyData = [dictionary valueForKey:@"doc"];
            

            [[SLKBabyStorage sharedStorage] createBabyWithName:[theBabyData objectForKey:@"name"]
                                                        babyId:[theBabyData objectForKey:@"_id"]
                                                          date:nil
                                                          type:nil];
        }

        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Fail, error: %@", error);
        NSLog(@"Fail, response: %d", response.statusCode);
        NSLog(@"Fail, JSON: %@", JSON);
    }];
    [operation start];
}

+(void)postBaby:(NSDictionary *)baby onSuccess:(void (^)(NSDictionary *))success onFailure:(void (^)(NSDictionary *, NSHTTPURLResponse *))failure
{
//    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://admin:wandas66@asamaripersson.iriscouch.com/skap"]];
//                                       
//    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:URL];
//    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [theRequest setHTTPMethod:@"POST"];
//    
//    
//    NSData *toCouchAsJSON = [NSJSONSerialization dataWithJSONObject:baby options:NSJSONWritingPrettyPrinted error:nil];
//
//    [theRequest setHTTPBody:toCouchAsJSON];
//    
//    [NSURLConnection sendAsynchronousRequest:theRequest
//                                       queue:[[NSOperationQueue alloc] init]
//                           completionHandler: ^(NSURLResponse *resp, NSData *data, NSError *error)
//     {
//         if (error)
//         {
//             NSLog(@"%@", [error localizedDescription]);
//         }
//         NSMutableDictionary *idAndRevFromLastAddedDoc = [NSJSONSerialization JSONObjectWithData:data
//                                                                                         options:NSJSONReadingMutableContainers
//                                                                                           error:nil];
//         
//         success(idAndRevFromLastAddedDoc );
 //    }];
    SLKHTTPClient *client = [SLKHTTPClient sharedClient];
    
    NSString* path =@"/skap";
    
    NSURLRequest* request = [client requestWithMethod:@"POST" path:path parameters:baby];
    
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
