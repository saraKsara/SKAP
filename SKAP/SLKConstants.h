//
//  SLKConstants.h
//  SKAP
//
//  Created by Åsa Persson on 2013-03-31.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLKConstants : NSObject
//Enteties
#define kParent @"ParentFigure"
#define kBaby   @"Baby"
#define kBottle @"Bottle"
#define kTits @"Tits"
#define kEvent @"Event"
#define kSleep  @"Sleep"
#define kMedz @"Medz"
#define kPoo @"Poo"
#define kPii @"Pii"

//keys
#define kBabyId @"babyId"
#define kParentId @"parentId"
#define kBottleId @"bottleId"
#define kTitId @"titId"
#define kEventId @"eventId"
#define kSleepId @"sleepId"
#define kMedzId @"medzId"
#define kPooId @"pooId"
#define kPiiId @"piiId"
//TYPES
#define kEventType_TitFood     @"breast milk"
#define kEventType_BottleFood     @"bottleFood"

#define kEventType_Poo     @"Poo"
#define kEventType_Pii    @"Pii"
#define kEventType_Diaper    @"Diaper"


#define kEventType_Medz    @"Medz"

#define kEventType_Sleep    @"Sleep"



//COLORS
#define kGreenish_Color     @"beffcd"
#define kYellowish_Color     @"fee787"
#define kBlueish_Color     @"5a86a1"


#define kBG_Color @"ECE8E9"
@end
