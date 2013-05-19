//
//  SLKCreateBabyViewController.m
//  SKAP
//
//  Created by Åsa Persson on 2013-05-19.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKCreateBabyViewController.h"
#import "Baby.h"
#import "SLKBabyStorage.h"
#import <Parse/Parse.h>
#import "SLKConstants.h"

@interface SLKCreateBabyViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthDayTextField;
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end

@implementation SLKCreateBabyViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNameTextField:nil];
    [self setBirthDayTextField:nil];
    [super viewDidUnload];
}
- (IBAction)save:(id)sender {
   Baby *createBaby = [[SLKBabyStorage sharedStorage] createBabyWithName:_nameTextField.text
                                                babyId:[[NSProcessInfo processInfo] globallyUniqueString]
                                                  date:nil
                                                  type:kBaby
                                                 color:nil
                                                 dirty:YES];
    


}

- (IBAction)cancel:(id)sender {
}
@end
