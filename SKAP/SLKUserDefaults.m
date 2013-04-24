//
//  SLKUserDefaults.m
//  SKAP
//
//  Created by Åsa Persson on 2013-03-26.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKUserDefaults.h"

@implementation SLKUserDefaults

+(void)setTheCurrentBabe:(NSString *)babyId
{
    [[NSUserDefaults standardUserDefaults] setObject:babyId forKey:@"currentBaby"];
    NSLog(@"set userDefault currentbaby id : %@", babyId);
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setTheCurrentBaby:(NSString *)babyId OnCompleted: (void (^)()) completed
{
    [[NSUserDefaults standardUserDefaults] setObject:babyId forKey:@"currentBaby"];
    NSLog(@"set userDefault currentbaby id : %@", babyId);
    [[NSUserDefaults standardUserDefaults] synchronize];
    if(completed) {
        completed();
    }
}

+(NSString*)getTheCurrentBabe
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"currentBaby"];
    NSLog(@"get current baby from user default: %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"currentBaby"]);
}

+(void)setTheCurrentParent:(NSString *)parentId
{
    [[NSUserDefaults standardUserDefaults] setObject:parentId forKey:@"currentParent"];
    NSLog(@"set userDefault current Parent id : %@", parentId);
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)getTheCurrentParent
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"currentParent"];
    NSLog(@"get current Parent from user default: %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"currentParent"]);
}

@end
