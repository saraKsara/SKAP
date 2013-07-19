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
#import "SLKuser.h"
#import <Parse/Parse.h>
#import "SLKPARSEService.h"
@interface SLKFoodViewController ()

@end

@implementation SLKFoodViewController
{
    //view bools
    BOOL *titsView;
    BOOL *bottleView;
    BOOL *sleepView;
    BOOL *diaperView;
    BOOL *medzView;
    
    BOOL *leftBoob;
    BOOL *rightBoob;
    WSAdSpace *splashAdView;

//    //DIAPER
//    BOOL piiToAddNormal;
//    BOOL piiToAddTooMuch;
//    BOOL piiToAddTooLittle;
//    BOOL pooToAddNormal;
//    BOOL pooToAddTooMuch;
//    BOOL pooToAddToLittle;
//    UIImage *checkedImage;
//    UIImage *unCheckedImage;
   
    
    //SLEEP
    int sleptMinutes;
    
    //BOTTLE
    float bottledFood;
     UIImageView *milkView;
    int milkY;
    
    
    SLKBabyListTableViewController *settingsVC;
    float checkDirection;
    NSString *time;
    NSDate *date;
    Baby *currentBabe;
//    UISegmentedControl *_segmentControll;
//    int numberOfBabies;
//    NSArray *babyArray;
//    float segmentWidth;
    NSNull *nullValue;
    
    //alerts
    UIAlertView *noBoobsAlert;
    UIAlertView *noBottleAlert;
}

//
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    
//    if ([segue.identifier isEqualToString:@"menueSeg"]) {
//        SLKBabyListTableViewController *settingVc = [segue destinationViewController];
//        
//        UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"->"
//                                                                        style:UIBarButtonItemStyleBordered
//                                        target:settingVc
//                                        action:@selector(back)];
//        
//        [[settingVc navigationItem]setRightBarButtonItem:rightBarBtn];
//       // NOT WORKING: [[settingVc navigationItem]hidesBackButton];
//    }
//}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIViewController *)rootViewController {
    // You don't need to do more than this here. The widespace SDK simply needs to know about your viewController (i.e self)
    return self;
}
-(void)didFailWithError:(WSAdSpace *)adSpace type:(NSString *)type message:(NSString *)message error:(NSError *)error
{
    NSLog(@"Adspace did fail with message: %@", message);
}
-(void)didAnimateIn:(WSAdSpace *)adSpace
{
    NSLog(@"Adspace.frame ----> %@", NSStringFromCGRect(adSpace.frame));
}

-(void)didLoadAd:(WSAdSpace *)adSpace adType:(NSString *)adType
{

    NSLog(@"Adspace did load ad with type: %@", adType);
    NSLog(@"Adspace.frame ========= %@", NSStringFromCGRect(adSpace.frame));
}










