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

@interface SLKDaySummaryViewController ()

@end

@implementation SLKDaySummaryViewController
{
    Baby *currentBaby;
    NSDate *currentDay;
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
    currentDay = [NSDate date];
    currentBaby = [[SLKBabyStorage sharedStorage] getCurrentBaby];
    _headerLabel.text = [NSString stringWithFormat:@"This is what happened %@ at %@", currentBaby.name, [SLKDateUtil formatDateWithoutYear: currentDay]];
    
    //TODO: decide how to represent pee and poo
//    _peeLabel.text = [NSString stringWithFormat:@"Peed: %@ ml/times", currentBaby.pii];
//    _pooLabel.text =  [NSString stringWithFormat:@"Pooped %@ ml/times", currentBaby.poo];
//    
//    //TODO: for each time span, create a string that tell what time and what and how much the baby ate
//     _foodLabel.text =  [NSString stringWithFormat:@"Ate %@ ml/times", currentBaby.feedTimespan];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextDay:(id)sender
{
    currentDay = [currentDay dateByAddingDays:1];
      _headerLabel.text = [NSString stringWithFormat:@"This is what happened %@ at %@", currentBaby.name, [SLKDateUtil formatDateWithoutYear: currentDay]];
    [_tableView reloadData];
}

- (IBAction)prevDay:(id)sender
{
    currentDay = [currentDay dateBySubtractingDays:1];
      _headerLabel.text = [NSString stringWithFormat:@"This is what happened %@ at %@", currentBaby.name, [SLKDateUtil formatDateWithoutYear: currentDay]];
    [_tableView reloadData];
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
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc] init];
//    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
//    headerLabel.textColor = [UIColor blackColor];
    headerLabel.text =  @"Time\t event\t more";
    return headerLabel.text;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *CellIdentifier = @"dayViewCell";
        SLKDayViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        Event *event = [[[SLKEventStorage sharedStorage] getEventBelomigTObaby:currentBaby andDay:currentDay] objectAtIndex:indexPath.row];
    
    cell.timeLabel.text = [SLKDateUtil formatTimeFromDate: event.date];
    cell.eventLabel.text = event.type;
    if ([event.type isEqualToString: kEventType_TitFood]) {
//        Tits *tit = [[SLKTittStorage sharedStorage] getTitThatBelongsToEvent:event];
//        NSLog(@"tit thet belongs to evebt: %@", tit.milliLitres);
        NSSet *titset = [event tities];
        NSString *propertyString;
        NSLog(@"antalet tittevent: %d", [titset count]);
        for(Tits *tit in titset)
        {
            NSLog(@"tit::: %@",tit);

            propertyString = [tit.minutes stringValue];
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

@end
