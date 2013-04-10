//
//  SLKSleppViewController.h
//  SKAP
//
//  Created by Åsa Persson on 2013-04-09.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLKSleppViewController : UIViewController
- (IBAction)sleepOverview:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *setTime;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property (weak, nonatomic) IBOutlet UIButton *totalOverview;
- (IBAction)totalOverview:(id)sender;
- (IBAction)sooner:(id)sender;
- (IBAction)later:(id)sender;
- (IBAction)setTimeWithSlider:(id)sender;

@end
