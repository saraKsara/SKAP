//
//  SLKFoodViewController.h
//  SKAP
//
//  Created by Student vid Yrkeshögskola C3L on 3/20/13.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "widespace-4.lib/WSAdSpace.h"


@interface SLKFoodViewController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate, UITextViewDelegate, WSAdSpaceDelegate>

//WS_AdSpace

//SLEEP
@property (weak, nonatomic) IBOutlet UIView *sleepView;

//MEDECINES
@property (weak, nonatomic) IBOutlet UIView *medzView;



//EAT

- (IBAction)leftTit:(UITapGestureRecognizer *)sender;
- (IBAction)rightTit:(UITapGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *prevArrow;
@property (weak, nonatomic) IBOutlet UIImageView *nextArrow;
@property (weak, nonatomic) IBOutlet UIImageView *rightTit;
@property (weak, nonatomic) IBOutlet UIImageView *leftTit;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControll;
@property (weak, nonatomic) IBOutlet UIView *bottleView;
@property (weak, nonatomic) IBOutlet UIView *breastView;

//DIAPER
@property (weak, nonatomic) IBOutlet UIView *diaperView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *diaperLabels;
- (IBAction)check:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *switchOne;
- (IBAction)switchOne:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *switchTwo;
- (IBAction)switchTwo:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *pee;
@property (weak, nonatomic) IBOutlet UIButton *poo;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

//POO
@property (weak, nonatomic) IBOutlet UIButton *normalPoo;
@property (weak, nonatomic) IBOutlet UIButton *tooMuchPoo;
@property (weak, nonatomic) IBOutlet UIButton *tooLittlePoo;
//PII
@property (weak, nonatomic) IBOutlet UIButton *normalPii;
@property (weak, nonatomic) IBOutlet UIButton *tooMuchPii;

@property (weak, nonatomic) IBOutlet UIButton *tooLittlePii;




//BASE VIEW

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *pageViews;


@property (weak, nonatomic) IBOutlet UILabel *universalSliderText;

@property (weak, nonatomic) IBOutlet UILabel *UniversalLabel;

@property (weak, nonatomic) IBOutlet UILabel *sliderOneLabel;
@property (weak, nonatomic) IBOutlet UISlider *sliderOne;
- (IBAction)sliderOneAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *sliderTwoLabel;
@property (weak, nonatomic) IBOutlet UISlider *sliderTwo;
- (IBAction)sliderTwoAction:(id)sender;

//PAGE CONTROL
- (IBAction)valuePageControll:(id)sender;
- (IBAction)touchUpInsidePageControll:(id)sender;
- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognize;


@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;
@property (weak, nonatomic) IBOutlet UILabel *setTimeLabel;

- (IBAction)save:(id)sender;
- (IBAction)setTime:(id)sender;
- (IBAction)sooner:(id)sender;
- (IBAction)later:(id)sender;

//-(UIImage*)drawImageWithColor:(UIColor*)color;


@end