-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
  //  NSLog(@"selected ONE? : %d", _switchOne.selected);
   // NSLog(@"current Pf-USER----%@", [PFUser currentUser]);
   // NSLog(@"current SLK-USER----%@", [SLKuser currentUser]);

    
    _commentTextView.delegate = self;
     currentBabe = [[SLKBabyStorage sharedStorage] getCurrentBaby];
    if (currentBabe == NULL) {
        NSLog(@"no babies, set up one");//TODO: this!
    }

  //  [self tabBarController];

    leftBoob = NO;
    rightBoob = NO;
    
    [self setUpAlerts];
    
    nullValue = [NSNull null];
    // Set up the content size of the scroll view
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageViews.count, pagesScrollViewSize.height);
   
    // Load the initial set of pages that are on screen
   
    //TODO: move to set up class???
   //  [_segmentControll setSelected:NO];
     
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
//    piiToAddNormal = NO;
//    piiToAddTooMuch = NO;
//    piiToAddTooLittle = NO;
//    pooToAddNormal = NO;
//    pooToAddTooMuch = NO;
//    pooToAddToLittle = NO;
//    
//    checkedImage = [UIImage imageNamed:@"checkedYES"];
//    unCheckedImage = [UIImage imageNamed:@"checkedNO"];
//    
//    [_normalPoo setImage:unCheckedImage forState:UIControlStateNormal];
//    [_tooMuchPoo setImage:unCheckedImage forState:UIControlStateNormal];
//    [_tooLittlePoo setImage:unCheckedImage forState:UIControlStateNormal];
//    
//    [_normalPii setImage:unCheckedImage forState:UIControlStateNormal];
//    [_tooMuchPii setImage:unCheckedImage forState:UIControlStateNormal];
//    [_tooLittlePii setImage:unCheckedImage forState:UIControlStateNormal];

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     //_universalSliderText.text = [NSString stringWithFormat:@"log how much %@ ate ", currentBabe.name];
    milkY = 124.5;
    milkView = [[UIImageView alloc] initWithFrame:CGRectMake(122, milkY, 32, 0)];
    UIImage *diap = [UIImage imageNamed:@"blueMilk.png"];
    [self.bottleView addSubview:milkView];
    [milkView setImage:diap];
   [_timeSlider setThumbImage:[UIImage imageNamed:@"phClock2"]forState:UIControlStateNormal];
    [_timeSlider setThumbImage:[UIImage imageNamed:@"phClock3"]forState:UIControlStateHighlighted];

    // Declare and Initiate the WSAdSpace object
    splashAdView = [[WSAdSpace alloc] initWithFrame:CGRectMake(0, 0,320 ,88)  sid:@"f48a4efe-0567-4bc5-b426-8e385f386a87" autoUpdate:NO autoStart:NO delegate:self];
    [splashAdView prefetchAd];
     // Add WSAdSpace as a subview of MyViewController
   // splashAdView.backgroundColor = [UIColor redColor];
   // [self.view addSubview:splashAdView];
    //[self.view bringSubviewToFront:splashAdView];
    
    //GestureRecognizers
    
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
//    NSLog(@"number of views:%i",pageCount);
    
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
-(void)didPrefetchAd:(WSAdSpace *)adSpace mediaStatus:(NSString *)mediaStatus
{
     [self.view addSubview:splashAdView];
    [self.view bringSubviewToFront:splashAdView];
    NSLog(@"size:--------%@", NSStringFromCGRect(adSpace.frame));
    [splashAdView runAd];

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
    _sliderOne.value = 0;
    _sliderTwo.value = 0;
    if ( self.pageControll.currentPage == 0)        [self setTheBreastView];
    
    else if (self.pageControll.currentPage == 1)    [self setTheBottleView];
   
    else if (self.pageControll.currentPage == 2)    [self setTheSleepView];
  
    else if (self.pageControll.currentPage == 3)    [self setTheDiaperView];
        
    else if (self.pageControll.currentPage == 4)    [self setTheMedzView];


  //  NSLog(@"tits: %d \n bottle: %d \n sleep %d", (int)titsView, (int)bottleView, (int)sleepView);

//    else if (self.pageControll.currentPage == 3) [self setCurrentViewWithBool:titsView];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   if (self.pageControll.currentPage == 3)
   {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    [animation setFromValue:[NSNumber numberWithFloat:0.0]];
    [animation setToValue:[NSNumber numberWithFloat:1.0]];
    [animation setDuration:0.9f];
    [animation setAutoreverses:NO];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionLinear]];
    //[_poo setHidden:NO];
    [_pee setHidden:NO];
    [[_pee layer] addAnimation:animation forKey:@"opacity"];
   }

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
   // _universalSliderText.text = [NSString stringWithFormat:@"log how much %@ breast feeded", currentBabe.name];

}
-(void)setTheBottleView
{
    [self setSliderOneLabelBottle];
    [self hideTheDiaperSetUp];
    [_sliderOne setHidden:NO];
    [_sliderTwo setHidden:YES];
  //  [_sliderOne setOpaque:YES];
    
    titsView = NO;
    bottleView = YES;
    sleepView = NO;
    diaperView = NO;
    medzView = NO;
    
    _UniversalLabel.text = @"Bottled feed";
    [_sliderTwo setHidden:YES];
    [_sliderTwoLabel setHidden:YES];
    _sliderOne.maximumValue = 350;
   // _universalSliderText.text = [NSString stringWithFormat:@"log how much %@ ate ", currentBabe.name];

}

