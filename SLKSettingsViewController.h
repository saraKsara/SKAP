//
//  SLKSettingsViewController.h
//  SKAP
//
//  Created by Åsa Persson on 2013-04-04.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLKSettingsViewController : UITableViewController
- (IBAction)welcome:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *welcomeTextView;
@property (weak, nonatomic) IBOutlet UIButton *welcomeBtn;
@property BOOL firstTime;
@end
