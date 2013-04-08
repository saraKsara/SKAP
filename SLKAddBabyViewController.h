//
//  SLKAddBabyViewController.h
//  SKAP
//
//  Created by Åsa Persson on 2013-04-04.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPPopoverController.h"
@interface SLKAddBabyViewController : UIViewController <UITextFieldDelegate>

@property BOOL addBabyMode;

@property (weak, nonatomic) IBOutlet UILabel *setNameOfBabyLabel;
@property (weak, nonatomic) IBOutlet UITextField *babynameTexField;

@property (weak, nonatomic) IBOutlet UIButton *birthDayPickerBtn;

@property (weak, nonatomic) IBOutlet UILabel *chooseColorLabel;

- (IBAction)setBlue:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *blueBG;

- (IBAction)setGreen:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *greenBG;

@property (weak, nonatomic) IBOutlet UIButton *cancel;
- (IBAction)cancel:(id)sender;

- (IBAction)setYellow:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *yellowBG;

@property (weak, nonatomic) IBOutlet UIButton *saveBaby;
- (IBAction)saveBaby:(id)sender;

- (IBAction)setBirthday:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *birthLabel;

- (IBAction)done:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (weak, nonatomic) IBOutlet UILabel *setSignatureLabel;
@property (weak, nonatomic) IBOutlet UITextField *setSignatureTextField;



@end
