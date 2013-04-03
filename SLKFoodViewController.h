//
//  SLKFoodViewController.h
//  SKAP
//
//  Created by Student vid Yrkeshögskola C3L on 3/20/13.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLKFoodViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *foodLabel;
@property (weak, nonatomic) IBOutlet UILabel *anotherFoodLable;

@property (weak, nonatomic) IBOutlet UISlider *foodSliderOne;

@property (weak, nonatomic) IBOutlet UISlider *foodSliderTwo;
- (IBAction)sliderOneValueChanged:(id)sender;
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;
@property (weak, nonatomic) IBOutlet UILabel *setTimeLabel;
- (IBAction)save:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControll;
- (IBAction)segmentAction:(id)sender;


@end
