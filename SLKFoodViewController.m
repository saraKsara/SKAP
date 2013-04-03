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
#import "SLKDates.h"
#import "SLKDateUtil.h"

@interface SLKFoodViewController ()

@end

@implementation SLKFoodViewController
{
    float bottledFood;
    SLKBabyListTableViewController *settingsVC;
    float checkDirection;
    NSString *time;
    NSDate *date;
    Baby *currentBabe;
    UISegmentedControl *_segmentControll;
    int numberOfBabies;
    NSArray *babyArray;
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
    babyArray = [[SLKBabyStorage sharedStorage] babyArray];
    NSLog(@"babyArray %d",babyArray.count);
    NSMutableArray *sementArray = [[NSMutableArray alloc] initWithObjects:@"menyyy", nil];
    
    numberOfBabies = babyArray.count;
    
    int i = 1;
    for (Baby *babe in babyArray)
    {
        [sementArray addObject:babe.name];
       // [_segmentControll setTitle:babe.name forSegmentAtIndex:i];
        i++;
    }
    
    _segmentControll = [[UISegmentedControl alloc] initWithItems:sementArray];
    _segmentControll.frame = CGRectMake(0, 0, 320, 50);
    _segmentControll.segmentedControlStyle = UISegmentedControlStylePlain;
    _segmentControll.selectedSegmentIndex = 1;
    [self.view addSubview:_segmentControll];

    [_segmentControll addTarget:self action:@selector(segmentAction:) forControlEvents: UIControlEventValueChanged];

    
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * 1.5);
    _foodSliderOne.transform = trans;
    currentBabe = [[SLKBabyStorage sharedStorage] getCurrentBaby];
    _anotherFoodLable.text = [NSString stringWithFormat: @"Log how much milk substitute %@ ate", currentBabe.name];
    [_anotherFoodLable sizeToFit];
    bottledFood = _foodSliderOne.value;
    _foodLabel.text = [NSString stringWithFormat:@"%.f",bottledFood];
   NSLog(@"slider ONE: %f ", [_foodSliderOne value]);

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    checkDirection = 30;
    date = [NSDate date];
    time = [SLKDateUtil formatTimeFromDate:date];
    _setTimeLabel.text = time;
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
//    Tits *tit = [[SLKTittStorage sharedStorage]createTittWithStringValue:nil mililitres:[NSNumber numberWithFloat:bottledFood] minutes:nil leftBoob:YES rightBoob:NO];
    
     //if tit milk was messured in minutes
    Tits *titMin = [[SLKTittStorage sharedStorage]createTittWithStringValue:nil mililitres:nil minutes:[NSNumber numberWithInt:22]leftBoob:NO rightBoob:YES];
    
    [[SLKEventStorage sharedStorage] createEventwithTit:titMin date:[NSDate date] eventId:nil baby:[[SLKBabyStorage sharedStorage] getCurrentBaby]];
    
    
  Bottle *bottle = [[SLKBottleStorage sharedStorage] createBottleWithStringValue:nil mililitres:[NSNumber numberWithFloat:bottledFood] minutes:nil];
    
    [[SLKEventStorage sharedStorage] createEvenWithdBottle:bottle date:[NSDate date] eventId:nil baby:[[SLKBabyStorage sharedStorage] getCurrentBaby]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCalendar" object:nil];

}
- (IBAction)segmentAction:(id)sender {
    if ( _segmentControll.selectedSegmentIndex == 0 ) {
        [self performSegueWithIdentifier:@"menueSeg" sender:self];
    } else {
        for (int i = 0; i < numberOfBabies; i++) {
             if ( _segmentControll.selectedSegmentIndex == i+1 ) {
                 NSLog(@"change seg %d to %@",_segmentControll.selectedSegmentIndex+1, [[babyArray objectAtIndex:i] name]);

             }
        }
    }
}


- (IBAction)setTime:(id)sender {
    if (checkDirection > [_timeSlider value])
    {
        float diff =  checkDirection  - [_timeSlider value];
        
        float timeDiff = ceil(diff/(60));
        int setMin = (NSInteger)(timeDiff);
        date = [date dateBySubtractingMinutes:setMin];
        time = [SLKDateUtil formatTimeFromDate:date];
        _setTimeLabel.text = time;
        checkDirection = [_timeSlider value];
        NSLog(@"if-------%f",checkDirection);
    }
    else
    {
        float diff =  [_timeSlider value]  - checkDirection;
        
        float timeDiff = ceil(diff/(60));
        int setMin = (NSInteger)(timeDiff);
        date = [date dateByAddingMinutes:setMin];
        time = [SLKDateUtil formatTimeFromDate:date];
        _setTimeLabel.text = time;
        checkDirection = [_timeSlider value];
        
    }
}

- (IBAction)sooner:(id)sender {
    date = [date dateBySubtractingHours:1];
    time = [SLKDateUtil formatTimeFromDate:date];
    _setTimeLabel.text = time;
}

- (IBAction)later:(id)sender {
    date = [date dateByAddingHours:1];
    time = [SLKDateUtil formatTimeFromDate:date];
    _setTimeLabel.text = time;
}
@end
