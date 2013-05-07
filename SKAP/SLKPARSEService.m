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
#import "SLKUserDefaults.h"
#import "SLKParentStorage.h"
#import "ParentFigures.h"
#import <Parse/Parse.h>
@implementation SLKPARSEService

+(void)getAllObjects
{

//    NSDictionary *paramDict =  @{@"objectId":@"qQnTDiem5K"};
//    
//    [PFCloud callFunctionInBackground:@"getBabies" withParameters:paramDict block:^(id object, NSError *error) {
//        if (!error) {
//            NSLog(@"Baby from response %@", [[object objectAtIndex:0] objectForKey:@"name"]);
//            
//        } else {
//            NSLog(@"Error: %@", error);
//            
//        }
//    }];
    
    
//    PFQuery *babyQuery = [PFQuery queryWithClassName:@"Baby"]; //1
//    //[query whereKey:@"name" equalTo:@"Jack"];//2
//    [babyQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {//4
//        if (!error) {
//            NSLog(@"Successfully retrieved: %@", objects.class);
//            
//            for (int i = 0; i < [objects count]; i++)
//            {
//                //                 NSLog(@"BABY : %@", [[objects objectAtIndex:i] objectId ]);
//                //                            NSLog(@"BABY : %@", [objects objectAtIndex:i]);
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
+(void)getNewevents
{
    
}
+(void)getAllEvents{
    PFQuery *query = [PFQuery queryWithClassName:@"Event"]; //1
    NSString *currentBabyId = [SLKUserDefaults getTheCurrentBabe];
    [query whereKey:@"babyId" equalTo:currentBabyId];//currentbaby
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {//4
        if (!error) {
            NSLog(@"Successfully retrieved: %@", objects.class);
            
            for (int i = 0; i < [objects count]; i++)
            {
                                 NSLog(@"\n\n EVENTid : %@\n\n", [[objects objectAtIndex:i] objectId ]);
                NSLog(@"\n\n type ------ :::: %@\n\n", [[objects objectAtIndex:i] objectForKey:@"type"]);
                NSLog(@"\n\n local date ------ :::: %@\n\n", [[objects objectAtIndex:i] objectForKey:@"localDate"]);

                NSLog(@"\n\n date ------ :::: %@\n\n", [[objects objectAtIndex:i] updatedAt]);

                NSLog(@"\n\n EVENT : %@\n\n", [objects objectAtIndex:i]);
                            }
            
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error, could not get all events: %@", errorString);
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