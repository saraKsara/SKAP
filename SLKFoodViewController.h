//
//  SLKFoodViewController.h
//  SKAP
//
//  Created by Student vid Yrkeshögskola C3L on 3/20/13.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLKFoodViewController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *overview;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *pageViews;

- (IBAction)showOverview:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *universalSliderText;

@property (weak, nonatomic) IBOutlet UILabel *UniversalLabel;

@property (weak, nonatomic) IBOutlet UILabel *sliderOneLabel;
@property (weak, nonatomic) IBOutlet UISlider *sliderOne;
- (IBAction)sliderOneAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *sliderTwoLabel;
@property (weak, nonatomic) IBOutlet UISlider *sliderTwo;
- (IBAction)sliderTwoAction:(id)sender;

//SLEEP
@property (weak, nonatomic) IBOutlet UIView *sleepView;


//EAT



- (IBAction)leftTit:(UITapGestureRecognizer *)sender;
- (IBAction)rightTit:(UITapGestureRecognizer *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *rightTit;
@property (weak, nonatomic) IBOutlet UIImageView *leftTit;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControll;
@property (weak, nonatomic) IBOutlet UIView *bottleView;
@property (weak, nonatomic) IBOutlet UIView *breastView;
- (IBAction)valuePageControll:(id)sender;
- (IBAction)touchUpInsidePageControll:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
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
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognize;

@end
