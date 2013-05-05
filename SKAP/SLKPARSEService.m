//
//  SLKJSONService.m
//  SKAP
//
//  Created by Åsa Persson on 2013-03-22.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKPARSEService.h"
#import "SLKBabyStorage.h"
#import "Baby.h"
#import "SLKAppDelegate.h"
#import <Parse/Parse.h>
@implementation SLKPARSEService

+(void)getAllObjects
{
   NSDictionary *paramDict =  @{@"objectId":@"EShAEXIFzG"};
//    + (id)callFunction:(NSString *)function withParameters:(NSDictionary *)parameters
    //[PFCloud callFunction:@"getBabies" withParameters:paramDict];
    [PFCloud callFunctionInBackground:@"getBabies" withParameters:paramDict block:^(id object, NSError *error) {
        if (!error) {
            NSLog(@"Men hurray! %@", [[object objectAtIndex:0] objectId]);
            //avgPoint = object;
            //[avgButton setTitle:@"See average location!" forState:UIControlStateNormal];
        } else {
            NSLog(@"Men nooo!%@ %@", object, error);

            //avgPoint = nil;
            //[avgButton setTitle:@"Sorry, not available!" forState:UIControlStateNormal];
        }
    }];
    
    NSDictionary *paramDictEvent =  @{@"Babe":@"EShAEXIFzG"};
    //    + (id)callFunction:(NSString *)function withParameters:(NSDictionary *)parameters
    //[PFCloud callFunction:@"getBabies" withParameters:paramDict];
    [PFCloud callFunctionInBackground:@"getEvents" withParameters:paramDictEvent block:^(id object, NSError *error) {
        if (!error) {
            NSLog(@"Men hurray! %@", object);
            //avgPoint = object;
            //[avgButton setTitle:@"See average location!" forState:UIControlStateNormal];
        } else {
            NSLog(@"Men nooo!%@ %@", object, error);
            
            //avgPoint = nil;
            //[avgButton setTitle:@"Sorry, not available!" forState:UIControlStateNormal];
        }
    }];
    
    
//    PFQuery *babyQuery = [PFQuery queryWithClassName:@"Baby"]; //1
//    //[query whereKey:@"name" equalTo:@"Jack"];//2
//    [babyQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {//4
//        if (!error) {
//            NSLog(@"Successfully retrieved: %@", objects.class);
//            
//            for (int i = 0; i < [objects count]; i++)
//            {
////                 NSLog(@"BABY : %@", [[objects objectAtIndex:i] objectId ]);
////                            NSLog(@"BABY : %@", [objects objectAtIndex:i]);
//                
//                [[SLKBabyStorage sharedStorage] createBabyWithName:[[objects objectAtIndex:i] objectForKey:@"name"]
//                                                            babyId:[[objects objectAtIndex:i]objectId]
//                                                              date:[[objects objectAtIndex:i] objectForKey:@"date"]
//                                                              type:nil
//                                                             color:[[objects objectAtIndex:i]objectForKey:@"color"]];
//                
//            }
//
//        } else {
//            NSString *errorString = [[error userInfo] objectForKey:@"error"];
//            NSLog(@"Error: %@", errorString);
//        }
//    }];
}

+(void)postObject:(PFObject *)object onSuccess:(void (^)(PFObject *))successObject onFailure:(void (^)(PFObject *))failureObject
{
    [object saveEventually:^(BOOL succeeded, NSError *error) {
        
        if (succeeded){
            //TODO: what to do when there is no internet connection?? saveEventually whe no internet, and save wit block if there IS connection
            NSLog(@"Object Uploaded!");
            successObject(object);
        }
        else{
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
        
    }];
}

+(void)deleteObject:(PFObject *)object
{
    [object deleteInBackground];
  
}


@end
