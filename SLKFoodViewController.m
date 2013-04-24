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
#import "Poo.h"
#import "Pii.h"
#import "SLKPooStorage.h"
#import "SLKPiiStorage.h"
#import "SLKBottleStorage.h"
#import "SLKDates.h"
#import "SLKDateUtil.h"
#import "SLKConstants.h"
#import "SLKColors.h"
#import "SLKSettingsViewController.h"
#import "SLKSleepStorage.h"
#import "SLKDaySummaryViewController.h"
#import "SLKUserDefaults.h"
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
    
    //DIAPER
    BOOL piiToAddNormal;
    BOOL piiToAddTooMuch;
    BOOL piiToAddTooLittle;
    BOOL pooToAddNormal;
    BOOL pooToAddTooMuch;
    BOOL pooToAddToLittle;
    UIImage *checkedImage;
    UIImage *unCheckedImage;
    
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
     currentBabe = [[SLKBabyStorage sharedStorage] getCurrentBaby];
    if (currentBabe == NULL) {
        NSLog(@"no babies, set up one");//TODO: this!
    }
    leftBoob = NO;
    rightBoob = NO;
    
   
    
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
    
    
    if (titsView)           [self setTheBreastView];
    else if (bottleView)    [self setTheBottleView];
    else if (sleepView)     [self setTheSleepView];
    else if (diaperView)    [self setTheDiaperView];
    else if (medzView)      [self setTheMedzView];
    
    
    checkDirection = 30;
    date = [NSDate date];
    time = [SLKDateUtil formatTimeFromDate:date];
    _setTimeLabel.text = time;
     [self loadVisiblePages];
    
    [_sliderTwo setHidden:YES];
    [_sliderTwoLabel setHidden:YES];
    
    //DIAPER
    piiToAddNormal = NO;
    piiToAddTooMuch = NO;
    piiToAddTooLittle = NO;
    pooToAddNormal = NO;
    pooToAddTooMuch = NO;
    pooToAddToLittle = NO;
    
    checkedImage = [UIImage imageNamed:@"checkedYES"];
    unCheckedImage = [UIImage imageNamed:@"checkedNO"];
    
    [_normalPoo setImage:unCheckedImage forState:UIControlStateNormal];
    [_tooMuchPoo setImage:unCheckedImage forState:UIControlStateNormal];
    [_tooLittlePoo setImage:unCheckedImage forState:UIControlStateNormal];
    
    [_normalPii setImage:unCheckedImage forState:UIControlStateNormal];
    [_tooMuchPii setImage:unCheckedImage forState:UIControlStateNormal];
    [_tooLittlePii setImage:unCheckedImage forState:UIControlStateNormal];

    
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
  //  NSLog(@"loadVisiblePages page: -----------> %d", page);
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
    
    if ( self.pageControll.currentPage == 0)        [self setTheBreastView];
    
    else if (self.pageControll.currentPage == 1)    [self setTheBottleView];
   
    else if (self.pageControll.currentPage == 2)    [self setTheSleepView];
  
    else if (self.pageControll.currentPage == 3)    [self setTheDiaperView];
        
    else if (self.pageControll.currentPage == 4)    [self setTheMedzView];
    

  //  NSLog(@"tits: %d \n bottle: %d \n sleep %d", (int)titsView, (int)bottleView, (int)sleepView);

//    else if (self.pageControll.currentPage == 3) [self setCurrentViewWithBool:titsView];
}

- (void)purgePage:(NSInteger)page
{
    if (page < 0 || page >= self.pageViews.count) return;
    
    // Remove a page from the scroll view and reset the pagearray
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if (pageView == nil) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:nullValue];
    }
}