-(void)setTheSleepView
{
    
    [self setSliderOneLabelSleep];
    [self hideTheDiaperSetUp];
    [_sliderOne setHidden:NO];
    [_sliderTwo setHidden:NO];
    [_sliderOne setThumbImage:[UIImage imageNamed:@"litenLort.png"]forState:UIControlStateNormal];
    [_sliderOne setThumbImage:[UIImage imageNamed:@"bajs2.png"]forState:UIControlStateHighlighted];
   
    titsView = NO;
    bottleView = NO;
    sleepView = YES;
    diaperView = NO;
    medzView = NO;
    
    _UniversalLabel.text = @"sleep time";
    _sliderTwoLabel.hidden = NO;
    _sliderOne.maximumValue = 240;
   // _universalSliderText.text = [NSString stringWithFormat:@" ", currentBabe.name];

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
   // _universalSliderText.text = [NSString stringWithFormat:@"", currentBabe.name];

    for (UILabel *label in _diaperLabels)
    {
        [label setHidden:NO];
    }
    
   
   // [_switchTwo setTintColor:[UIColor colorWithHexValue:@"FFFF66"]];
   // [_switchTwo setThumbTintColor:[UIColor whiteColor]];
    
    //[_switchTwo setOffImage:[UIImage imageNamed:@"2"]];
    //[_switchTwo setTintColor:[UIColor colorWithHexValue:@"663300"]];
    
        
            //[[_poo layer] addAnimation:animation forKey:@"opacity"];
        
            

    [_switchOne setHidden:NO];
    [_switchTwo setHidden:NO];
    [_commentTextView setHidden:NO];

//    [_tooLittlePii setHidden:NO];
//    [_tooMuchPii setHidden:NO];
//    [_normalPii setHidden:NO];
//    [_tooMuchPoo setHidden:NO];
//    [_tooLittlePoo setHidden:NO];
//    [_normalPoo setHidden:NO];
}

-(void)hideTheDiaperSetUp
{
    [_sliderOneLabel setHidden:NO];
    for (UILabel *label in _diaperLabels)
    {
        [label setHidden:YES];
    }
    
    [_switchOne setHidden:YES];
    [_switchTwo setHidden:YES];
    [_pee setHidden:YES];
    [_poo setHidden:YES];
    [_commentTextView setHidden:YES];
    _commentTextView.text = nil;
    
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
   // _universalSliderText.text = [NSString stringWithFormat:@"log how much drugs %@ did ", currentBabe.name];

}

