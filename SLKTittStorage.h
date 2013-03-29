//
//  SLKTittStorage.h
//  SKAP
//
//  Created by Åsa Persson on 2013-03-29.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Tits;
@interface SLKTittStorage : NSObject

+(SLKTittStorage*) sharedStorage;

-(Tits*)createTittWithStringValue:(NSString*)stringValue mililitres:(NSNumber*)milliLitres minutes:(NSNumber*)minutes;

-(void)removeTitmilk:(Tits*)tit;

//-(Tits*)getTitThatBelongsToEvent:(Tits*)tit;

//-(NSArray*)babyArray;

@end
