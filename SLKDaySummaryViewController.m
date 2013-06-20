//
//  SLKSubmitDayViewController.m
//  SKAP
//
//  Created by Åsa Persson on 2013-03-26.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKDaySummaryViewController.h"
#import "SLKBabyStorage.h"
#import "Baby.h"
#import "SLKDateUtil.h"
#import "SLKDates.h"
#import "Event.h"
#import "Pii.h"
#import "Poo.h"
#import "Tits.h"
#import "Bottle.h"
#import "SLKEventStorage.h"
#import "SLKDayViewCell.h"
#import "SLKConstants.h"
#import "SLKTittStorage.h"
#import "SLKColors.h"
#import "Sleep.h"
#import "SLKSleepStorage.h"
#import "Diaper.h"
#import "SLKStringUtil.h"

@interface SLKDaySummaryViewController ()

@end

@implementation SLKDaySummaryViewController
{
    Baby *currentBaby;
    NSDate *currentDay;
    NSDate *fromDate;
    NSDate *todate;
    WSAdSpace *splashAdView;
    NSArray *weeks;
    NSArray *days;
    NSMutableDictionary *eventDict;
    NSArray *eventArray;
    NSMutableDictionary *dayOfEventsDict;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (UIViewController *)rootViewController {
    // You don't need to do more than this here. The widespace SDK simply needs to know about your viewController (i.e self)
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    _allEvents = YES;
    _dateUnit = day;
    currentDay = [NSDate date];
    todate = [currentDay dateByAddingDays:7];
    fromDate = [NSDate date];
    
    currentBaby = [[SLKBabyStorage sharedStorage] getCurrentBaby];
    
    NSLog(@"viewWillAppearcurrentBabyNAMEE : %@", currentBaby.name);

  //  NSArray *eventOfDayArray = [[SLKEventStorage sharedStorage] getEventByDay:dayKey];
    
   eventDict =  [[NSMutableDictionary alloc] init];
   // eventArray = [[NSArray alloc] init];
    
    self.view.backgroundColor = [UIColor clearColor];

    _headerLabel.text = [NSString stringWithFormat:@"%@ \n  %@",
                         currentBaby.name, [SLKDateUtil formatDateWithoutYear: currentDay]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTable)
                                                 name:@"reloadCalendar"
                                               object:nil];

    //TODO: decide how to represent pee and poo
//    _peeLabel.text = [NSString stringWithFormat:@"Peed: %@ ml/times", currentBaby.pii];
//    _pooLabel.text =  [NSString stringWithFormat:@"Pooped %@ ml/times", currentBaby.poo];
//    
//    //TODO: for each time span, create a string that tell what time and what and how much the baby ate
//     _foodLabel.text =  [NSString stringWithFormat:@"Ate %@ ml/times", currentBaby.feedTimespan];
    
}
-(void)reloadTable
{
    //[_tableView reloadData];
    currentBaby = [[SLKBabyStorage sharedStorage] getCurrentBaby];
    [UIView transitionWithView:_tableView
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        [_tableView reloadData];
                    } completion:NULL];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    splashAdView = [[WSAdSpace alloc] initWithFrame:CGRectMake(0, 0,320 ,88)  sid:@"f48a4efe-0567-4bc5-b426-8e385f386a87" autoUpdate:NO autoStart:NO delegate:self];
    
    // Add WSAdSpace as a subview of MyViewController
    // splashAdView.backgroundColor = [UIColor redColor];
    [self.view addSubview:splashAdView];
    [self.view bringSubviewToFront:splashAdView];
    
    currentBaby = [[SLKBabyStorage sharedStorage] getCurrentBaby];//TODO: where to get this??? now its getted two times
    dayOfEventsDict = [[NSMutableDictionary alloc] init];

    eventDict = [[SLKEventStorage sharedStorage] getAllDaysWithEventforBaby:currentBaby];
    eventArray = [eventDict allKeys];

    for (NSString *str in [eventDict allKeys])
    {
        NSArray *eventOfDayArray = [[SLKEventStorage sharedStorage] getEventByDay:str];
        [dayOfEventsDict setObject:eventOfDayArray forKey:str];
    }
   // weeks = [[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby andDay:currentDay];
    
        [splashAdView prefetchAd];

}
- (void)didPrefetchAd:(WSAdSpace *)adSpace mediaStatus:(NSString *)mediaStatus
{
    NSLog(@"did finish prefetch----%@-----%@",adSpace, mediaStatus);
    NSLog(@"Frame on prefetched ad-------%@", NSStringFromCGRect(adSpace.frame));
    [splashAdView runAd];
}

