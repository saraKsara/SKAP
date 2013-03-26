//
//  SLKUserDefaults.m
//  SKAP
//
//  Created by Åsa Persson on 2013-03-26.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKUserDefaults.h"
#import "Baby.h"
#import "SLKBabyStorage.h"

@implementation SLKUserDefaults

+(void)setTheCurrentBabe:(NSString *)babyId
{
    [[NSUserDefaults standardUserDefaults] setObject:babyId forKey:@"currentBaby"];
    NSLog(@"set userDefault currentbaby id : %@", babyId);
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)getTheCurrentBabe
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"currentBaby"];
    NSLog(@"get current baby from user default: %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"currentBaby"]);
}


@end
