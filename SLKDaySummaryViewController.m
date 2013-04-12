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

@interface SLKDaySummaryViewController ()

@end

@implementation SLKDaySummaryViewController
{
    Baby *currentBaby;
    NSDate *currentDay;
    NSDate *fromDate;
    NSDate *todate;
    BOOL weekView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    _allEvents = YES;
    weekView = NO;
    currentDay = [NSDate date];
    todate = [currentDay dateByAddingDays:7];
    fromDate = [NSDate date];
    
    currentBaby = [[SLKBabyStorage sharedStorage] getCurrentBaby];
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
	// Do any additional setup after loading the view.
}

- (IBAction)close:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)segmentcontroll:(id)sender {
    if ( _segmentcontroll.selectedSegmentIndex == 0 )
    {
        weekView = NO;
        currentDay = [NSDate date];
        todate = [currentDay dateByAddingDays:7];
        fromDate = [NSDate date];
        _headerLabel.text = [NSString stringWithFormat:@" %@ \n%@",
                             currentBaby.name, [SLKDateUtil formatDateWithoutYear: currentDay]];
    } else if ( _segmentcontroll.selectedSegmentIndex == 1 )
    {
        weekView = YES;
        currentDay = [NSDate date];
        todate = [currentDay dateByAddingDays:7];
        fromDate = [NSDate date];
        _headerLabel.text = [NSString stringWithFormat:@" %@ \n This Week",
                             currentBaby.name];
    }
}

- (IBAction)nextDay:(id)sender
{
    if (!weekView) {
    currentDay = [currentDay dateByAddingDays:1];
      _headerLabel.text = [NSString stringWithFormat:@"%@ \n %@", currentBaby.name, [SLKDateUtil formatDateWithoutYear: currentDay]];
        NSLog(@"\n\nfromdate:::::: %@\n\n", fromDate);
        NSLog(@"\n\ntodate:::::: %@\n\n", todate);
         [self reloadTable];
    } else if (weekView){
        fromDate = [fromDate dateByAddingDays:7];
        todate = [todate dateByAddingDays:7];
        NSLog(@"CD:::::: %@", currentDay);
        NSLog(@"\n\nfromdate:::::: %@\n\n", fromDate);
        NSLog(@"\n\ntodate:::::: %@\n\n", todate);
        _headerLabel.text = [NSString stringWithFormat:@"%@ \n between %@ - %@", currentBaby.name, [SLKDateUtil formatDateWithoutYear: fromDate],[SLKDateUtil formatDateWithoutYear: todate]];

         [self reloadTable];
    }
   
}