-(void)setTheBreastView
{
    [self setSliderOneLabelBreast];

   [self hideTheDiaperSetUp];
    [_sliderOne setHidden:NO];
    [_sliderTwo setHidden:YES];
    titsView = YES;
    bottleView = NO;
    sleepView = NO;
    diaperView = NO;
    medzView = NO;
    
    _UniversalLabel.text = @"Breast feed";
    _sliderOne.maximumValue = 350;
    [_sliderTwo setHidden:YES];
    [_sliderTwoLabel setHidden:YES];
    _universalSliderText.text = [NSString stringWithFormat:@"log how much %@ breast feeded", currentBabe.name];

}
-(void)setTheBottleView
{
    [self setSliderOneLabelBottle];
    [self hideTheDiaperSetUp];
    [_sliderOne setHidden:NO];
    [_sliderTwo setHidden:YES];
    
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

-(void)setTheSleepView
{
    [self setSliderOneLabelSleep];
    [self hideTheDiaperSetUp];
    [_sliderOne setHidden:NO];
    [_sliderTwo setHidden:NO];
    
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

}
-(void)setTheDiaperView
{
    titsView = NO;
    bottleView = NO;
    sleepView = NO;
    diaperView = YES;
    medzView = NO;
    
    [_sliderOne setHidden:YES];
    [_sliderTwo setHidden:YES];
    [_sliderOneLabel setHidden:YES];
    _UniversalLabel.text = @"diaper log";
    _sliderTwoLabel.hidden = YES;
    _sliderOne.maximumValue = 240;
    _universalSliderText.text = [NSString stringWithFormat:@"log how much %@ pooped ", currentBabe.name];

    for (UILabel *label in _diaperLabels)
    {
        [label setHidden:NO];
    }
    [_tooLittlePii setHidden:NO];
    [_tooMuchPii setHidden:NO];
    [_normalPii setHidden:NO];
    [_tooMuchPoo setHidden:NO];
    [_tooLittlePoo setHidden:NO];
    [_normalPoo setHidden:NO];
}

-(void)hideTheDiaperSetUp
{
    [_sliderOneLabel setHidden:NO];
    for (UILabel *label in _diaperLabels)
    {
        [label setHidden:YES];
    }
    [_tooLittlePii setHidden:YES];
    [_tooMuchPii setHidden:YES];
    [_normalPii setHidden:YES];
    [_tooMuchPoo setHidden:YES];
    [_tooLittlePoo setHidden:YES];
    [_normalPoo setHidden:YES];
}

-(void)setTheMedzView
{
    [self setSliderOneLabelMedz];
    
    [self hideTheDiaperSetUp];
    [_sliderOne setHidden:NO];
    [_sliderTwo setHidden:YES];
    
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

- (IBAction)check:(id)sender {
    
    if (sender == _normalPoo)
    {
        pooToAddNormal = !pooToAddNormal;
        pooToAddTooMuch = NO;
        pooToAddToLittle = NO;
        if (pooToAddNormal)     [_normalPoo setImage:checkedImage forState:UIControlStateNormal];
        else                    [_normalPoo setImage:unCheckedImage forState:UIControlStateNormal];
        
        [_tooMuchPoo setImage:unCheckedImage forState:UIControlStateNormal];
        [_tooLittlePoo setImage:unCheckedImage forState:UIControlStateNormal];
        //  NSLog(@"\nnormal: %d\n TooMuch:%d\n TooLittle:%d", pooToAddNormal, pooToAddTooMuch,pooToAddToLittle);
        
    } else  if (sender == _tooMuchPoo)
    {
        pooToAddTooMuch = !pooToAddTooMuch;
        pooToAddNormal = NO;
        pooToAddToLittle = NO;
        if (pooToAddTooMuch)    [_tooMuchPoo setImage:checkedImage forState:UIControlStateNormal];
        else                    [_tooMuchPoo setImage:unCheckedImage forState:UIControlStateNormal];
        
        
        [_normalPoo setImage:unCheckedImage forState:UIControlStateNormal];
        [_tooLittlePoo setImage:unCheckedImage forState:UIControlStateNormal];
        // NSLog(@"\nnormal: %d\n TooMuch:%d\n TooLittle:%d", pooToAddNormal, pooToAddTooMuch,pooToAddToLittle);
        
    } else  if (sender == _tooLittlePoo)
    {
        pooToAddToLittle =!pooToAddToLittle;
        pooToAddNormal = NO;
        pooToAddTooMuch = NO;
        if (pooToAddToLittle)   [_tooLittlePoo setImage:checkedImage forState:UIControlStateNormal];
        else                    [_tooLittlePoo setImage:unCheckedImage forState:UIControlStateNormal];
        
        
        [_normalPoo setImage:unCheckedImage forState:UIControlStateNormal];
        [_tooMuchPoo setImage:unCheckedImage forState:UIControlStateNormal];
        // NSLog(@"\nnormal: %d\n TooMuch:%d\n TooLittle:%d", pooToAddNormal, pooToAddTooMuch,pooToAddToLittle);
    }
    
    
    else if (sender == _normalPii)
    {
        piiToAddNormal = !piiToAddNormal;
        piiToAddTooMuch = NO;
        piiToAddTooLittle = NO;
        if (piiToAddNormal)     [_normalPii setImage:checkedImage forState:UIControlStateNormal];
        else                    [_normalPii setImage:unCheckedImage forState:UIControlStateNormal];
        
        [_tooLittlePii setImage:unCheckedImage forState:UIControlStateNormal];
        [_tooMuchPii setImage:unCheckedImage forState:UIControlStateNormal];
        // NSLog(@"\nnormal: %d\n TooMuch:%d\n TooLittle:%d", piiToAddNormal, piiToAddTooMuch,piiToAddTooLittle);
        
    } else  if (sender == _tooMuchPii)
    {
        piiToAddTooMuch = !piiToAddTooMuch;
        piiToAddNormal = NO;
        piiToAddTooLittle = NO;
        if (piiToAddTooMuch)    [_tooMuchPii setImage:checkedImage forState:UIControlStateNormal];
        else                    [_tooMuchPii setImage:unCheckedImage forState:UIControlStateNormal];
        
        
        [_normalPii setImage:unCheckedImage forState:UIControlStateNormal];
        [_tooLittlePii setImage:unCheckedImage forState:UIControlStateNormal];
        //  NSLog(@"\nnormal: %d\n TooMuch:%d\n TooLittle:%d", piiToAddNormal, piiToAddTooMuch,piiToAddTooLittle);
        
    } else  if (sender == _tooLittlePii)
    {
        piiToAddTooLittle =!piiToAddTooLittle;
        piiToAddNormal = NO;
        piiToAddTooMuch = NO;
        if (piiToAddTooLittle)   [_tooLittlePii setImage:checkedImage forState:UIControlStateNormal];
        else                    [_tooLittlePii setImage:unCheckedImage forState:UIControlStateNormal];
        
        
        [_normalPii setImage:unCheckedImage forState:UIControlStateNormal];
        [_tooMuchPii setImage:unCheckedImage forState:UIControlStateNormal];
        // NSLog(@"\nnormal: %d\n TooMuch:%d\n TooLittle:%d", piiToAddNormal, piiToAddTooMuch,piiToAddTooLittle);
    }
}

//TODO: remove?
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];

}


