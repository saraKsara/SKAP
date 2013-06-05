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
#import "ParentFigures.h"
#import "SLKParentStorage.h"
#import <Parse/Parse.h>
#import "SLKSettingsViewController.h"

@interface SLKAddBabyViewController ()

@end

@implementation SLKAddBabyViewController
{
    UITextField *babyNameTextField;
    NSDate *babyBirthday;
    UIDatePicker *bDayPicker;
    UILabel *anewBabuLabel;
    NSString *babycolor;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [_birthLabel setHidden:YES];
    [_blueBG setHidden:YES];
    [_yellowBG setHidden:YES];
    [_greenBG setHidden:YES];
    _babynameTexField.delegate = self;
    _setSignatureTextField.delegate = self;
    bDayPicker= [[UIDatePicker alloc] init];
    [bDayPicker setDatePickerMode:UIDatePickerModeDate];
    bDayPicker.frame = CGRectMake(0, 270 , 320, 200);
    [bDayPicker addTarget:self action:@selector(updateLabelFromPicker:) forControlEvents:UIControlEventValueChanged];
    if ([[[SLKParentStorage sharedStorage] parentArray] count] == 0) {
        _addBabyMode = NO;
    } else {
        _addBabyMode = YES;
    }
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
        _chooseColorLabel.text = @"Choose your color";
        _setSignatureLabel.text = @"Type in a signature";
    }


}

- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[[self navigationController] navigationBar] setHidden:NO];
}

- (IBAction)updateLabelFromPicker:(id)sender {
    NSLog(@"date from datepicker: %@", bDayPicker.date);
      [_birthLabel setHidden:NO];
    _birthLabel.text = [NSString stringWithFormat:@"%@", [SLKDateUtil formatDate: bDayPicker.date]];
    
}


- (IBAction)saveBaby:(id)sender {
    
    if (_addBabyMode) {
        
                Baby *theNewBabe =  [[SLKBabyStorage sharedStorage]
                                     createBabyWithName:_babynameTexField.text
                                     babyId:_babynameTexField.text
                                     date:nil//_babynameTexField.text
                                     type:nil
                                     color:babycolor
                                     dirty:YES];
                
                //[[PFUser currentUser]setObject:[object objectId] forKey:@"baby"];
                
                [[SLKBabyStorage sharedStorage] setCurrentBaby:theNewBabe];
                //         [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCalendar" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"newBaby" object:nil];
                
                
            PFObject *babyObject = [PFObject objectWithClassName:@"Baby"];
            [babyObject setObject:theNewBabe.name forKey:@"name"];
            [babyObject setObject:theNewBabe.babysColor forKey:@"color"];
            [[self navigationController] popViewControllerAnimated:YES];
                
            //     [babyObject setObject:newBabyName forKey:@"date"];
            
            //TODO: CHECK FOR INTERNET CONNECTION (REACHABILITY?) AND DECIDE WHAT TO DO WHEN THERE'S NO CONNECTION
            
            [SLKPARSEService postObject:babyObject onSuccess:^(PFObject *object)
             {
              

                  //TODO: undirty
                 
                 
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
             }];
    }
    else //first time use, add parent, then go to normal, then set child. maybe alert???
    {
        
             ParentFigures *theNewParent =  [[SLKParentStorage sharedStorage]
                                             createParentWithName:_babynameTexField.text
                                             signature:_setSignatureTextField.text
                                             parentId:[[NSProcessInfo processInfo] globallyUniqueString]
                                             number:nil
                                             color:babycolor
                                             babies:nil
                                             dirty:YES];
        [[SLKParentStorage sharedStorage] setCurrentParent:theNewParent];
        
        
        [[PFUser currentUser]setObject:theNewParent.parentId forKey:@"ParentFigure"];

        PFObject *parentObject = [PFObject objectWithClassName:@"ParentFigure"];
        [parentObject setObject:theNewParent.name forKey:@"name"];
        [parentObject setObject:theNewParent.parentColor forKey:@"color"];
        [parentObject setObject:theNewParent.signature forKey:@"signature"];
        [parentObject setObject:theNewParent.parentId forKey:@"parentId"];
        
        [SLKPARSEService postObject:parentObject onSuccess:^(PFObject *object)
         {
      
             NSLog(@"SUCCEED to create %@",[object objectForKey:@"name"] );
           //TODO: undirty
             //TODO: add a baby by reloading this view
             
//             [_setSignatureLabel setHidden:YES];
//             [_setSignatureTextField setHidden:YES];
             
            [[NSNotificationCenter defaultCenter] postNotificationName: @"setUpApp" object:nil userInfo:nil];
            [[self navigationController] popViewControllerAnimated:YES];
//
         } onFailure:^(PFObject *object)
         {
             NSLog(@"FAILED :((( ");
             UIAlertView *failAlert = [[UIAlertView alloc]
                                       initWithTitle:@"FAIL"
                                       message:@"Failed to add new baby for now. Please try again later" delegate:self
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil, nil];
             [failAlert show];
             [self performSegueWithIdentifier:@"addBabyNParentSeg" sender:self];
             
         }];
    }

}

- (IBAction)setBirthday:(id)sender
{

    [_babynameTexField resignFirstResponder];
    anewBabuLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 250, 20)];
    
    [anewBabuLabel setFrame:CGRectMake(70.0, 0.0, 250.0, 20.0)];
    anewBabuLabel.text = [NSString stringWithFormat:@"%@ was born on: ", babyNameTextField.text];
    [babyNameTextField removeFromSuperview];
    
      [self.view addSubview:bDayPicker];
//    
//    [UIView animateWithDuration:.3f animations:^{
//        CGRect theFrame = self.view.superview.frame;
//        theFrame.size.height += 200.f;
//        self.view.superview.frame = theFrame;
//        
//        [self.view addSubview:bDayPicker];
//
//    }];
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
