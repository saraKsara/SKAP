//
//  SLKFoodViewController.h
//  SKAP
//
//  Created by Student vid Yrkeshögskola C3L on 3/20/13.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLKFoodViewController : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *foodLabel;
@property (weak, nonatomic) IBOutlet UILabel *anotherFoodLable;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (weak, nonatomic) IBOutlet UISlider *foodSliderOne;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControll;
@property (weak, nonatomic) IBOutlet UIView *bottleView;
@property (weak, nonatomic) IBOutlet UIView *breastView;
- (IBAction)valuePageControll:(id)sender;
- (IBAction)touchUpInsidePageControll:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
- (IBAction)sliderOneValueChanged:(id)sender;
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;
@property (weak, nonatomic) IBOutlet UILabel *setTimeLabel;
- (IBAction)save:(id)sender;
- (IBAction)setTime:(id)sender;
- (IBAction)sooner:(id)sender;
- (IBAction)later:(id)sender;

-(UIImage*)drawImageWithColor:(UIColor*)color;
- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;
@end