- (IBAction)prevDay:(id)sender
{
    if (!weekView) {
        currentDay = [currentDay dateBySubtractingDays:1];
        _headerLabel.text = [NSString stringWithFormat:@"%@ \n  %@", currentBaby.name, [SLKDateUtil formatDateWithoutYear: currentDay]];
        NSLog(@"\n\nfromdate:::::: %@\n\n", fromDate);
        NSLog(@"\n\ntodate:::::: %@\n\n", todate);
         [self reloadTable];
    } else if (weekView) {
        fromDate = [fromDate dateBySubtractingDays:7];
        todate = [todate dateBySubtractingDays:7];
        NSLog(@"\n\nfromdate:::::: %@\n\n", fromDate);
         NSLog(@"\n\ntodate:::::: %@\n\n", todate);
            _headerLabel.text = [NSString stringWithFormat:@"%@ \n between %@ - %@", currentBaby.name, [SLKDateUtil formatDateWithoutYear: fromDate],[SLKDateUtil formatDateWithoutYear: todate]];
         [self reloadTable];
    }

    [self reloadTable];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    NSArray *typeArray;
    if (_allEvents) {
       if (!weekView) return [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby andDay:currentDay]count];
    else if (weekView) return [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby fromDate:fromDate toDate:todate]count];
    }
    else if (_food) {
       typeArray = [NSArray arrayWithObjects:kEventType_BottleFood,kEventType_TitFood, nil];
        return [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby andDay:currentDay withTypes:typeArray]count];
    }
    else if (_diaper) {
  
       typeArray =  [NSArray arrayWithObjects:kEventType_Poo,kEventType_Pii, nil];
        return [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby andDay:currentDay withTypes:typeArray]count];
    }
    else  {
        //TODO: create medzconstant!
        typeArray =  [NSArray arrayWithObjects:kEventType_Pii, nil];
        return [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby andDay:currentDay withTypes:typeArray]count];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(0, 0, 285, 30);
    title.textColor = [UIColor blackColor];
    title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0f];
    title.text =  @"Time\t\t\t\t\t\t\t event";
    title.backgroundColor = [UIColor colorWithHexValue:kBG_Color];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [view addSubview:title];
    
    return  view;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *CellIdentifier = @"dayViewCell";
    SLKDayViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //forIndexPath:indexPath];
    NSArray *typeArray;
    Event *event;
    
    if (_allEvents) {
        
if (!weekView) event = [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby andDay:currentDay]objectAtIndex:indexPath.row];
else event = [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby fromDate:fromDate toDate:todate]objectAtIndex:indexPath.row];
        
    }
    else if (_food) {
        typeArray = [NSArray arrayWithObjects:kEventType_BottleFood,kEventType_TitFood, nil];
        event = [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby andDay:currentDay withTypes:typeArray]objectAtIndex:indexPath.row];
    }
    else if (_diaper) {
         typeArray = [NSArray arrayWithObjects:kEventType_Poo,kEventType_Pii, nil];
        event = [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby andDay:currentDay withTypes:typeArray]objectAtIndex:indexPath.row];
    }
 
    else if (_medz) {
        //TODO: create med constant!
        typeArray = [NSArray arrayWithObjects:kEventType_Pii, nil];
        event = [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby andDay:currentDay withTypes:typeArray]objectAtIndex:indexPath.row];
    }
    else if (_sleep) {
        //TODO: create pee constant!
        typeArray = [NSArray arrayWithObjects:kEventType_Pii, nil];
        event = [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby andDay:currentDay withTypes:typeArray]objectAtIndex:indexPath.row];
    }
    
//    cell.timeLabel.text = [SLKDateUtil formatTimeFromDate: event.date];
    cell.timeLabel.text = [SLKDateUtil formatDateWithoutYear: event.date];
    
    // BREAST FEED
    if ([event.type isEqualToString: kEventType_TitFood]) {
        cell.eventLabel.text = @"Feeded: \nbreast milk";
        NSSet *titset = [event tities];
        NSMutableString *propertyString = [[NSMutableString alloc] init];
        for(Tits *tit in titset)
        {
            NSString *breast;
            if (tit.rightBoob == [NSNumber numberWithInt:1]) {
                breast = @"right";
            } else if (tit.leftBoob == [NSNumber numberWithInt:1])
            {
                breast = @"left";  
            }
           // NSLog(@"tit::: %@",tit);
            if (tit.minutes != nil)
            {
            [propertyString appendFormat: @"%@ minutes \n %@ breast",[tit.minutes stringValue], breast];
            }
            else if (tit.milliLitres != nil)
            {
            [propertyString appendFormat: @"%@ ml \n %@ breast",[tit.milliLitres stringValue], breast];
            }
            else if (tit.stringValue != nil)
            {
                [propertyString appendFormat: @"%@ breast \n %@ ",breast,tit.stringValue];
            }
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
    if ([event.type isEqualToString: kEventType_Poo]) {
        cell.eventLabel.text = @"Pooped:";
        NSSet *set = [event poos];
        NSMutableString *propertyString = [[NSMutableString alloc] init];
        for(Poo *poo in set)
        {
            if (poo.normal == [NSNumber numberWithInt:1])
            {
                [propertyString appendFormat: @"Good poo"];
            }
            else if (poo.tooMuch == [NSNumber numberWithInt:1])
            {
                [propertyString appendFormat: @"Too much"];
            }
            else if (poo.toLittle == [NSNumber numberWithInt:1])
            {
                [propertyString appendFormat: @"Too little"];
            }
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
            if (pii.normal == [NSNumber numberWithInt:1])
            {
                [propertyString appendFormat: @"Good pii"];
            }
            else if (pii.tooMuch == [NSNumber numberWithInt:1])
            {
                [propertyString appendFormat: @"Too much"];
            }
            else if (pii.tooLittle  == [NSNumber numberWithInt:1])
            {
                [propertyString appendFormat: @"Too little"];
            }
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
