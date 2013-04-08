//
//  SLKLoginAndOutViewController.h
//  SKAP
//
//  Created by Åsa Persson on 2013-04-08.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLKLoginViewController : UIViewController



@property (weak, nonatomic) IBOutlet UIButton *logInBtn;
- (IBAction)logIn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
- (IBAction)signUp:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *enterUsernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *enterUsernameTextField;

@property (weak, nonatomic) IBOutlet UILabel *enterPasswordLabel;
@property (weak, nonatomic) IBOutlet UITextField *enterPasswordTextField;


@end