//- (IBAction)check:(id)sender {
//    
//    if (sender == _normalPoo)
//    {
//        pooToAddNormal = !pooToAddNormal;
//        pooToAddTooMuch = NO;
//        pooToAddToLittle = NO;
//        if (pooToAddNormal)     [_normalPoo setImage:checkedImage forState:UIControlStateNormal];
//        else                    [_normalPoo setImage:unCheckedImage forState:UIControlStateNormal];
//        
//        [_tooMuchPoo setImage:unCheckedImage forState:UIControlStateNormal];
//        [_tooLittlePoo setImage:unCheckedImage forState:UIControlStateNormal];
//        //  NSLog(@"\nnormal: %d\n TooMuch:%d\n TooLittle:%d", pooToAddNormal, pooToAddTooMuch,pooToAddToLittle);
//        
//    } else  if (sender == _tooMuchPoo)
//    {
//        pooToAddTooMuch = !pooToAddTooMuch;
//        pooToAddNormal = NO;
//        pooToAddToLittle = NO;
//        if (pooToAddTooMuch)    [_tooMuchPoo setImage:checkedImage forState:UIControlStateNormal];
//        else                    [_tooMuchPoo setImage:unCheckedImage forState:UIControlStateNormal];
//        
//        
//        [_normalPoo setImage:unCheckedImage forState:UIControlStateNormal];
//        [_tooLittlePoo setImage:unCheckedImage forState:UIControlStateNormal];
//        // NSLog(@"\nnormal: %d\n TooMuch:%d\n TooLittle:%d", pooToAddNormal, pooToAddTooMuch,pooToAddToLittle);
//        
//    } else  if (sender == _tooLittlePoo)
//    {
//        pooToAddToLittle =!pooToAddToLittle;
//        pooToAddNormal = NO;
//        pooToAddTooMuch = NO;
//        if (pooToAddToLittle)   [_tooLittlePoo setImage:checkedImage forState:UIControlStateNormal];
//        else                    [_tooLittlePoo setImage:unCheckedImage forState:UIControlStateNormal];
//        
//        
//        [_normalPoo setImage:unCheckedImage forState:UIControlStateNormal];
//        [_tooMuchPoo setImage:unCheckedImage forState:UIControlStateNormal];
//        // NSLog(@"\nnormal: %d\n TooMuch:%d\n TooLittle:%d", pooToAddNormal, pooToAddTooMuch,pooToAddToLittle);
//    }
//    
//    
//    else if (sender == _normalPii)
//    {
//        piiToAddNormal = !piiToAddNormal;
//        piiToAddTooMuch = NO;
//        piiToAddTooLittle = NO;
//        if (piiToAddNormal)     [_normalPii setImage:checkedImage forState:UIControlStateNormal];
//        else                    [_normalPii setImage:unCheckedImage forState:UIControlStateNormal];
//        
//        [_tooLittlePii setImage:unCheckedImage forState:UIControlStateNormal];
//        [_tooMuchPii setImage:unCheckedImage forState:UIControlStateNormal];
//        // NSLog(@"\nnormal: %d\n TooMuch:%d\n TooLittle:%d", piiToAddNormal, piiToAddTooMuch,piiToAddTooLittle);
//        
//    } else  if (sender == _tooMuchPii)
//    {
//        piiToAddTooMuch = !piiToAddTooMuch;
//        piiToAddNormal = NO;
//        piiToAddTooLittle = NO;
//        if (piiToAddTooMuch)    [_tooMuchPii setImage:checkedImage forState:UIControlStateNormal];
//        else                    [_tooMuchPii setImage:unCheckedImage forState:UIControlStateNormal];
//        
//        
//        [_normalPii setImage:unCheckedImage forState:UIControlStateNormal];
//        [_tooLittlePii setImage:unCheckedImage forState:UIControlStateNormal];
//        //  NSLog(@"\nnormal: %d\n TooMuch:%d\n TooLittle:%d", piiToAddNormal, piiToAddTooMuch,piiToAddTooLittle);
//        
//    } else  if (sender == _tooLittlePii)
//    {
//        piiToAddTooLittle =!piiToAddTooLittle;
//        piiToAddNormal = NO;
//        piiToAddTooMuch = NO;
//        if (piiToAddTooLittle)   [_tooLittlePii setImage:checkedImage forState:UIControlStateNormal];
//        else                    [_tooLittlePii setImage:unCheckedImage forState:UIControlStateNormal];
//        
//        
//        [_normalPii setImage:unCheckedImage forState:UIControlStateNormal];
//        [_tooMuchPii setImage:unCheckedImage forState:UIControlStateNormal];
//        // NSLog(@"\nnormal: %d\n TooMuch:%d\n TooLittle:%d", piiToAddNormal, piiToAddTooMuch,piiToAddTooLittle);
//    }
//}

