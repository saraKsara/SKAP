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
#import "Sleep.h"
#import "SLKBottleStorage.h"
#import "SLKDates.h"
#import "SLKDateUtil.h"
#import "SLKConstants.h"
#import "SLKColors.h"
#import "SLKSettingsViewController.h"
#import "SLKSleepStorage.h"
#import "SLKDaySummaryViewController.h"
@interface SLKFoodViewController ()

@end

@implementation SLKFoodViewController
{
    BOOL *titsView;
    BOOL *bottleView;
    BOOL *sleepView;
    BOOL *diaperView;
    BOOL *medzView;
    
    BOOL *leftBoob;
    BOOL *rightBoob;
    
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
    NSNull *nullValue;
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    leftBoob = NO;
    rightBoob = NO;
    currentBabe = [[SLKBabyStorage sharedStorage] getCurrentBaby];
    nullValue = [NSNull null];
    // Set up the content size of the scroll view
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageViews.count, pagesScrollViewSize.height);
   
    // Load the initial set of pages that are on screen
   
    //TODO: move to set up class???
     [_segmentControll setSelected:NO];
     
    _scrollView.delegate = self;
     [_scrollView setScrollEnabled:YES];
    self.view.backgroundColor = [UIColor clearColor];
    
    
    // [_leftTit setImage:[UIImage imageNamed:@"tits.png"]];
    
    
    checkDirection = 30;
    date = [NSDate date];
    time = [SLKDateUtil formatTimeFromDate:date];
    _setTimeLabel.text = time;
     [self loadVisiblePages];
    
    [_sliderTwo setHidden:YES];
    [_sliderTwoLabel setHidden:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     _universalSliderText.text = [NSString stringWithFormat:@"log how much %@ ate ", currentBabe.name];
    
    [_prevArrow setUserInteractionEnabled:YES];
    UITapGestureRecognizer *prevArrowTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(prewArrow:)];
    [_prevArrow addGestureRecognizer:prevArrowTapped];
    
    [_nextArrow setUserInteractionEnabled:YES];
    UITapGestureRecognizer *nexttArrowTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextArrow:)];
    [_nextArrow addGestureRecognizer:nexttArrowTapped];
    
    
    UITapGestureRecognizer *rightTitTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTit:)];
    
    [_rightTit addGestureRecognizer:rightTitTapped];
    
    UITapGestureRecognizer *leftTitTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftTit:)];
    
    [_leftTit addGestureRecognizer:leftTitTapped];
    
    self.pageViews = [NSMutableArray arrayWithObjects:_bottleView, _breastView, _sleepView,_diaperView,_medzView, nil];
    
    NSInteger pageCount = self.pageViews.count;
    NSLog(@"number of views:%i",pageCount);
    
    self.pageControll.currentPage = 0;
    self.pageControll.numberOfPages = pageCount;
    
