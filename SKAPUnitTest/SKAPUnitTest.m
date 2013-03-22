//
//  SKAPUnitTest.m
//  SKAPUnitTest
//
//  Created by Åsa Persson on 2013-03-22.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SKAPUnitTest.h"
#import "SLKCoreDataService.h"
#import "Baby.h"
#import "SLKBabyStorage.h"
@implementation SKAPUnitTest
{
    NSManagedObjectContext* moc;
}
- (void)setUp
{
    [super setUp];
    
//    [[SLKCoreDataService sharedService] clearAllData];
    
//    NSManagedObjectModel *mom = [NSManagedObjectModel mergedModelFromBundles: @[[NSBundle mainBundle]]];
//    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
//    STAssertTrue([psc addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL] ? YES : NO, @"Should be able to add in-memory store");
//    moc = [[NSManagedObjectContext alloc] init];
//    moc.persistentStoreCoordinator = psc;
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
      // moc = nil;
}

//- (void)testExample
//{
//    STFail(@"Unit tests are not implemented yet in SKAPUnitTest");
//}
//#pragma mark getBABYWithID
//
//- (void)testGetUserWithID_empty
//{
//    Baby *babe = [[SLKBabyStorage sharedStorage] getBabyWithiD:@"wrongBabyId"];
//    STAssertTrue(babe == nil, @"Baby should not exist");
//}
//
//- (void)testGetUserWithID
//{
//    
//    //GIVEN    
//    Baby *babe = [[SLKBabyStorage sharedStorage] createBabyWithName:@"Vivian"
//                                                             babyId:@"vivvi"
//                                                                pii:[NSNumber numberWithInt:9]
//                                                                poo:[NSNumber numberWithInt:9]
//                                                       feedTimespan:[NSNumber numberWithInt:9]
//                                                             bottle:[NSNumber numberWithInt:9]
//                                                             breast:[NSNumber numberWithInt:9]
//                                                               date:[NSDate date]];
//
//    
//    //WHEN
//    Baby *b = [[SLKBabyStorage sharedStorage] getBabyWithiD:@"vivvi"];
//    
//    //THEN
//    STAssertEqualObjects(babe, b, @"Babies should be equal");
//}
@end
