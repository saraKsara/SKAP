//
//  SLKPiiStorage.h
//  SKAP
//
//  Created by Åsa Persson on 2013-03-30.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Pii;
@interface SLKPiiStorage : NSObject
+(SLKPiiStorage*) sharedStorage;

-(Pii*)createNormalPii:(BOOL*)normal tooMuch:(BOOL*)tooMuch tooLittle:(BOOL*)tooLittle;

-(void)removePii:(Pii*)pii;

//-(Pii*)getPiiThatBelongsToEvent:(Pii*)pii;

//-(NSArray*)piiArray;
@end
