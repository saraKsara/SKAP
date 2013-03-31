//
//  SLKPiiPooViewController.h
//  SKAP
//
//  Created by Student vid Yrkeshögskola C3L on 3/20/13.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SLKPiiPooViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *normalPoo;
@property (weak, nonatomic) IBOutlet UIButton *tooMuchPoo;
@property (weak, nonatomic) IBOutlet UIButton *tooLittlePoo;
@property (weak, nonatomic) IBOutlet UIButton *save;
- (IBAction)sooner:(id)sender;
- (IBAction)later:(id)sender;

- (IBAction)check:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *normalPii;
@property (weak, nonatomic) IBOutlet UIButton *tooMuchPii;

@property (weak, nonatomic) IBOutlet UIButton *tooLittlePii;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
- (IBAction)setTimewithSlider:(id)sender;



@property (weak, nonatomic) IBOutlet UILabel *nameOfBabyLabel;
- (IBAction)save:(id)sender;

@end
