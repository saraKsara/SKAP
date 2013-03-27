//
//  SLKPFBabyObject.h
//  SKAP
//
//  Created by Åsa Persson on 2013-03-27.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Parse/Parse.h>
@interface SLKPFBabyObject : PFObject < PFSubclassing >
// Accessing this property is the same as objectForKey:@"title"
@property (retain) NSString *title;
+ (NSString *)parseClassName;


@end
