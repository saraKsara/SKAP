//
//  SLKSubmitDayViewController.h
//  SKAP
//
//  Created by Åsa Persson on 2013-03-26.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "widespace-4.lib/WSAdSpace.h"

@interface SLKDaySummaryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, WSAdSpaceDelegate>
- (IBAction)segmentcontroll:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentcontroll;

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@property (weak, nonatomic) IBOutlet UILabel *pooLabel;

@property (weak, nonatomic) IBOutlet UILabel *peeLabel;

@property (weak, nonatomic) IBOutlet UILabel *foodLabel;

- (IBAction)nextDay:(id)sender;

- (IBAction)prevDay:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)close:(id)sender;


@property BOOL food;
@property BOOL diaper;
@property BOOL sleep;
@property BOOL medz;
@property BOOL allEvents;


@end