//    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * 1.5);
//    _foodSliderOne.transform = trans;
//    currentBabe = [[SLKBabyStorage sharedStorage] getCurrentBaby];
////    _anotherFoodLable.text = [NSString stringWithFormat: @"%@´s bottled meal", currentBabe.name];
////    [_anotherFoodLable sizeToFit];
//    bottledFood = _foodSliderOne.value;
//    //_foodLabel.text = [NSString stringWithFormat:@"%.f",bottledFood];
//    NSLog(@"slider ONE: %f ", [_foodSliderOne value]);
}
- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControll.currentPage = page;
    
    // Work out which pages we want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    for (NSInteger i=lastPage+1; i<self.pageViews.count; i++) {
        [self purgePage:i];
    }
}
- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageViews.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Load an individual page, first seeing if we've already loaded it
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if (pageView == nil) {
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        UIView *newPageView = [[UIView alloc] init];
        newPageView =[self.pageViews objectAtIndex:page];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        [self.scrollView addSubview:newPageView];
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
    
    if ( self.pageControll.currentPage == 0)     
    {
        titsView = YES;
        bottleView = NO;
        sleepView = NO;
        diaperView = NO;
        medzView = NO;
        
        _UniversalLabel.text = @"Breast feed";
        _sliderOne.maximumValue = 350;
        [_sliderTwo setHidden:YES];
        [_sliderTwoLabel setHidden:YES];
        _universalSliderText.text = [NSString stringWithFormat:@"log how much %@ ate", currentBabe.name];

    }
    else if (self.pageControll.currentPage == 1)
    {
        titsView = NO;
        bottleView = YES;
        sleepView = NO;
        diaperView = NO;
        medzView = NO;
        
        _UniversalLabel.text = @"Bottled feed";
        [_sliderTwo setHidden:YES];
        [_sliderTwoLabel setHidden:YES];
        _sliderOne.maximumValue = 350;
        _universalSliderText.text = [NSString stringWithFormat:@"log how much %@ ate ", currentBabe.name];

   
    }
    else if (self.pageControll.currentPage == 2)
    {
        titsView = NO;
        bottleView = NO;
        sleepView = YES;
        diaperView = NO;
        medzView = NO;
        
         _UniversalLabel.text = @"sleep time";
        [_sliderTwo setHidden:NO];
        _sliderTwoLabel.hidden = NO;
        _sliderOne.maximumValue = 240;
        _universalSliderText.text = [NSString stringWithFormat:@"log how long %@ slept ", currentBabe.name];
     
  
    }else if (self.pageControll.currentPage == 3)
    {
        titsView = NO;
        bottleView = NO;
        sleepView = NO;
        diaperView = YES;
        medzView = NO;
        
        _UniversalLabel.text = @"diaper log";
        [_sliderTwo setHidden:YES];
        _sliderTwoLabel.hidden = YES;
        _sliderOne.maximumValue = 240;
        _universalSliderText.text = [NSString stringWithFormat:@"log how much %@ pooped ", currentBabe.name];
        
    }else if (self.pageControll.currentPage == 4)
    {
        titsView = NO;
        bottleView = NO;
        sleepView = NO;
        diaperView = NO;
        medzView = YES;
        
        _UniversalLabel.text = @"medecine log";
        [_sliderTwo setHidden:YES];
        _sliderTwoLabel.hidden = YES;
        _sliderOne.maximumValue = 240;
        _universalSliderText.text = [NSString stringWithFormat:@"log how much drugs %@ did ", currentBabe.name];
        
    }

    NSLog(@"tits: %d \n bottle: %d \n sleep %d", (int)titsView, (int)bottleView, (int)sleepView);

//    else if (self.pageControll.currentPage == 3) [self setCurrentViewWithBool:titsView];
}

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.pageViews.count) {
       
        return;
    }
    
    // Remove a page from the scroll view and reset the pagearray
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if (pageView == nil) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:nullValue];
    }
}


- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];

}


