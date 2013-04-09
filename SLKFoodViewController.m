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
#import "SLKSettingsViewController.h"
#import "SLKDaySummaryViewController.h"
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
    
    
     [_leftTit setImage:[UIImage imageNamed:@"tits.png"]];
    checkDirection = 30;
    date = [NSDate date];
    time = [SLKDateUtil formatTimeFromDate:date];
    _setTimeLabel.text = time;
     [self loadVisiblePages];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pageViews = [NSMutableArray arrayWithObjects:_bottleView, _breastView, nil];
    NSInteger pageCount = self.pageViews.count;
    
    self.pageControll.currentPage = 0;
    self.pageControll.numberOfPages = pageCount;
    
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * 1.5);
    _foodSliderOne.transform = trans;
    currentBabe = [[SLKBabyStorage sharedStorage] getCurrentBaby];
    _anotherFoodLable.text = [NSString stringWithFormat: @"%@´s bottled meal", currentBabe.name];
    [_anotherFoodLable sizeToFit];
    bottledFood = _foodSliderOne.value;
    _foodLabel.text = [NSString stringWithFormat:@"%.f",bottledFood];
    NSLog(@"slider ONE: %f ", [_foodSliderOne value]);
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
    
    [[SLKEventStorage sharedStorage] createEvenWithHappening:titMin date:date eventId:nil baby:[[SLKBabyStorage sharedStorage] getCurrentBaby]];
    
  Bottle *bottle = [[SLKBottleStorage sharedStorage] createBottleWithStringValue:nil mililitres:[NSNumber numberWithFloat:bottledFood] minutes:nil];

    [[SLKEventStorage sharedStorage]createEvenWithHappening:bottle date:date eventId:nil baby:[[SLKBabyStorage sharedStorage] getCurrentBaby]];
    
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

    [super viewDidUnload];
    
    self.scrollView = nil;
    self.pageControll = nil;
    self.pageViews = nil;
    
}

- (IBAction)valuePageControll:(id)sender;
{
    [self loadVisiblePages];

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
    [_rightTit setImage:[UIImage imageNamed:@"titsPink.png"]];
}

- (IBAction)rightTit:(id)sender
{
    [_leftTit setImage:[UIImage imageNamed:@"titsPink.png"]];
}

- (IBAction)showTotalOverview:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"calendar" bundle:nil];
    
    SLKDaySummaryViewController *controller = [sb instantiateInitialViewController];
    controller.allEvents = YES;
    [self presentModalViewController:controller animated:YES];
}

- (IBAction)showFeedOverview:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"calendar" bundle:nil];
    SLKDaySummaryViewController *controller = [sb instantiateInitialViewController];
    controller.food = YES;
    [self presentModalViewController:controller animated:YES];
}
@end
