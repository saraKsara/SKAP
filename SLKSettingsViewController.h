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
@property (weak, nonatomic) IBOutlet UIView *welcome;
@property BOOL firstTime;
@property BOOL setBtnToAddBaby;
@end
