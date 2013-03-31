//
//  SLKPiiPooViewController.m
//  SKAP
//
//  Created by Student vid Yrkeshögskola C3L on 3/20/13.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKPiiPooViewController.h"
#import "SLKBabyStorage.h"
#import "Baby.h"
#import "Poo.h"
#import "Pii.h"
#import "Event.h"
#import "SLKPooStorage.h"
#import "SLKPiiStorage.h"
#import "SLKEventStorage.h"
#import "SLKDates.h"
#import "SLKDateUtil.h"
@interface SLKPiiPooViewController ()

@end

@implementation SLKPiiPooViewController
{
    Baby *currentBabe;
    BOOL piiToAddNormal;
    BOOL piiToAddTooMuch;
    BOOL piiToAddTooLittle;
    
    BOOL pooToAddNormal;
    BOOL pooToAddTooMuch;
    BOOL pooToAddToLittle;
    
    NSString *time;
    NSDate *date;
    UIImage *checkedImage;
    UIImage *unCheckedImage;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    piiToAddNormal = NO;
    piiToAddTooMuch = NO;
    piiToAddTooLittle = NO;
    
    pooToAddNormal = NO;
    pooToAddTooMuch = NO;
    pooToAddToLittle = NO;
    
    currentBabe = [[SLKBabyStorage sharedStorage] getCurrentBaby];
    _nameOfBabyLabel.text = [NSString stringWithFormat:@"Poo and pee of %@",currentBabe.name];
    
    date = [NSDate date];
    time = [SLKDateUtil formatTimeFromDate:date];
    _timeLabel.text = time;
    
    checkedImage = [UIImage imageNamed:@"checkedBox"];
    unCheckedImage = [UIImage imageNamed:@"uncheckedBox"];
    
    [_normalPoo setImage:unCheckedImage forState:UIControlStateNormal];
    [_tooMuchPoo setImage:unCheckedImage forState:UIControlStateNormal];
    [_tooLittlePoo setImage:unCheckedImage forState:UIControlStateNormal];
    
    [_normalPii setImage:unCheckedImage forState:UIControlStateNormal];
    [_tooMuchPii setImage:unCheckedImage forState:UIControlStateNormal];
    [_tooLittlePii setImage:unCheckedImage forState:UIControlStateNormal];

 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sooner:(id)sender {
    date = [date dateBySubtractingMinutes:15];
    time = [SLKDateUtil formatTimeFromDate:date];
    _timeLabel.text = time;
}

- (IBAction)later:(id)sender {
    
    date = [date dateByAddingMinutes:15];
    time = [SLKDateUtil formatTimeFromDate:date];
    _timeLabel.text = time;
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
- (IBAction)save:(id)sender
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
        [[SLKEventStorage sharedStorage] createEventwithPoo:someNewPoo date:date eventId:nil baby:currentBabe];
                                                                            //TODO: let user choose date and time!!!!
        
    } else {
         NSLog(@"NO New POO");
    }
    if (piiToAddNormal || piiToAddTooMuch || piiToAddTooLittle) {
        NSLog(@"Create new PII");
        Pii *someNewPii = [[SLKPiiStorage sharedStorage] createNormalPii:piiToAddNormal tooMuch:piiToAddTooMuch tooLittle:piiToAddTooLittle];
        [[SLKEventStorage sharedStorage] createEventwithPii:someNewPii date:date eventId:nil baby:currentBabe];
                                                                            //TODO: let user choose date and time!!!!

    } else {
        NSLog(@"NO new Pii");
    }
    }
}
- (IBAction)setTimewithSlider:(id)sender
{
    NSLog(@"slider ONE changed::: %f ", [_timeSlider value]);
   // _timeLabel.text = [NSString stringWithFormat:@"%.f",[_timeSlider value]];
}
@end
