//
//  SLKDiaper.h
//  SKAP
//
//  Created by Åsa Persson on 2013-05-01.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Parse/Parse.h>

@interface SLKDiaper : PFObject <PFSubclassing>
@property (retain) NSString *title;
+ (NSString *)parseClassName;


@end
