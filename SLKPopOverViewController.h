//
//  SLKPopOverViewController.h
//  SKAP
//
//  Created by Åsa Persson on 2013-03-22.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FPViewController;
@interface SLKPopOverViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *babyNameTextField;
- (IBAction)addBaby:(id)sender;

@property(nonatomic,assign) FPViewController *delegate;
@end
