//
//  SLKPiiPooViewController.h
//  SKAP
//
//  Created by Student vid Yrkeshögskola C3L on 3/20/13.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SLKPiiPooViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *normalPoo;
@property (weak, nonatomic) IBOutlet UIButton *tooMuchPoo;
@property (weak, nonatomic) IBOutlet UIButton *tooLittlePoo;

- (IBAction)check:(id)sender;





@property (weak, nonatomic) IBOutlet UILabel *nameOfBabyLabel;
- (IBAction)changePoo:(id)sender;
@end
