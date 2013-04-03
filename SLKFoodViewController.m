//
//  SLKFoodViewController.m
//  SKAP
//
//  Created by Student vid Yrkeshögskola C3L on 3/20/13.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKFoodViewController.h"
#import "SLKBabyListTableViewController.h"
#import "Tits.h"
#import "SLKTittStorage.h"
#import "Event.h"
#import "SLKEventStorage.h"
#import "SLKDateUtil.h"
#import "SLKBabyStorage.h"
#import "Baby.h"
#import "Bottle.h"
#import "SLKBottleStorage.h"

@interface SLKFoodViewController ()

@end

@implementation SLKFoodViewController
{
    float bottledFood;
    SLKBabyListTableViewController *settingsVC;
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"menueSeg"]) {
        SLKBabyListTableViewController *settingVc = [segue destinationViewController];
        
        UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"->"
                                                                        style:UIBarButtonItemStyleBordered
                                        target:settingVc
                                        action:@selector(back)];
        
        [[settingVc navigationItem]setRightBarButtonItem:rightBarBtn];
       // NOT WORKING: [[settingVc navigationItem]hidesBackButton];
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)showMenue {
    [self performSegueWithIdentifier:@"menueSeg" sender:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    settingsVC = [[SLKBabyListTableViewController alloc] init];
   
    
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
- (IBAction)save:(id)sender {
    
    //if tit milk was messured in mililites
//    Tits *tit = [[SLKTittStorage sharedStorage]createTittWithStringValue:nil mililitres:[NSNumber numberWithFloat:bottledFood] minutes:nil];
     //if tit milk was messured in minutes
//    Tits *titMin = [[SLKTittStorage sharedStorage]createTittWithStringValue:nil mililitres:nil minutes:[NSNumber numberWithInt:22]];
//    
//    [[SLKEventStorage sharedStorage] createEventwithTit:titMin date:[NSDate date] eventId:nil baby:[[SLKBabyStorage sharedStorage] getCurrentBaby]];
//    
//    
  Bottle *bottle = [[SLKBottleStorage sharedStorage] createBottleWithStringValue:nil mililitres:[NSNumber numberWithFloat:bottledFood] minutes:nil];
    
    [[SLKEventStorage sharedStorage] createEvenWithdBottle:bottle date:[NSDate date] eventId:nil baby:[[SLKBabyStorage sharedStorage] getCurrentBaby]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCalendar" object:nil];

}
- (IBAction)segmentAction:(id)sender {

    if ( _segmentControll.selectedSegmentIndex == 0) {
            NSLog(@"SEGMENT PUSHED, SELEcted 0 ");
         [self performSegueWithIdentifier:@"menueSeg" sender:self];
//        [self presentViewController:settingsVC animated:YES completion:^{
//            NSLog(@"visar meny");
//        }];
    } else if ( _segmentControll.selectedSegmentIndex == 1) {
        NSLog(@"SEGMENT PUSHED, SELEcted 1 ");
    } else if ( _segmentControll.selectedSegmentIndex == 2) {
        NSLog(@"SEGMENT PUSHED, SELEcted 2 ");
    }
}
@end
