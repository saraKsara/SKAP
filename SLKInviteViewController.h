//
//  SLKInviteViewController.h
//  SKAP
//
//  Created by Åsa Persson on 2013-04-04.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLKInviteViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *textFieldDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber1textField;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;

- (IBAction)sendInvite:(id)sender;



@end
