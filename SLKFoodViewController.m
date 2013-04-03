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
#import "SLKConstants.h"
#import "SLKColors.h"

@interface SLKFoodViewController ()

@end

@implementation SLKFoodViewController
{
    UIColor *bgColor;
    float bottledFood;
    SLKBabyListTableViewController *settingsVC;
    float checkDirection;
    NSString *time;
    NSDate *date;
    Baby *currentBabe;
    UISegmentedControl *_segmentControll;
    int numberOfBabies;
    NSArray *babyArray;
    float segmentWidth;
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
    NSMutableArray *segmentArray = [[NSMutableArray alloc] initWithObjects:@"menu", nil];
    
    numberOfBabies = babyArray.count;
    
    //IF adding new baby, set up new segmentcontrol! else, ....
    int i = 1;
    for (Baby *babe in babyArray)
    {
        [segmentArray addObject:babe.name];
       // [_segmentControll setTitle:babe.name forSegmentAtIndex:i];
        i++;
    }
        //TODO: move to set up class???
    _segmentControll = [[UISegmentedControl alloc] initWithItems:segmentArray];
    _segmentControll.frame = CGRectMake(0, 0, 320, 50);
    _segmentControll.segmentedControlStyle = UISegmentedControlStylePlain;
    _segmentControll.selectedSegmentIndex = 1;//TODO: == current babe
    segmentWidth = 320 / 3;
    NSLog(@"seggyyy--------%f", segmentWidth);
 
   for (int i = 0; i <= numberOfBabies; i++) {
    {
        if (i == 0) {
            UIImage *image = [self drawImageWithColor:[UIColor colorWithHexValue:kBlueish_Color]];
            [_segmentControll setImage:image forSegmentAtIndex:i];
        } else {
            NSString *color = [[babyArray objectAtIndex:i-1] babysColor];
            UIImage *image = [self drawImageWithColor:[UIColor colorWithHexValue:color]];

             UIImage *imageText =[self drawText:[[babyArray objectAtIndex:i-1] name] inImage:image atPoint:CGPointMake(20, 10)];
           
            [_segmentControll setImage:imageText forSegmentAtIndex:i];
        }
  
    }
   
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
    
}

-(UIImage*)drawImageWithColor:(UIColor*)color
{
    //as big as 320/(numberofbabies+1)
    UIGraphicsBeginImageContext(CGSizeMake(segmentWidth, 50));
    [color setFill];
    UIRectFill(CGRectMake(0, 0, segmentWidth, 50));

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
-(UIImage*) drawText:(NSString*) text inImage:(UIImage*) image atPoint:(CGPoint) point
{
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [[UIColor blackColor] set];
    [text drawInRect:CGRectIntegral(rect) withFont:font];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //TODO: move to set up class???

    bgColor = [UIColor colorWithHexValue:kBlueish_Color];
    [[self view] setBackgroundColor:bgColor];

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
    
    [[SLKEventStorage sharedStorage] createEventwithTit:titMin date:date eventId:nil baby:[[SLKBabyStorage sharedStorage] getCurrentBaby]];
    
    
  Bottle *bottle = [[SLKBottleStorage sharedStorage] createBottleWithStringValue:nil mililitres:[NSNumber numberWithFloat:bottledFood] minutes:nil];
    
    [[SLKEventStorage sharedStorage] createEvenWithdBottle:bottle date:date eventId:nil baby:[[SLKBabyStorage sharedStorage] getCurrentBaby]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCalendar" object:nil];

}
- (IBAction)segmentAction:(id)sender {
    if ( _segmentControll.selectedSegmentIndex == 0 ) {
        [self performSegueWithIdentifier:@"menueSeg" sender:self];
    } else {
        for (int i = 0; i < numberOfBabies; i++) {
             if ( _segmentControll.selectedSegmentIndex == i+1 ) {
                 NSLog(@"change seg %d to %@",_segmentControll.selectedSegmentIndex, [[babyArray objectAtIndex:i] name]);
                 [[SLKBabyStorage sharedStorage] setCurrentBaby:[babyArray objectAtIndex:i]];
                 _anotherFoodLable.text = [NSString stringWithFormat: @"Log how much milk substitute %@ ate", [[babyArray objectAtIndex:i] name]];
                 NSString *color = [[babyArray objectAtIndex:i] babysColor];
                  bgColor = [UIColor colorWithHexValue:color];
                     [[self view] setBackgroundColor:bgColor];
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
