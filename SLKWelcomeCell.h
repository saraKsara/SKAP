//
//  SLKWelcomeCell.h
//  SKAP
//
//  Created by Åsa Persson on 2013-04-08.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLKWelcomeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)login:(id)sender;

@end