- (IBAction)save:(id)sender {
    
    if (titsView)
    {
        if (!leftBoob && !rightBoob) {
            UIAlertView *noChoiceAlert = [[UIAlertView alloc] initWithTitle:@"No breast choosen"
                                                                    message:@"You have to choose right, left or both breasts"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
            [noChoiceAlert show];
            
        } else {
            Tits *tit = [[SLKTittStorage sharedStorage]createTittWithStringValue:_sliderOneLabel.text mililitres:nil minutes:nil leftBoob:leftBoob rightBoob:rightBoob];
            NSLog(@"lefty: %d \n righty: %d \n", (int)leftBoob, (int)rightBoob);
            [[SLKEventStorage sharedStorage] createEvenWithHappening:tit date:date eventId:nil baby:[[SLKBabyStorage sharedStorage] getCurrentBaby]];
            leftBoob = NO;
            [_leftTit setImage:[UIImage imageNamed:@"tits.png"]];
            rightBoob = NO;
            [_rightTit setImage:[UIImage imageNamed:@"tits.png"]];
            
        }
    }
    else if (bottleView)
    {
        if (bottledFood == 0 ) {
            UIAlertView *noChoiceAlert = [[UIAlertView alloc] initWithTitle:@"No milk choosen"
                                                                    message:@"You have to set how much your baby ate. Use the slider to set how much your baby ate"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
            [noChoiceAlert show];
        }else {
            Bottle *bottle = [[SLKBottleStorage sharedStorage] createBottleWithStringValue:nil mililitres:[NSNumber numberWithFloat:bottledFood] minutes:nil];
            
            [[SLKEventStorage sharedStorage]createEvenWithHappening:bottle date:date eventId:nil baby:[[SLKBabyStorage sharedStorage] getCurrentBaby]];
            bottledFood = 0;
            [_sliderOne setValue:0];
               _sliderOneLabel.text = [NSString stringWithFormat:@" %.f ml",_sliderOne.value];
        }
    }
    else if (sleepView)
    {
        NSNumber *labelNumber = [NSNumber numberWithInt:[_sliderOneLabel.text intValue]];
        Sleep *sleep = [[SLKSleepStorage sharedStorage]createSleep:labelNumber];
        [[SLKEventStorage sharedStorage]createEvenWithHappening:sleep date:date eventId:nil baby:[[SLKBabyStorage sharedStorage] getCurrentBaby]];
    }
    else if (diaperView)
    {
        if (!pooToAddNormal && !pooToAddTooMuch && !pooToAddToLittle && !piiToAddNormal && !piiToAddTooMuch && !piiToAddTooLittle)
        {
            NSString *alertMessage = [NSString stringWithFormat:@"Please enter how much %@ did pii or poo", currentBabe.name];
            UIAlertView *alertNoPiisOrPoos = [[UIAlertView alloc] initWithTitle:@"NOTHING TO LOG" message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertNoPiisOrPoos show];
        } else {
            
            if (pooToAddNormal || pooToAddTooMuch || pooToAddToLittle) {
                NSLog(@"create new POO");
                Poo *someNewPoo = [[SLKPooStorage sharedStorage] createNormalPoo:pooToAddNormal tooMuch:pooToAddTooMuch tooLittle:pooToAddToLittle];
                [[SLKEventStorage sharedStorage] createEvenWithHappening:someNewPoo date:date eventId:nil baby:currentBabe];
            } else {
                NSLog(@"NO New POO");
            }
            if (piiToAddNormal || piiToAddTooMuch || piiToAddTooLittle) {
                NSLog(@"Create new PII");
                Pii *someNewPii = [[SLKPiiStorage sharedStorage] createNormalPii:piiToAddNormal tooMuch:piiToAddTooMuch tooLittle:piiToAddTooLittle];
                [[SLKEventStorage sharedStorage] createEvenWithHappening:someNewPii date:date eventId:nil baby:currentBabe];
                
            } else {
                NSLog(@"NO new Pii");
            }
        }

    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCalendar" object:nil];
    
}

#pragma mark set time
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
    [self setDiaperLabels:nil];
    [super viewDidUnload];
    
    self.scrollView = nil;
    self.pageControll = nil;
    self.pageViews = nil;
    
}

- (IBAction)valuePageControll:(id)sender;
{
    [self loadVisiblePages];
    NSLog(@"valuepagecontroll:--------");
}

- (IBAction)touchUpInsidePageControll:(id)sender
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self loadVisiblePages];
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
- (IBAction)rightTit:(UITapGestureRecognizer *)sender
{
    rightBoob = !rightBoob;
    if (rightBoob)   [_rightTit setImage:[UIImage imageNamed:@"titsPink.png"]];
    else [_rightTit setImage:[UIImage imageNamed:@"tits.png"]];
}

- (IBAction)nextArrow:(UITapGestureRecognizer *)sender
{
    if (titsView)   {
     [_scrollView scrollRectToVisible:CGRectMake(200, 0, 200, 170) animated:YES];
        titsView = NO;
        bottleView = YES;
        sleepView = NO;
        diaperView = NO;
        medzView = NO;
    }
   else if (bottleView)    {
        [_scrollView scrollRectToVisible:CGRectMake(400, 0, 200, 170) animated:YES];
        titsView = NO;
        bottleView = NO;
        sleepView = YES;
        diaperView = NO;
        medzView = NO;
    }
   else if (sleepView)   {
        [_scrollView scrollRectToVisible:CGRectMake(600, 0, 200, 170) animated:YES];
        titsView = NO;
        bottleView = NO;
        sleepView = NO;
        diaperView = YES;
        medzView = NO;
    }
   else if (diaperView)  {
        [_scrollView scrollRectToVisible:CGRectMake(800, 0, 200, 170) animated:YES];
        titsView = NO;
        bottleView = NO;
        sleepView = NO;
        diaperView = NO;
        medzView = YES;
    }
}

- (IBAction)prewArrow:(UITapGestureRecognizer *)sender
{
    if (titsView)   {
    }
    else if (bottleView)    {
        [_scrollView scrollRectToVisible:CGRectMake(0, 0, 200, 170) animated:YES];
        titsView = YES;
        bottleView = NO;
        sleepView = NO;
        diaperView = NO;
        medzView = NO;
    }
    else if (sleepView)   {
        [_scrollView scrollRectToVisible:CGRectMake(200, 0, 200, 170) animated:YES];
        titsView = NO;
        bottleView = YES;
        sleepView = NO;
        diaperView = NO;
        medzView = NO;
    }
    else if (diaperView)  {
        [_scrollView scrollRectToVisible:CGRectMake(400, 0, 200, 170) animated:YES];
        titsView = NO;
        bottleView = NO;
        sleepView = YES;
        diaperView = NO;
        medzView = NO;
    }
    else  {
        [_scrollView scrollRectToVisible:CGRectMake(600, 0, 200, 170) animated:YES];
        titsView = NO;
        bottleView = NO;
        sleepView = YES;
        diaperView = YES;
        medzView = NO;
    }
}



- (IBAction)showOverview:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"calendar" bundle:nil];
    SLKDaySummaryViewController *controller = [sb instantiateInitialViewController];
    controller.food = YES;
    [self presentModalViewController:controller animated:YES];
}

