//
//  SLKSubmitDayViewController.h
//  SKAP
//
//  Created by Åsa Persson on 2013-03-26.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLKDaySummaryViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@property (weak, nonatomic) IBOutlet UILabel *pooLabel;

@property (weak, nonatomic) IBOutlet UILabel *peeLabel;

@property (weak, nonatomic) IBOutlet UILabel *foodLabel;

- (IBAction)nextDay:(id)sender;

- (IBAction)prevDay:(id)sender;

@end
