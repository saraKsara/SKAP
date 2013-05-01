//
//  SLKDiaper.m
//  SKAP
//
//  Created by Åsa Persson on 2013-05-01.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKDiaper.h"
#import <Parse/Parse.h>


@implementation SLKDiaper
@dynamic title;
+ (NSString *)parseClassName {
    return @"Game";
}
//
//PFQuery *query = [PFQuery queryWithClassName:@"GameScore"];
//query.cachePolicy = kPFCachePolicyNetworkElseCache;
//[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//    if (!error) {
//        // Results were successfully found, looking first on the
//        // network and then on disk.
//    } else {
//        // The network was inaccessible and we have no cached data for
//        // this query.
//    }
//}];
//MYGame *game = [[MYGame alloc] init];
//game.title = @"Bughouse";
//[game saveInBackground];


@end