//TODO: remove?
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];

}
#pragma mark Alerts
-(void)setUpAlerts
{
    noBoobsAlert = [[UIAlertView alloc] initWithTitle:@"No breast choosen"
                                                        message:@"You have to choose right, left or both breasts"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
    
   noBottleAlert = [[UIAlertView alloc] initWithTitle:@"No milk choosen"
                                                            message:@"You have to set how much your baby ate. Use the slider to set how much your baby ate"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];

    
}

#pragma mark save

- (IBAction)save:(id)sender {
    
    if (titsView)
    {
        if (!leftBoob && !rightBoob) {
          
            [noBoobsAlert show];
            
        } else {
            
            Tits *tit = [[SLKTittStorage sharedStorage]
                         createTittWithId:[[NSProcessInfo processInfo] globallyUniqueString]
                         StringValue:_sliderOneLabel.text
                         mililitres:nil
                         minutes:nil
                         leftBoob:leftBoob
                         rightBoob:rightBoob
                         dirty:YES];
            
              [[SLKEventStorage sharedStorage]
               createEvenWithHappening:tit
               withComment:@"fake"
               date:date
               eventId:tit.titId
               baby:[[SLKBabyStorage sharedStorage]
                     getCurrentBaby]
               dirty:YES];
            
    //        [SLKPARSEService postObject:pfTits onSuccess:^(PFObject *object)
//        {
//            NSLog(@"\n\nSucceed to create  pfTit %@\n\n", [object objectId]);
//            
//                [SLKPARSEService postObject:pfEventObject onSuccess:^(PFObject *eventobj)
//                {
//                        NSLog(@"\n\n\n Succeed to create pfEvent:::%@\n\n", [eventobj objectId]);
//                        PFRelation *relation = [pfEventObject relationforKey:@"titts"];
//                        [relation addObject:pfTits];
//                        [pfEventObject saveInBackground];//??????????????
//                     
//                } onFailure:^(PFObject *obj) {
//                        NSLog(@"error: %@", obj);
//                }];
//            
//                } onFailure:^(PFObject *object) {
//    
//                    NSLog(@"Failed to create tit %@", object);
//                }];
        
            leftBoob = NO;
            [_leftTit setImage:[UIImage imageNamed:@"tits.png"]];
            rightBoob = NO;
            [_rightTit setImage:[UIImage imageNamed:@"tits.png"]];
            
        }
    }
    else if (bottleView)
    {
        if (bottledFood == 0 ) {
        [noBottleAlert show];
        }else {
                    Bottle *bottle = [[SLKBottleStorage sharedStorage]
                                      createBottleWithId:[[NSProcessInfo processInfo] globallyUniqueString]
                                      stringValue:nil
                                      mililitres:[NSNumber numberWithFloat:bottledFood]
                                      minutes:nil
                                      dirty:YES];
            
            [[SLKEventStorage sharedStorage]
             createEvenWithHappening:bottle
             withComment:nil
             date:date
             eventId:bottle.bottleId
             baby:[[SLKBabyStorage sharedStorage]
                   getCurrentBaby]
             dirty:YES];
            
            
            bottledFood = 0;
            [_sliderOne setValue:0];
            _sliderOneLabel.text = [NSString stringWithFormat:@" %.f ml",_sliderOne.value];
        
            }
            
    }
    else if (sleepView)
    {

        Sleep *sleep =  [[SLKSleepStorage sharedStorage]
                         createSleepWithId:[[NSProcessInfo processInfo] globallyUniqueString]
                         minutes:[NSNumber numberWithInt:sleptMinutes] dirty:YES];
        
        [[SLKEventStorage sharedStorage]
         createEvenWithHappening:sleep
         withComment:nil
         date:date
         eventId:sleep.sleepId
         baby:[[SLKBabyStorage sharedStorage]
               getCurrentBaby]
         dirty:YES];
    }
    
    else if (diaperView)
    {
       // if (!pooToAddNormal && !pooToAddTooMuch && !pooToAddToLittle && !piiToAddNormal && !piiToAddTooMuch && !piiToAddTooLittle)
        if (_switchOne.selected == NO && _switchTwo.selected == NO) //did not pee or poo
        {
            NSString *alertMessage = [NSString stringWithFormat:@"Please enter how much %@ did pii or poo", currentBabe.name];
            UIAlertView *alertNoPiisOrPoos = [[UIAlertView alloc] initWithTitle:@"NOTHING TO LOG" message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertNoPiisOrPoos show];
        } else {
            
            if (_switchOne.selected && !_switchTwo.selected) { //create only poo
                NSLog(@"create new POO");
                
                Poo *someNewPoo = [[SLKPooStorage sharedStorage]
                                   createPooWithId:[[NSProcessInfo processInfo] globallyUniqueString]
                                   dirty:YES];
                                   
                [[SLKEventStorage sharedStorage]
                 createEvenWithHappening:someNewPoo
                 withComment:nil
                 date:date
                 eventId:someNewPoo.pooId
                 baby:[[SLKBabyStorage sharedStorage]
                       getCurrentBaby]
                 dirty:YES];

            } else {
                NSLog(@"NO New POO");
            }
            if (_switchTwo.selected && !_switchOne.selected) { //create only pii
                NSLog(@"Create new PII AND POO" );
          
                Pii *someNewPii = [[SLKPiiStorage sharedStorage]
                                   createPiiWithId:[[NSProcessInfo processInfo] globallyUniqueString]
                                   dirty:YES];
                
                [[SLKEventStorage sharedStorage]
                 createEvenWithHappening:someNewPii
                 withComment:nil
                 date:date
                 eventId:someNewPii.piiId
                 baby:[[SLKBabyStorage sharedStorage]
                       getCurrentBaby]
                 dirty:YES];
                
            }   if (_switchTwo.selected && _switchOne.selected) { //create both pii and poo
                NSLog(@"Create new PII AND POO" );
                
                Pii *someNewPii = [[SLKPiiStorage sharedStorage]
                                   createPiiWithId:[[NSProcessInfo processInfo] globallyUniqueString]
                                   dirty:YES];
                
                [[SLKEventStorage sharedStorage]
                 createEvenWithHappening:someNewPii
                 withComment:nil
                 date:date
                 eventId:someNewPii.piiId
                 baby:[[SLKBabyStorage sharedStorage]
                       getCurrentBaby]
                 dirty:YES];
                
                Poo *someNewPoo = [[SLKPooStorage sharedStorage]
                                   createPooWithId:[[NSProcessInfo processInfo] globallyUniqueString]
                                   dirty:YES];
                
                [[SLKEventStorage sharedStorage]
                 createEvenWithHappening:someNewPoo
                 withComment:nil
                 date:date
                 eventId:someNewPoo.pooId
                 baby:[[SLKBabyStorage sharedStorage]
                       getCurrentBaby]
                 dirty:YES];
                
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
    [self setUniversalSliderText:nil];
    [self setDiaperView:nil];
    [self setMedzView:nil];
    [self setPrevArrow:nil];
    [self setNextArrow:nil];
    [self setDiaperLabels:nil];
    [self setSwitchOne:nil];
    [self setSwitchTwo:nil];
    [self setCommentTextView:nil];
    [self setPee:nil];
    [self setPoo:nil];
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
#pragma mark Sliders
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
-(UIImage*)drawImagewithFrame:(CGRect)frame
{
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (int i = 0; i <= frame.size.width; i++) {
        UIImage *img = [UIImage imageNamed:@"milk2px.png"];
        [imageArray addObject:img];
    }
    
    UIImage *middleImage = [self mergeImages:imageArray];
    return middleImage;
//    UIImage *leftImage = [UIImage imageNamed:@"milk2px.png"];
//    UIImage *rightImage = [UIImage imageNamed:@"milk2px.png"];
//    
//    CGFloat widthOfAllImages = leftImage.size.width + middleImage.size.width + rightImage.size.width;
//    
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(widthOfAllImages, middleImage.size.height), NO, 0);
//    [leftImage drawAtPoint:CGPointMake(0, 0)];
//    [middleImage drawAtPoint:CGPointMake(leftImage.size.width, 0)];
//    [rightImage drawAtPoint:CGPointMake(leftImage.size.width + middleImage.size.width, 0)];
//    
//    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:im];
//    imageView.frame = frame;
   // [self addSubview:imageView];
}
-(UIImage*)mergeImages:(NSMutableArray*)images
{
    //UIGraphicsBeginImageContextWithOptions(CGSizeMake(images.count, self.frame.size.height), YES, 0.0);
    for (int i = 0; i < images.count; i++) {
        [[images objectAtIndex:i] drawAtPoint: CGPointMake(i,0)];
    }
    
    UIImage *middleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return middleImage;
}

-(void)setSliderOneLabelBottle
{
    _sliderOneLabel.text = [NSString stringWithFormat:@" %.f ml",_sliderOne.value];
    bottledFood = _sliderOne.value;
    int height = _sliderOne.value/5;
    [UIView animateWithDuration:0.4 animations:^{ [milkView setFrame:CGRectMake(122, milkY- height, 32.5, height)]; }];

}
-(void)setSliderOneLabelSleep
{
    //TODO: right now its only possible to log sleep for 4 hours... Add whole night?
    NSNumber *theDouble = [NSNumber numberWithDouble:_sliderOne.value];
    
    int inputSeconds = [theDouble intValue];
    int hours =  inputSeconds / 3600;
    int anHour = ( inputSeconds - hours * 3600 ) / 60;
    int aMinute = inputSeconds - hours * 3600 - anHour * 60;
    
    NSString *theTime = [NSString stringWithFormat:@"%.1dhr %.2dmin", anHour, aMinute];
   _sliderOneLabel.text = theTime;
    
    sleptMinutes = (anHour * 60) + aMinute;
    
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

#pragma mark Switch

- (IBAction)switchOne:(id)sender {
  _switchOne.selected = !_switchOne.selected;
    NSLog(@"selected ONE? : %d", _switchOne.selected);
}
- (IBAction)switchTwo:(id)sender {
    _switchTwo.selected = !_switchTwo.selected;
       NSLog(@"selected TWO? : %d", _switchTwo.selected);
}

# pragma mark - UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [[self view] setFrame:CGRectMake(0, -230, 320, 460)];
    [_commentTextView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
  
   [[self view] setFrame:CGRectMake(0, 0, 320, 460)];
    [_commentTextView resignFirstResponder];
}
@end