- (IBAction)close:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)segmentcontroll:(id)sender {
    if ( _segmentcontroll.selectedSegmentIndex == 0 )
    {
        _dateUnit = day;
        currentDay = [NSDate date];
        NSLog(@"\n\n\n weekDAY:-----> %d \n\n", [currentDay weekday]);

        todate = [currentDay dateByAddingDays:7];
        fromDate = [NSDate date];
         [self reloadTable];
        _headerLabel.text = [NSString stringWithFormat:@" %@ \n%@",
                             currentBaby.name, [SLKDateUtil formatDateWithoutYear: currentDay]];
    } else if ( _segmentcontroll.selectedSegmentIndex == 1 )
    {
        _dateUnit = week;
        currentDay = [NSDate date];
        if (currentDay.weekday == 1)//------------------sunday
        {
            todate = currentDay;
            fromDate = [currentDay dateBySubtractingDays:6];//monday?
            
        } else if (currentDay.weekday == 2)//------------------monday
        {
            todate = [currentDay dateByAddingDays:6];//sunday?
            fromDate = currentDay;//monday?
            
        }  else if (currentDay.weekday == 3)//------------------tuesday
        {
            todate = [currentDay dateByAddingDays:5];//sunday?
            fromDate = [currentDay dateBySubtractingDays:1];//monday?
            
        } else if (currentDay.weekday == 4)//------------------wednesday
        {
            todate = [currentDay dateByAddingDays:4];//sunday?
            fromDate = [currentDay dateBySubtractingDays:2];//monday?
            
        }  else if (currentDay.weekday == 5)//------------------thursday
        {
            todate = [currentDay dateByAddingDays:3];//sunday?
            fromDate = [currentDay dateBySubtractingDays:3];//monday?
            
        }  else if (currentDay.weekday == 6)//------------------friday
        {
            todate = [currentDay dateByAddingDays:2];//sunday?
            fromDate = [currentDay dateBySubtractingDays:4];//monday?
            
        } else if (currentDay.weekday == 7)//------------------thursday
        {
            todate = [currentDay dateByAddingDays:1];//sunday?
            fromDate = [currentDay dateBySubtractingDays:5];//monday?
        }
      
         [self reloadTable];
           _headerLabel.text = [NSString stringWithFormat:@"%@ \n between %@ - %@", currentBaby.name, [SLKDateUtil formatDateWithoutYear: fromDate],[SLKDateUtil formatDateWithoutYear: todate]];
    }
}

- (IBAction)nextDay:(id)sender
{
    if (_dateUnit == day) {
    currentDay = [currentDay dateByAddingDays:1];
      _headerLabel.text = [NSString stringWithFormat:@"%@ \n %@", currentBaby.name, [SLKDateUtil formatDateWithoutYear: currentDay]];
    
         [self reloadTable];
    } else if (_dateUnit == week){
        fromDate = [fromDate dateByAddingDays:7];
        todate = [todate dateByAddingDays:7];
    
        _headerLabel.text = [NSString stringWithFormat:@"%@ \n between %@ - %@", currentBaby.name, [SLKDateUtil formatDateWithoutYear: fromDate],[SLKDateUtil formatDateWithoutYear: todate]];

         [self reloadTable];
               
    }
   
}

