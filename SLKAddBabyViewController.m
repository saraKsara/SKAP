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
    UILabel *birthDayPickerBtn;
    UILabel *birthLabel;
    UILabel *btnLabel;
    UIButton *button;
    UIButton *doneBtn;
    UILabel *doneBtnLabel;
    UILabel *anewBabuLabel;
    NSString *babyName;
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
    [[self view] setBackgroundColor:[UIColor grayColor]];
    anewBabuLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 250, 20)];
    [anewBabuLabel setBackgroundColor:[UIColor greenColor]];
    anewBabuLabel.text = @"Type in the name of you new baby";
    [anewBabuLabel sizeToFit];
    [anewBabuLabel setTextColor:[UIColor blackColor]];
    [self.view addSubview:anewBabuLabel];
    
    babyNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(25.0, 30.0, 250.0, 20.0)];
    [babyNameTextField setBackgroundColor:[UIColor blackColor]];
    [babyNameTextField setTextColor:[UIColor whiteColor]];
    [self.view addSubview: babyNameTextField];
    babyNameTextField.delegate = self;

    
    
    btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 70, 100, 20)];
    [btnLabel setBackgroundColor:[UIColor greenColor]];
    [btnLabel setTextAlignment:NSTextAlignmentCenter];
    [btnLabel setTextColor:[UIColor blackColor]];
    [btnLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *addBabytapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addBabyNotification)];
    [btnLabel addGestureRecognizer:addBabytapped];

    
    
    birthLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, 230, 20)];
    [birthLabel setBackgroundColor:[UIColor clearColor]];
    [birthLabel setFont:[UIFont fontWithName:@"Copperplate" size:34.0]];
    [birthLabel setTextColor:[UIColor blackColor]];
    birthLabel.text = [NSString stringWithFormat:@"%@", [SLKDateUtil formatDate: [NSDate date]]];
    
    birthDayPickerBtn = [[UILabel alloc]  initWithFrame:CGRectMake(110.0, 65.0, 280.0, 20.0)];
    [birthDayPickerBtn setBackgroundColor:[UIColor clearColor]];
    [birthDayPickerBtn setTextAlignment:NSTextAlignmentCenter];
    birthDayPickerBtn.text = @"-- DONE-- ";
    [birthDayPickerBtn setTextColor:[UIColor blackColor]];
    [birthDayPickerBtn sizeToFit];
    
    [birthDayPickerBtn setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setBirthday:)];
    [birthDayPickerBtn addGestureRecognizer:tapped];
    //    [self.view addSubview:birthDayPickerBtn];
    
    
    bDayPicker= [[UIDatePicker alloc] init];
    [bDayPicker setDatePickerMode:UIDatePickerModeDate];
    bDayPicker.frame = CGRectMake(0, 100 , 300, 280);
    [bDayPicker addTarget:self action:@selector(updateLabelFromPicker:) forControlEvents:UIControlEventValueChanged];
    
    UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, 230, 20)];
    [colorLabel setBackgroundColor:[UIColor clearColor]];
    [colorLabel setTextColor:[UIColor blackColor]];
    colorLabel.text = @"choose a color for your baby:";
    [self.view addSubview:colorLabel];
    
    UILabel *greenLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 130, 230, 20)];
    [greenLabel setBackgroundColor:[UIColor clearColor]];
    [greenLabel setTextColor:[UIColor blackColor]];
    greenLabel.text = @"green:";
    [self.view addSubview:greenLabel];
    
    UILabel *yellowLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 150, 230, 20)];
    [yellowLabel setBackgroundColor:[UIColor clearColor]];
    [yellowLabel setTextColor:[UIColor blackColor]];
    yellowLabel.text = @"yellow:";
    [self.view addSubview:yellowLabel];
    
    UILabel *blueLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 170, 230, 20)];
    [blueLabel setBackgroundColor:[UIColor clearColor]];
    [blueLabel setTextColor:[UIColor blackColor]];
    blueLabel.text = @"blue:";
    [self.view addSubview:blueLabel];

}


- (IBAction)updateLabelFromPicker:(id)sender {
    NSLog(@"date from datepicker: %@", bDayPicker.date);
    [birthLabel setTextColor:[UIColor blackColor]];
    birthLabel.text = [NSString stringWithFormat:@"%@", [SLKDateUtil formatDate: bDayPicker.date]];
    
}


- (void)setBirthday:(UITapGestureRecognizer *)tapGesture
{
    
    [birthDayPickerBtn setHidden:YES];
    [anewBabuLabel setFrame:CGRectMake(70.0, 0.0, 250.0, 20.0)];
    anewBabuLabel.text = [NSString stringWithFormat:@"%@ was born on: ", babyNameTextField.text];
    [babyNameTextField removeFromSuperview];
    btnLabel.text = [NSString stringWithFormat:@"Add %@ to babyfeed", babyNameTextField.text];
    babyName = babyNameTextField.text;
    [btnLabel sizeToFit];
    [UIView animateWithDuration:.3f animations:^{
        CGRect theFrame = self.view.superview.frame;
        theFrame.size.height += 200.f;
        self.view.superview.frame = theFrame;
        
        [self.view addSubview:bDayPicker];
        //        [self.view addSubview:doneBtn];
        [self.view addSubview:btnLabel];
        [self.view addSubview:birthLabel];
    }];
}

-(void)enLargePopover
{
    
    
    [UIView animateWithDuration:.3f animations:^{
        CGRect theFrame = self.view.superview.frame;
        theFrame.size.height += 30.f;
        self.view.superview.frame = theFrame;
        [self.view addSubview:birthDayPickerBtn];
        //        [self.view addSubview:bDayPicker];
        //        [self.view addSubview:doneBtn];
        //[self.view addSubview:birthLabel];
    }];
}


-(void)doneSelectingBday
{
    [doneBtn removeFromSuperview];
    [bDayPicker removeFromSuperview];
    [self.view addSubview:button];
}
-(void)addBabyNotification
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:babyName, @"babyName", kGreenish_Color, @"color", nil];
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


@end
