//
//  SLKFirtsTimeViewController.h
//  SKAP
//
//  Created by Åsa Persson on 2013-04-10.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLKFirtsTimeViewController : UIViewController
- (IBAction)signUp:(id)sender;
- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end
