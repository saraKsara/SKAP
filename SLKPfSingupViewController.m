//
//  SLKPfSingupViewController.m
//  SKAP
//
//  Created by Student vid Yrkeshögskola C3L on 5/1/13.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKPfSingupViewController.h"
#import "SLKPfLoginViewController.h"
#import "SLKPARSEService.h"
#import "SLKParentStorage.h"
#import "ParentFigures.h"
#import "SLKuser.h"
#import "SLKConstants.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
@interface SLKPfSingupViewController ()



@property (nonatomic, strong) UIImageView *fieldsBackground;
@end

@implementation SLKPfSingupViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    
//     [self.signUpView.signUpButton addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.signUpView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"poppis.png"]]];
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bo.png"]]];
    
    // Change button apperance
    [self.signUpView.dismissButton setImage:[UIImage imageNamed:@"arrowDown.png"] forState:UIControlStateNormal];
    [self.signUpView.dismissButton setImage:[UIImage imageNamed:@"arrow_03.png"] forState:UIControlStateHighlighted];
   
    
    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@"logg.png"] forState:UIControlStateNormal];
    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@"logg.png"] forState:UIControlStateHighlighted];
    [self.signUpView.signUpButton setTitle:@"singUp" forState:UIControlStateNormal];
    [self.signUpView.signUpButton setTitle:@"done" forState:UIControlStateHighlighted];
    
    // Add background for fields
    [self setFieldsBackground:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logg.png"]]];
    [self.signUpView insertSubview:_fieldsBackground atIndex:1];
    
    // Remove text shadow
    CALayer *layer = self.signUpView.usernameField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.passwordField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.emailField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.additionalField.layer;
    layer.shadowOpacity = 0.0f;
    
    // Set text color
    [self.signUpView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.emailField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.additionalField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
   // [self.signUpView.signUpButton performSelector:popView];
    
    // Change "Additional" to match our use
    [self.signUpView.additionalField setPlaceholder:@"Phone number"];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Move all fields down on smaller screen sizes
    float yOffset = [UIScreen mainScreen].bounds.size.height <= 480.0f ? 30.0f : 0.0f;
    CGRect fieldFrame = self.signUpView.usernameField.frame;
    
    [self.signUpView.dismissButton setFrame:CGRectMake(10.0f, 10.0f, 87.5f, 45.5f)];
    [self.signUpView.logo setFrame:CGRectMake(66.5f, 70.0f, 187.0f, 58.5f)];
    [self.signUpView.signUpButton setFrame:CGRectMake(35.0f, 385.0f, 250.0f, 40.0f)];
    [self.fieldsBackground setFrame:CGRectMake(35.0f, fieldFrame.origin.y + yOffset, 250.0f, 174.0f)];
    
    [self.signUpView.usernameField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                       fieldFrame.origin.y + yOffset,
                                                       fieldFrame.size.width - 10.0f,
                                                       fieldFrame.size.height)];
    yOffset += fieldFrame.size.height;
    
    [self.signUpView.passwordField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                       fieldFrame.origin.y + yOffset,
                                                       fieldFrame.size.width - 10.0f,
                                                       fieldFrame.size.height)];
    yOffset += fieldFrame.size.height;
    
    [self.signUpView.emailField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                    fieldFrame.origin.y + yOffset,
                                                    fieldFrame.size.width - 10.0f,
                                                    fieldFrame.size.height)];
    yOffset += fieldFrame.size.height;
    
    [self.signUpView.additionalField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                         fieldFrame.origin.y + yOffset,
                                                         fieldFrame.size.width - 10.0f,
                                                         fieldFrame.size.height)];
}


-(void)popView
{
     
//    NSString *name = self.signUpView.usernameField.text;
//    NSString *email = self.signUpView.emailField.text;
//    
//    //Creating new parent from scratch, eg, without an invitation and babyId...
//    ParentFigures *theNewParent =  [[SLKParentStorage sharedStorage]
//                                    createParentWithName: name
//                                    signature:email
//                                    parentId:[[NSProcessInfo processInfo] globallyUniqueString]
//                                    number:@"0046707245749"
//                                    color:nil
//                                    babies:nil//set this if parent has invitation
//                                    dirty:YES];
//    
//    
//    SLKPfLoginViewController *lvc = [[SLKPfLoginViewController alloc]init];
//    //lvc.delegate = self;
//    
//    [self presentViewController:lvc animated:YES completion:NULL];
//    //
//TODO: use signupdelegate to check if signup was sucessful!
}

   //  NSLog(@"objectID from parse----%@",uname);
     //[SLKPARSEService getParentWithUserName:u];
   





- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
