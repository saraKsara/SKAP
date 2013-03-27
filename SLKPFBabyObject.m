//
//  SLKPFBabyObject.m
//  SKAP
//
//  Created by Åsa Persson on 2013-03-27.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKPFBabyObject.h"
#import "Baby.h"
#import "SLKBabyStorage.h"
@implementation SLKPFBabyObject


+ (NSString *)parseClassName {
    return @"Baby";
}


//MYGame *game = [[MYGame alloc] init];
//game.title = @"Bughouse";
//[game saveInBackground];
//
//
//PFObject *babyObject = [PFObject objectWithClassName:@"Baby"];
//
//Baby *ababby = [[SLKBabyStorage sharedStorage] createBabyWithName:[babyObject objectForKey:@"name"] babyId:[babyObject objectForKey:@"id"]  date:[babyObject objectForKey:@"date"]  type:nil];
//
//NSLog(@"ababby created? %@", ababby.name);


@end

