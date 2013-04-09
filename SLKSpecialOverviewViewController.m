//
//  SLKSpecialOverviewViewController.m
//  SKAP
//
//  Created by Åsa Persson on 2013-04-09.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKSpecialOverviewViewController.h"
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
@interface SLKSpecialOverviewViewController ()

@end

@implementation SLKSpecialOverviewViewController
{
    Baby *currentBaby;
    NSDate *currentDay;
    NSString *type;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    currentDay = [NSDate date];
    currentBaby = [[SLKBabyStorage sharedStorage] getCurrentBaby];
    self.view.backgroundColor = [UIColor clearColor];
    
    _headerLabel.text = [NSString stringWithFormat:@"This is what happened %@ \n at %@",
                         currentBaby.name, [SLKDateUtil formatDateWithoutYear: currentDay]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTable)
                                                 name:@"reloadCalendar"
                                               object:nil];
   

	// Do any additional setup after loading the view.
}
-(void)reloadTable
{
    [_tableview reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setSegmentcontreoo:nil];
    [self setPreviousBtn:nil];
    [self setNextBtn:nil];
    [self setHeaderLabel:nil];
    [self setTableview:nil];
    [super viewDidUnload];
}


- (IBAction)previous:(id)sender {
    
    currentDay = [currentDay dateBySubtractingDays:1];
    _headerLabel.text = [NSString stringWithFormat:@"This is how much%@ \n ate at %@", currentBaby.name, [SLKDateUtil formatDateWithoutYear: currentDay]];
    [self reloadTable];
}
- (IBAction)next:(id)sender {
    currentDay = [currentDay dateByAddingDays:1];
    _headerLabel.text = [NSString stringWithFormat:@"This is how much %@ \n ate st %@", currentBaby.name, [SLKDateUtil formatDateWithoutYear: currentDay]];
    [self reloadTable];
}


- (IBAction)close:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)segmentcontreoo:(id)sender {
    if ( _segmentcontreoo.selectedSegmentIndex == 0 )
    {
        _headerLabel.text = [NSString stringWithFormat:@"This is how much%@ \n ate at %@",
                             currentBaby.name, [SLKDateUtil formatDateWithoutYear: currentDay]];
    } else if ( _segmentcontreoo.selectedSegmentIndex == 1 )
    {
        _headerLabel.text = [NSString stringWithFormat:@"This is how much%@ \n This Week",
                             currentBaby.name];
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby andDay:currentDay]count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(5, 0, 200, 30);
    title.textColor = [UIColor blackColor];
    title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0f];
    title.text =  @"Time\t\t\t\t\t\t\t event";
    title.backgroundColor = [UIColor clearColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [view addSubview:title];
    
    return  view;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"dayViewCell";
    SLKDayViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //forIndexPath:indexPath];
    
    Event *event;
    if (_breastFood) {
        event = [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby andDay:currentDay withType:kEventType_TitFood]objectAtIndex:indexPath.row];
           cell.timeLabel.text = [SLKDateUtil formatTimeFromDate: event.date];

    // BREAST FEED
   // if ([event.type isEqualToString: kEventType_TitFood]) {
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
            NSLog(@"tit::: %@",tit);
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
        
    //}
    }
    //BOTTLE FOOD
    if (_bottledFood) {
        event = [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby andDay:currentDay withType:kEventType_BottleFood]objectAtIndex:indexPath.row];
        cell.timeLabel.text = [SLKDateUtil formatTimeFromDate: event.date];
        
        
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
    if (_poo) {
        event = [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby andDay:currentDay withType:kEventType_Poo]objectAtIndex:indexPath.row];
        cell.timeLabel.text = [SLKDateUtil formatTimeFromDate: event.date];
        
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
    if (_poo) {
        event = [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby andDay:currentDay withType:kEventType_Poo]objectAtIndex:indexPath.row];
        cell.timeLabel.text = [SLKDateUtil formatTimeFromDate: event.date];
        
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


@end
