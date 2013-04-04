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
@interface SLKAddBabyViewController (FPPopoverController)

@end

@implementation SLKAddBabyViewController
{
    UITextField *babyNameTextField;
    NSDate *babyBirthday;
    UIDatePicker *bDayPicker;
    UILabel *anewBabuLabel;
    
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
    _babynameTexField.delegate = self;
    [_doneBtn  setHidden:YES];
    bDayPicker= [[UIDatePicker alloc] init];
    [bDayPicker setDatePickerMode:UIDatePickerModeDate];
    bDayPicker.frame = CGRectMake(0, 320 , 320, 280);
    [bDayPicker addTarget:self action:@selector(updateLabelFromPicker:) forControlEvents:UIControlEventValueChanged];
   
}


- (IBAction)updateLabelFromPicker:(id)sender {
    NSLog(@"date from datepicker: %@", bDayPicker.date);
      [_birthLabel setHidden:NO];
    _birthLabel.text = [NSString stringWithFormat:@"%@", [SLKDateUtil formatDate: bDayPicker.date]];
    
}


- (IBAction)setBirthday:(id)sender
{
    [_birthDayPickerBtn setHidden:YES];
    [_doneBtn setHidden:NO];
    
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

-(void)enLargePopover
{
    
    
    [UIView animateWithDuration:.3f animations:^{
        CGRect theFrame = self.view.superview.frame;
        theFrame.size.height += 30.f;
        self.view.superview.frame = theFrame;
        //        [self.view addSubview:bDayPicker];
        //        [self.view addSubview:doneBtn];
        //[self.view addSubview:birthLabel];
    }];
}


//-(void)doneSelectingBday
//{
//    [bDayPicker removeFromSuperview];
//}
-(void)addBabyNotification
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:_babynameTexField, @"babyName", kBlueish_Color, @"color", nil];
    NSLog(@"vavava-------- %@", [userInfo valueForKey:@"babyName"]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"addBaby" object:nil userInfo:userInfo];
    
}

#pragma mark notification method

-(void) addBaby:(NSNotification *) notification
{
    NSLog(@"namnet på nya NOTTT: %@", [notification.userInfo allKeys]);
    NSString *newBabyName = [notification.userInfo objectForKey:@"babyName"];
    NSString *babyColor = [notification.userInfo objectForKey:@"color"];
    //  NSString *babyBirthday = [notification.userInfo objectForKey:@"date"];
    NSLog(@"namnet på nya bebben: %@", newBabyName);
    
    PFObject *babyObject = [PFObject objectWithClassName:@"Baby"];
    [babyObject setObject:newBabyName forKey:@"name"];
    [babyObject setObject:babyColor forKey:@"color"];
    //     [babyObject setObject:newBabyName forKey:@"date"];
    
    //TODO: CHECK FOR INTERNET CONNECTION (REACHABILITY?) AND DECIDE WHAT TO DO WHEN THERE'S NO CONNECTION
    
    [SLKPARSEService postObject:babyObject onSuccess:^(PFObject *object)
     {
         [[SLKBabyStorage sharedStorage] createBabyWithName:[object objectForKey:@"name"]
                                                     babyId:[object objectId]
                                                       date:nil
                                                       type:nil
                                                      color:[object objectForKey:@"color"]];
         
         NSLog(@"SUCCEED to create %@",[object objectForKey:@"name"] );
        
//         [popover dismissPopoverAnimated:YES completion:^{
//             
//            // [self.tableView reloadData];
//         }];
         
         
     } onFailure:^(PFObject *object)
     {
         NSLog(@"FAILED :((( ");
         
//         [popover dismissPopoverAnimated:YES completion:^{
//             [self.tableView reloadData];
//         }];
         
     }];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self enLargePopover];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


- (IBAction)setBlue:(id)sender {
}

- (IBAction)setGreen:(id)sender {
}

- (IBAction)setYellow:(id)sender {
}

- (IBAction)done:(id)sender {
    [bDayPicker removeFromSuperview];
    [_birthDayPickerBtn setHidden:NO];
    [_doneBtn setHidden:YES];
}
@end
