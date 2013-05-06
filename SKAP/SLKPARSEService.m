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
#import "SLKPfSingupViewController.h"
#import "SLKParentStorage.h"
#import "ParentFigures.h"
#import <Parse/Parse.h>
@implementation SLKPARSEService

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
                                                              type:nil
                                                             color:[[objects objectAtIndex:i]objectForKey:@"color"]];
                
            }

        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}
+(void)getParentWithUserName:(NSString*)pName
{
    //SLKPfSingupViewController  *suv;
   // NSMutableString *s = suv.usernamefromSignUp;

    PFQuery *pQuery = [PFQuery queryWithClassName:@"User"];
    [pQuery whereKey:@"username" equalTo:pName];
    NSLog(@"----%@", pName);
    
    [pQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {//4
        if (!error) {
            NSLog(@"Successfully retrieved kanske INGET JÄVLAT ALLS: %@", objects.class);
           // NSLog(@"----------%@",[objects objectAtIndex:0]);
            for (int i = 0; i < [objects count]; i++)
            {
                NSLog(@"huhuhuhuhuh----");               
                //                 NSLog(@"BABY : %@", [[objects objectAtIndex:i] objectId ]);
                //                            NSLog(@"BABY : %@", [objects objectAtIndex:i]);
                
                [[SLKParentStorage sharedStorage]createParentWithName:[[objects objectAtIndex:i] objectForKey:@"username"] signature:nil parentId:[[objects objectAtIndex:i]objectId] number:nil color:nil babies:nil];
                NSLog(@"namnet------%@",pName);
                NSLog(@"currentPEAR---%@",[[[SLKParentStorage sharedStorage]getCurrentParent]name]);
                
                
            }
            
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
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
