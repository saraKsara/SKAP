//
//  SLKMedzStorage.h
//  SKAP
//
//  Created by Åsa Persson on 2013-04-03.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Medz, Event;
@interface SLKMedzStorage : NSObject

+(SLKMedzStorage*) sharedStorage;

//TODO: add left and right breast propery on tits

-(Medz*)createMedzWithTemp:(NSNumber*)temp adDrop:(BOOL)adDrop paracetamol:(BOOL)paracetamol ibuprofen:(BOOL)ibuprofen more:(NSSet*)more;


-(void)removeMedz:(Medz*)medecine;

//-(Medz*)getMedThatBelongsToEvent:(Event*)event;

//-(NSArray*)titArray;
@end
