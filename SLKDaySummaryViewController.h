//
//  SLKSubmitDayViewController.h
//  SKAP
//
//  Created by Åsa Persson on 2013-03-26.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLKDaySummaryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
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

@property BOOL breastFood;
@property BOOL bottledFood;
@property BOOL food;
@property BOOL poo;
@property BOOL pee;
@property BOOL sleep;
@property BOOL medz;
@property BOOL allEvents;


@end
