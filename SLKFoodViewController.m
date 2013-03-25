//
//  SLKFoodViewController.m
//  SKAP
//
//  Created by Student vid Yrkeshögskola C3L on 3/20/13.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKFoodViewController.h"

@interface SLKFoodViewController ()

@end

@implementation SLKFoodViewController
{
    float bottledFood;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * 1.5);
    _foodSliderOne.transform = trans;
    _anotherFoodLable.text = @"This is what your baby ate!";
    bottledFood = _foodSliderOne.value;
    _foodLabel.text = [NSString stringWithFormat:@"%.f",bottledFood];
   NSLog(@"slider ONE: %f ", [_foodSliderOne value]);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];

}

- (IBAction)sliderOneValueChanged:(id)sender {
    
     NSLog(@"slider ONE changed::: %.f ", [_foodSliderOne value]);
     bottledFood = _foodSliderOne.value ;
      _foodLabel.text = [NSString stringWithFormat:@"%.f",bottledFood];
}
@end
