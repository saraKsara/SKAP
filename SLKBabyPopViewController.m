//
//  SLKBabyPopViewController.m
//  SKAP
//
//  Created by Åsa Persson on 2013-03-22.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKBabyPopViewController.h"
#import "SLKJSONService.h"
#import "SLKBabyStorage.h"
#import "Baby.h"
#import "SLKDateUtil.h"
@interface SLKBabyPopViewController ()

@end

@implementation SLKBabyPopViewController
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
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button addTarget:self
//               action:@selector(addBabyNotification)
//     forControlEvents:UIControlEventTouchDown];
    
   // button.frame = CGRectMake(70.0, 70.0, 180.0, 20.0);
    btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 70, 100, 20)];
    [btnLabel setBackgroundColor:[UIColor clearColor]];
   
    [btnLabel setTextAlignment:NSTextAlignmentCenter];
    [btnLabel setTextColor:[UIColor whiteColor]];
   
    //[button setBackgroundColor:[UIColor grayColor]];
  
   // [button addSubview:btnLabel];
    
    [btnLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *addBabytapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addBabyNotification)];
    [btnLabel addGestureRecognizer:addBabytapped];

 
	anewBabuLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 250, 20)];
    [anewBabuLabel setBackgroundColor:[UIColor clearColor]];
    anewBabuLabel.text = @"Type in the name of you new baby";
    [anewBabuLabel sizeToFit];
    [anewBabuLabel setTextColor:[UIColor whiteColor]];
    
    [self.view addSubview:anewBabuLabel];
    
    babyNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(25.0, 30.0, 250.0, 20.0)];
    [babyNameTextField setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview: babyNameTextField];
    babyNameTextField.delegate = self;
    
    birthLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, 230, 20)];
    [birthLabel setBackgroundColor:[UIColor clearColor]];
    [birthLabel setFont:[UIFont fontWithName:@"Copperplate" size:34.0]];
    [birthLabel setTextColor:[UIColor blackColor]];
    birthLabel.text = [NSString stringWithFormat:@"%@", [SLKDateUtil formatDate: [NSDate date]]];
   
    birthDayPickerBtn = [[UILabel alloc]  initWithFrame:CGRectMake(110.0, 65.0, 280.0, 20.0)];
    [birthDayPickerBtn setBackgroundColor:[UIColor clearColor]];
    [birthDayPickerBtn setTextAlignment:NSTextAlignmentCenter];
    birthDayPickerBtn.text = @"-- DONE-- ";
    [birthDayPickerBtn setTextColor:[UIColor whiteColor]];
    [birthDayPickerBtn sizeToFit];
    
    [birthDayPickerBtn setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setBirthday:)];
    [birthDayPickerBtn addGestureRecognizer:tapped];
//    [self.view addSubview:birthDayPickerBtn];
    
    
    bDayPicker= [[UIDatePicker alloc] init];
    [bDayPicker setDatePickerMode:UIDatePickerModeDate];
     bDayPicker.frame = CGRectMake(0, 100 , 300, 280);
    [bDayPicker addTarget:self action:@selector(updateLabelFromPicker:) forControlEvents:UIControlEventValueChanged];

}

- (IBAction)updateLabelFromPicker:(id)sender {
    NSLog(@"date from datepicker: %@", bDayPicker.date);
       [birthLabel setTextColor:[UIColor whiteColor]];
    birthLabel.text = [NSString stringWithFormat:@"%@", [SLKDateUtil formatDate: bDayPicker.date]];
   
}

- (void)setBirthday:(UITapGestureRecognizer *)tapGesture
{
 
    [birthDayPickerBtn setHidden:YES];
    [anewBabuLabel setFrame:CGRectMake(70.0, 0.0, 250.0, 20.0)];
    anewBabuLabel.text = [NSString stringWithFormat:@"%@ was born on: ", babyNameTextField.text];
    [babyNameTextField removeFromSuperview];
      btnLabel.text = [NSString stringWithFormat:@"Add %@ to babyfeed", babyNameTextField.text];
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
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys: babyBirthday, @"date", babyNameTextField.text, @"babyName", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"addBaby" object:nil userInfo:userInfo];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerView Delegate

- (UIView*)addPickerLabel:(NSString *)labelString rightX:(CGFloat)rightX top:(CGFloat)top height:(CGFloat)height {
    
    UIFont *font =  [UIFont systemFontOfSize:15];
    CGFloat x = rightX - [labelString sizeWithFont:font].width;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, top + 1, rightX, height)];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, top, rightX, height)];
    label.text = labelString;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    label.opaque = NO;
    label.alpha = 0.7;
    
    return label;
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
-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    [self.tableView setFrame:CGRectMake(0,0,340,570)];
//    [[self tableView] reloadData];
}
@end
