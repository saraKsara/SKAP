//
//  SLKuser.h
//  SKAP
//
//  Created by Åsa Persson on 2013-05-01.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Parse/Parse.h>

@interface SLKuser : PFUser
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * parentId;
@property (nonatomic, retain) NSString * signature;
@property (nonatomic, retain) NSSet *babies;
@end
