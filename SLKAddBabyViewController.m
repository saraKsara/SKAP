//
//  SLKAddBabyViewController.m
//  SKAP
//
//  Created by Åsa Persson on 2013-04-04.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKAddBabyViewController.h"
#import "SLKBabyStorage.h"
#import "Baby.h"
#import "SLKDateUtil.h"
#import "SLKConstants.h"
#import "SLKPARSEService.h"
#import "SLKConstants.h"

@interface SLKAddBabyViewController (FPPopoverController)

@end

@implementation SLKAddBabyViewController
{
    UITextField *babyNameTextField;
    NSDate *babyBirthday;
    UIDatePicker *bDayPicker;
    UILabel *anewBabuLabel;
    NSString *babycolor;
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
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addBaby:)
                                                 name:@"addBaby"
                                               object:nil];

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [_birthLabel setHidden:YES];
    [_blueBG setHidden:YES];
    [_yellowBG setHidden:YES];
    [_greenBG setHidden:YES];
    _babynameTexField.delegate = self;
   // [_doneBtn  setHidden:YES];
    bDayPicker= [[UIDatePicker alloc] init];
    [bDayPicker setDatePickerMode:UIDatePickerModeDate];
    bDayPicker.frame = CGRectMake(0, 320 , 320, 280);
    [bDayPicker addTarget:self action:@selector(updateLabelFromPicker:) forControlEvents:UIControlEventValueChanged];
    
    if ( _addBabyMode)
    {
    [_setSignatureLabel setHidden:YES];
    [_setSignatureTextField setHidden:YES];
    }
    else if ( !_addBabyMode)
    {
        [_birthDayPickerBtn  setHidden:YES];
        [_doneBtn  setHidden:YES];
        _setNameOfBabyLabel.text = @"Typ in your name";
        _chooseColorLabel.text = @"Choose a color that will symbolise you.";
        
    }
}


- (IBAction)updateLabelFromPicker:(id)sender {
    NSLog(@"date from datepicker: %@", bDayPicker.date);
      [_birthLabel setHidden:NO];
    _birthLabel.text = [NSString stringWithFormat:@"%@", [SLKDateUtil formatDate: bDayPicker.date]];
    
}


- (IBAction)saveBaby:(id)sender {
    NSLog(@"save:: %@----%@----",babycolor, _babynameTexField.text);
    PFObject *babyObject = [PFObject objectWithClassName:@"Baby"];
    [babyObject setObject:_babynameTexField.text forKey:@"name"];
    [babyObject setObject:babycolor forKey:@"color"];
    //     [babyObject setObject:newBabyName forKey:@"date"];
    
    //TODO: CHECK FOR INTERNET CONNECTION (REACHABILITY?) AND DECIDE WHAT TO DO WHEN THERE'S NO CONNECTION
    
    [SLKPARSEService postObject:babyObject onSuccess:^(PFObject *object)
     {
       Baby *theNewBabe =  [[SLKBabyStorage sharedStorage] createBabyWithName:[object objectForKey:@"name"]
                                                     babyId:[object objectId]
                                                       date:nil
                                                       type:nil
                                                      color:[object objectForKey:@"color"]];
         
         NSLog(@"SUCCEED to create %@",[object objectForKey:@"name"] );
         [[SLKBabyStorage sharedStorage] setCurrentBaby:theNewBabe];
        
         NSString *color = theNewBabe.babysColor;
         NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys: color, @"color", nil];
         [[NSNotificationCenter defaultCenter] postNotificationName: @"setUpSegmentControlls" object:nil userInfo:nil];

         [[NSNotificationCenter defaultCenter] postNotificationName: @"changeBabyColor" object:nil userInfo:userInfo];

         //         [popover dismissPopoverAnimated:YES completion:^{
         //            // [self.tableView reloadData];
         //         }];
         [self dismissViewControllerAnimated:YES completion:^{
             //set text on settingsVC who are invited
         }];
         
         
     } onFailure:^(PFObject *object)
     {
         NSLog(@"FAILED :((( ");
         UIAlertView *failAlert = [[UIAlertView alloc]
                                   initWithTitle:@"FAIL"
                                   message:@"Failed to add new baby for now. Please try again later" delegate:self
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil, nil];
         [failAlert show];
         [self dismissViewControllerAnimated:YES completion:^{
             //set text on settingsVC who are invited
         }];
         //         [popover dismissPopoverAnimated:YES completion:^{
         //             [self.tableView reloadData];
         //         }];
         
     }];

}

- (IBAction)setBirthday:(id)sender
{

    [_babynameTexField resignFirstResponder];
    anewBabuLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 250, 20)];
    
    [anewBabuLabel setFrame:CGRectMake(70.0, 0.0, 250.0, 20.0)];
    anewBabuLabel.text = [NSString stringWithFormat:@"%@ was born on: ", babyNameTextField.text];
    [babyNameTextField removeFromSuperview];
    
    [UIView animateWithDuration:.3f animations:^{
        CGRect theFrame = self.view.superview.frame;
        theFrame.size.height += 200.f;
        self.view.superview.frame = theFrame;
        
        [self.view addSubview:bDayPicker];

    }];
}


-(void)addBabyNotification
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:_babynameTexField, @"babyName", kBlueish_Color, @"color", nil];
    NSLog(@"vavava-------- %@", [userInfo valueForKey:@"babyName"]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"addBaby" object:nil userInfo:userInfo];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


- (IBAction)setBlue:(id)sender {
    [_blueBG setHidden:NO];
    [_yellowBG setHidden:YES];
    [_greenBG setHidden:YES];
    babycolor = kBlueish_Color;
}

- (IBAction)setGreen:(id)sender {
    [_blueBG setHidden:YES];
    [_yellowBG setHidden:YES];
    [_greenBG setHidden:NO];
    babycolor = kGreenish_Color;
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)setYellow:(id)sender {
    [_blueBG setHidden:YES];
    [_yellowBG setHidden:NO];
    [_greenBG setHidden:YES];
    babycolor = kYellowish_Color;
}

- (IBAction)done:(id)sender {
    [bDayPicker removeFromSuperview];

}
@end