- (IBAction)prevDay:(id)sender
{
    if (_dateUnit == day) {
        currentDay = [currentDay dateBySubtractingDays:1];
        _headerLabel.text = [NSString stringWithFormat:@"%@ \n  %@", currentBaby.name, [SLKDateUtil formatDateWithoutYear: currentDay]];
  
         [self reloadTable];
    } else if (_dateUnit == week) {
        fromDate = [fromDate dateBySubtractingDays:7];
        todate = [todate dateBySubtractingDays:7];
   
            _headerLabel.text = [NSString stringWithFormat:@"%@ \n between %@ - %@", currentBaby.name, [SLKDateUtil formatDateWithoutYear: fromDate],[SLKDateUtil formatDateWithoutYear: todate]];
         [self reloadTable];
    }

    [self reloadTable];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"numberOfSectionsInTableView: %d", [eventArray count]);
    return eventArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (_allEvents) {
//        if (_dateUnit == day) return [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby andDay:currentDay]count];
//        else  return [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby fromDate:fromDate toDate:todate]count];
//    }
   // NSArray *eventArray = [[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby];
    for (int i = 0; i < eventArray.count; i++)
    {
        if (section == i) {
            NSString *day = [eventArray objectAtIndex:i];
            NSLog(@"numberOfRowsInSection: %d", [[dayOfEventsDict objectForKey:day] count]);
            return [[dayOfEventsDict objectForKey:day] count];
        }
    }
      //  NSArray *typeArray;

//    else if (_food) {
//       typeArray = [NSArray arrayWithObjects:kEventType_BottleFood,kEventType_TitFood, nil];
//        return [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby andDay:currentDay withTypes:typeArray]count];
//    }
//    else if (_diaper) {
//  
//       typeArray =  [NSArray arrayWithObjects:kEventType_Poo,kEventType_Pii, nil];
//        return [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby andDay:currentDay withTypes:typeArray]count];
//    }
//    else if(_medz) {
//        //TODO: create medzconstant!
//        typeArray =  [NSArray arrayWithObjects:kEventType_Medz, nil];
//        return [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby andDay:currentDay withTypes:typeArray]count];
//    }
//    else if (_sleep) {
//        //TODO: create medzconstant!
//        typeArray =  [NSArray arrayWithObjects:kEventType_Sleep, nil];
//        return [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby andDay:currentDay withTypes:typeArray]count];
//    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel *title = [[UILabel alloc] init];
//    title.frame = CGRectMake(0, 0, 285, 30);
//    title.textColor = [UIColor blackColor];
//    title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0f];
//    title.text =  @"Time\t\t\t\t\t\t\t event";
//    title.backgroundColor = [UIColor colorWithHexValue:kBG_Color];
//    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
//    [view addSubview:title];
//    
//    return  view;
//    
//}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [eventArray objectAtIndex:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *CellIdentifier = @"dayViewCell";
    SLKDayViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //forIndexPath:indexPath];
   // NSArray *typeArray;
    Event *event;
    
    NSString *dayy = [eventArray objectAtIndex:indexPath.section];
    NSArray *a = [dayOfEventsDict objectForKey:dayy];
    
    event = [a objectAtIndex:indexPath.row];
    
    
//    if (_allEvents) {
//        
//if (_dateUnit == day) event = [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby andDay:currentDay]objectAtIndex:indexPath.row];
//else event = [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby fromDate:fromDate toDate:todate]objectAtIndex:indexPath.row];
//        
//    }
//    else if (_food) {
//        typeArray = [NSArray arrayWithObjects:kEventType_BottleFood,kEventType_TitFood, nil];
//        event = [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby andDay:currentDay withTypes:typeArray]objectAtIndex:indexPath.row];
//    }
//    else if (_diaper) {
//         typeArray = [NSArray arrayWithObjects:kEventType_Poo,kEventType_Pii, nil];
//        event = [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby andDay:currentDay withTypes:typeArray]objectAtIndex:indexPath.row];
//    }
// 
//    else if (_medz) {
//        typeArray = [NSArray arrayWithObjects:kEventType_Medz, nil];
//        event = [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby andDay:currentDay withTypes:typeArray]objectAtIndex:indexPath.row];
//    }
//    else if (_sleep) {
//        typeArray = [NSArray arrayWithObjects:kEventType_Sleep, nil];
//        event = [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby andDay:currentDay withTypes:typeArray]objectAtIndex:indexPath.row];
//    }
//    
//    if (_dateUnit == week) {
//          cell.timeLabel.text =  [NSString stringWithFormat:@"%@ \n %@ ", [SLKDateUtil formatTimeFromDate: event.date],[SLKDateUtil formatDateWithoutYear: event.date]];
//    }else if (_dateUnit == day) {
         cell.timeLabel.text = [SLKDateUtil formatTimeFromDate: event.date];
//    }
 
        
    // BREAST FEED
    if ([event.type isEqualToString: kEventType_TitFood]) {
        cell.eventLabel.text = @"Feeded: \nbreast milk";
        NSSet *titset = [event tities];
        NSMutableString *propertyString = [[NSMutableString alloc] init];
        for(Tits *tit in titset)
        {
            NSString *breast;
            if (tit.rightBoob == [NSNumber numberWithInt:1] && tit.leftBoob == [NSNumber numberWithInt:0]){
                breast = @"right";
            } else if (tit.leftBoob == [NSNumber numberWithInt:1] && tit.rightBoob == [NSNumber numberWithInt:0])
            {
                breast = @"left";  
            } else if (tit.leftBoob == [NSNumber numberWithInt:1] && tit.rightBoob == [NSNumber numberWithInt:1])
            {
                breast = @"both";
            }
             [propertyString appendFormat: @"%@ breast \n %@ ",breast,tit.stringValue];
           // NSLog(@"tit::: %@",tit);
//            if (tit.minutes != nil)
//            {
//            [propertyString appendFormat: @"%@ minutes \n %@ breast",[tit.minutes stringValue], breast];
//            }
//            else if (tit.milliLitres != nil)
//            {
//            [propertyString appendFormat: @"%@ ml \n %@ breast",[tit.milliLitres stringValue], breast];
//            }
//            else if (tit.stringValue != nil)
//            {
//                [propertyString appendFormat: @"%@ breast \n %@ ",breast,tit.stringValue];
//            }
        }
        cell.propertyLabel.text = propertyString;
    }
    
    //BOTTLE FOOD
    if ([event.type isEqualToString: kEventType_BottleFood]) {
        cell.eventLabel.text = @"Feeded: \n milk substitute";
        NSSet *set = [event bottles];
        NSMutableString *propertyString = [[NSMutableString alloc] init];
        for(Bottle *bottle in set)
        {
            if (bottle.minutes != nil)
            {
                [propertyString appendFormat: @"%@ minutes",[bottle.minutes stringValue]];
            }
            else if (bottle.milliLitres != nil)
            {
                [propertyString appendFormat: @"%@ ml ",[bottle.milliLitres stringValue]];
            }
            else if (bottle.stringValue != nil)
            {
                [propertyString appendFormat: @" %@ ",bottle.stringValue];
            }
        }
        cell.propertyLabel.text = propertyString;
    }

    //POO
    if ([event.type isEqualToString: kEventType_Diaper]) {
      
        NSSet *set = [event diapers];
        NSMutableString *propertyString = [[NSMutableString alloc] init];
        for(Diaper *diaper in set)
        {
            if (diaper.piied)    cell.eventLabel.text = @"Peed:";
             if (diaper.pooped)   cell.eventLabel.text = @"Pooped:";
            if (event.comments != nil)  [propertyString appendFormat: @"%@ ",event.comments];
        }
        cell.propertyLabel.text = propertyString;
    }
    //POO
    if ([event.type isEqualToString: kEventType_Poo]) {
        cell.eventLabel.text = @"Pooped:";
        NSSet *set = [event poos];
        NSMutableString *propertyString = [[NSMutableString alloc] init];
        for(Poo *poo in set)
        {
            
            if (event.comments != nil)  [propertyString appendFormat: @"%@ ",event.comments];
        }
        cell.propertyLabel.text = propertyString;
    }

    
    //PII
    if ([event.type isEqualToString: kEventType_Pii]) {
        cell.eventLabel.text = @"Piied:";
        
        NSSet *set = [event piis];
        NSMutableString *propertyString = [[NSMutableString alloc] init];
        for(Pii *pii in set)
        {
            if (event.comments != nil)  [propertyString appendFormat: @"%@ ",event.comments];
     
        }
        cell.propertyLabel.text = propertyString;
    }
    
    //Sleep
    if ([event.type isEqualToString: kEventType_Sleep]) {
        cell.eventLabel.text = @"Slept:";
        NSSet *set = [event sleeps];
        NSMutableString *propertyString = [[NSMutableString alloc] init];
        for(Sleep *sleep in set)
        {
            [propertyString appendFormat: @" for  %@ minutes",sleep.minutes];
           
        }
        cell.propertyLabel.text = propertyString;
    }

    return cell;

}



#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath");
}


- (void)viewDidUnload {
    [self setSegmentcontroll:nil];
    [super viewDidUnload];
 }
@end
