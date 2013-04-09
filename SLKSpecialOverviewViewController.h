//
//  SLKSpecialOverviewViewController.h
//  SKAP
//
//  Created by Åsa Persson on 2013-04-09.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLKSpecialOverviewViewController : UIViewController
- (IBAction)close:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentcontreoo;
- (IBAction)segmentcontreoo:(id)sender;
- (IBAction)previous:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *previousBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
- (IBAction)next:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableview;


@property BOOL breastFood;
@property BOOL bottledFood;
@property BOOL poo;
@property BOOL pee;
@property BOOL sleep;
@property BOOL medz;
@end
