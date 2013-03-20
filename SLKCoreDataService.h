//
//  SLKCoreDataService.h
//  SKAP
//
//  Created by Student vid Yrkeshögskola C3L on 3/19/13.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLKCoreDataService : NSObject
- (NSString *)path;
+(SLKCoreDataService*)sharedService;
-(NSManagedObjectContext *)getContext;
-(NSManagedObjectModel *)getModel;
-(NSArray *)fetchDataWithEntity:(NSString *)entity;
@end