- (IBAction)save:(id)sender {
    
    if (titsView) {
        Tits *tit = [[SLKTittStorage sharedStorage]createTittWithStringValue:_sliderOneLabel.text mililitres:[NSNumber numberWithFloat:bottledFood] minutes:nil leftBoob:YES rightBoob:NO];
        
        //if tit milk was messured in minutes
      
        
        [[SLKEventStorage sharedStorage] createEvenWithHappening:tit date:date eventId:nil baby:[[SLKBabyStorage sharedStorage] getCurrentBaby]];
    }else if (bottleView)
    {
  Bottle *bottle = [[SLKBottleStorage sharedStorage] createBottleWithStringValue:nil mililitres:[NSNumber numberWithFloat:bottledFood] minutes:nil];

    [[SLKEventStorage sharedStorage]createEvenWithHappening:bottle date:date eventId:nil baby:[[SLKBabyStorage sharedStorage] getCurrentBaby]];
    }else if (sleepView)
    {
        NSNumber *labelNumber = [NSNumber numberWithInt:[_sliderOneLabel.text intValue]];
        Sleep *sleep = [[SLKSleepStorage sharedStorage]createSleep:labelNumber];
        [[SLKEventStorage sharedStorage]createEvenWithHappening:sleep date:date eventId:nil baby:[[SLKBabyStorage sharedStorage] getCurrentBaby]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCalendar" object:nil];

}


//TODO: move to setTime class
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

-(void)calculateHoursAndMinutesOnSlider:(UISlider*)slider label:(UILabel*)label
{
   
    if (checkDirection > [slider value])
    {
        float diff =  checkDirection  - [slider value];
        
        
        float timeDiff = ceil(diff/(60));
        int setMin = (NSInteger)(timeDiff);
        date = [date dateBySubtractingMinutes:setMin];
        time = [SLKDateUtil formatTimeFromDate:date];
        label.text = time;
        checkDirection = [slider value];
    }
    else
    {
        float diff =  [slider value]  - checkDirection;
        
        float timeDiff = ceil(diff/(60));
        int setMin = (NSInteger)(timeDiff);
        date = [date dateByAddingMinutes:setMin];
        time = [SLKDateUtil formatTimeFromDate:date];
        label.text = time;
        checkDirection = [slider value];
        
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


- (void)viewDidUnload {

    [self setSleepView:nil];
    [self setUniversalLabel:nil];
    [self setSliderOneLabel:nil];
    [self setSliderOne:nil];
    [self setSliderTwoLabel:nil];
    [self setSliderTwo:nil];
    [self setOverview:nil];
    [self setUniversalSliderText:nil];
    [self setDiaperView:nil];
    [self setMedzView:nil];
    [self setPrevArrow:nil];
    [self setNextArrow:nil];
    [super viewDidUnload];
    
    self.scrollView = nil;
    self.pageControll = nil;
    self.pageViews = nil;
    
}

- (IBAction)valuePageControll:(id)sender;
{
    [self loadVisiblePages];
    NSLog(@"valuepagecontroll:");
}

- (IBAction)touchUpInsidePageControll:(id)sender
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self loadVisiblePages];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        [gestureRecognizer addTarget:self action:@selector(leftTit:)];
        NSLog(@"LeftTit PRESSED");

        
    }
    NSLog(@"LeftTit PRESSED");

    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
     return YES;
}

- (IBAction)leftTit:(UITapGestureRecognizer *)sender
{
    leftBoob = !leftBoob;
    if (leftBoob)   [_leftTit setImage:[UIImage imageNamed:@"titsPink.png"]];
    else [_leftTit setImage:[UIImage imageNamed:@"tits.png"]];
}


- (IBAction)nextArrow:(UITapGestureRecognizer *)sender
{
    NSLog(@"nextArrow");
}

- (IBAction)prewArrow:(UITapGestureRecognizer *)sender
{
    NSLog(@"prewArrow");
}

- (IBAction)rightTit:(UITapGestureRecognizer *)sender
{
    rightBoob = !rightBoob;
    if (rightBoob)   [_rightTit setImage:[UIImage imageNamed:@"titsPink.png"]];
    else [_rightTit setImage:[UIImage imageNamed:@"tits.png"]];
}

- (IBAction)showOverview:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"calendar" bundle:nil];
    SLKDaySummaryViewController *controller = [sb instantiateInitialViewController];
    controller.food = YES;
    [self presentModalViewController:controller animated:YES];
}
- (IBAction)sliderOneAction:(id)sender {
    if (titsView)
    {
        _sliderOneLabel.text = @"Titty";
        if (_sliderOne.value < 58)
        {
            _sliderOneLabel.text = @" extra small meal";
            NSLog(@"slidervalue: %f", _sliderOne.value);
        } else  if (_sliderOne.value > 58 && _sliderOne.value < 116)
        {
            _sliderOneLabel.text = @" small meal";
              NSLog(@"slidervalue: %f", _sliderOne.value);
        } else  if (_sliderOne.value > 116  && _sliderOne.value < 174)
        {
        _sliderOneLabel.text = @" small medium meal";
              NSLog(@"slidervalue: %f", _sliderOne.value);
        }else  if (_sliderOne.value > 174 && _sliderOne.value < 232)
        {
            _sliderOneLabel.text = @" medium meal";
            NSLog(@"slidervalue: %f", _sliderOne.value);
        }else  if (_sliderOne.value > 232 && _sliderOne.value < 290)
        {
            _sliderOneLabel.text = @" big medium meal";
            NSLog(@"slidervalue: %f", _sliderOne.value);
        }else  if (_sliderOne.value > 290)
        {
            _sliderOneLabel.text = @" large meal";
            NSLog(@"slidervalue: %f", _sliderOne.value);
        }
    } else if (bottleView)
    {
    _sliderOneLabel.text = [NSString stringWithFormat:@" %.f ml",_sliderOne.value];
    }
    else if (sleepView)
    {
        NSNumber *theDouble = [NSNumber numberWithDouble:_sliderOne.value];
        int inputSeconds = [theDouble intValue];
        int hours =  inputSeconds / 3600;
        int anHour = ( inputSeconds - hours * 3600 ) / 60;
        int aMinute = inputSeconds - hours * 3600 - anHour * 60;
        
        NSString *theTime = [NSString stringWithFormat:@"%.1dhr %.2dmin", anHour, aMinute];
        _sliderOneLabel.text = theTime;
        
    }
}
- (IBAction)sliderTwoAction:(id)sender {
}
@end
