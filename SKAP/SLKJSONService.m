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
#import "SLKAppDelegate.h"
#import <Parse/Parse.h>
@implementation SLKJSONService

+(void)getAllObjects
{
    
    PFQuery *babyQuery = [PFQuery queryWithClassName:@"Baby"]; //1
    //[query whereKey:@"name" equalTo:@"Jack"];//2
    [babyQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {//4
        if (!error) {
            NSLog(@"Successfully retrieved: %@", objects.class);
            
            for (int i = 0; i < [objects count]; i++)
            {
//                 NSLog(@"BABY : %@", [[objects objectAtIndex:i] objectId ]);
//                            NSLog(@"BABY : %@", [objects objectAtIndex:i]);
                
                [[SLKBabyStorage sharedStorage] createBabyWithName:[[objects objectAtIndex:i] objectForKey:@"name"]
                                                            babyId:[[objects objectAtIndex:i]objectId]
                                                              date:[[objects objectAtIndex:i] objectForKey:@"date"]
                                                              type:nil];
                
            }

        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];

//    
//    
//    
//    SLKHTTPClient *client = [SLKHTTPClient sharedClient];
//    
//    NSString *allDocs =@"skap/_all_docs?include_docs=true";
////    NSString* idTEST =@"skap/7cc6607def14d920e0dbaddf01000c38";//ONLY FOR TEST
////    NSString *skap = @"skap/";
//    
//    NSURLRequest* request = [client requestWithMethod:@"GET" path:allDocs parameters:nil];
//    
//    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        
//        //if ([[[SLKBabyStorage sharedStorage] babyArray] count] == 0) {
//        
//        for (NSDictionary *dictionary in [JSON objectForKey:@"rows"])
//        {
//
//           NSDictionary *theBabyData = [dictionary valueForKey:@"doc"];
//            
//
//            [[SLKBabyStorage sharedStorage] createBabyWithName:[theBabyData objectForKey:@"name"]
//                                                        babyId:[theBabyData objectForKey:@"_id"]
//                                                          date:nil
//                                                          type:nil];
//        }
//
//        
//        
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//        NSLog(@"Fail, error: %@", error);
//        NSLog(@"Fail, response: %d", response.statusCode);
//        NSLog(@"Fail, JSON: %@", JSON);
//    }];
//    [operation start];
}

+(void)postObject:(PFObject *)object onSuccess:(void (^)(PFObject *))successObject onFailure:(void (^)(PFObject *))failureObject
{
    //PFObject *object = [PFObject objectWithClassName:@"Baby"];
//    [object setObject:@"Jack" forKey:@"name"];
    //  [anotherPlayer setObject:[NSNumber numberWithInt:840] forKey:@"Score"];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded){
            NSLog(@"Object Uploaded!");
        }
        else{
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
        
    }];
//    SLKHTTPClient *client = [SLKHTTPClient sharedClient];
//    
//    NSString* path =@"/skap";
//    
//    NSURLRequest* request = [client requestWithMethod:@"POST" path:path parameters:baby];
//    
//    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
//                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//                                                                                            success(JSON);
//                                                                                            
//                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//                                                                                            failure(JSON, response);
//                                                                                            NSLog(@"FAILURE, JSON RESP %@", response);
//                                                                                        }];
//    [operation start];
//
}




@end