-(void)setSliderOneLabelBreast
{
    _sliderOneLabel.text = @"Titty";
    if (_sliderOne.value < 58)
    {
        _sliderOneLabel.text = @" extra small meal";
    } else  if (_sliderOne.value > 58 && _sliderOne.value < 116)
    {
        _sliderOneLabel.text = @" small meal";
    } else  if (_sliderOne.value > 116  && _sliderOne.value < 174)
    {
        _sliderOneLabel.text = @" small medium meal";
    }else  if (_sliderOne.value > 174 && _sliderOne.value < 232)
    {
        _sliderOneLabel.text = @" medium meal";
    }else  if (_sliderOne.value > 232 && _sliderOne.value < 290)
    {
        _sliderOneLabel.text = @" big medium meal";
    }else  if (_sliderOne.value > 290)
    {
        _sliderOneLabel.text = @" large meal";
    }
}
-(void)setSliderOneLabelBottle
{
    _sliderOneLabel.text = [NSString stringWithFormat:@" %.f ml",_sliderOne.value];
    bottledFood = _sliderOne.value;
}
-(void)setSliderOneLabelSleep
{
    NSNumber *theDouble = [NSNumber numberWithDouble:_sliderOne.value];
    int inputSeconds = [theDouble intValue];
    int hours =  inputSeconds / 3600;
    int anHour = ( inputSeconds - hours * 3600 ) / 60;
    int aMinute = inputSeconds - hours * 3600 - anHour * 60;
    
    NSString *theTime = [NSString stringWithFormat:@"%.1dhr %.2dmin", anHour, aMinute];
    _sliderOneLabel.text = theTime;

}
-(void)setSliderOneLabelMedz
{
    
}
- (IBAction)sliderOneAction:(id)sender
{
    if (titsView)           [self setSliderOneLabelBreast];
    else if (bottleView)    [self setSliderOneLabelBottle];
    else if (sleepView)     [self setSliderOneLabelSleep];
    else if (medzView)     [self setSliderOneLabelMedz];
}
- (IBAction)sliderTwoAction:(id)sender {
}
@end
