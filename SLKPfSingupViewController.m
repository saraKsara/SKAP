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

#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
@interface SLKPfSingupViewController ()



@property (nonatomic, strong) UIImageView *fieldsBackground;
@end

@implementation SLKPfSingupViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(popView)
                                                 name:@"popView"
                                               object:nil];
    
     [self.signUpView.signUpButton addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    
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


- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    SLKuser *parentUser= [[SLKuser alloc] init];
    parentUser.parentId = user.objectId;
    parentUser.name = user.username;
    parentUser.email = user.email;

}


-(void)popView
{
     
    NSString *name = self.signUpView.usernameField.text;
    NSString *email = self.signUpView.emailField.text;
    
    PFObject *parentObject = [PFObject objectWithClassName:@"ParentFigure"];
    [parentObject setObject:name forKey:@"name"];
    [parentObject setObject:email forKey:@"signature"];
    [parentObject setObject:[[NSProcessInfo processInfo] globallyUniqueString] forKey:@"parentId"];

    
    //[parentObject setObject:_setSignatureTextField.text forKey:@"signature"];
    //     [babyObject setObject:newBabyName forKey:@"date"];
    
    //TODO: CHECK FOR INTERNET CONNECTION (REACHABILITY?) AND DECIDE WHAT TO DO WHEN THERE'S NO CONNECTION
    
    [SLKPARSEService postObject:parentObject onSuccess:^(PFObject *object)
     {
                  
         ParentFigures *theNewParent =  [[SLKParentStorage sharedStorage]
                                         createParentWithName: [object objectForKey:@"name"]
                                         signature:[object objectForKey:@"signature"]
                                          parentId:[object objectForKey:@"parentId"]
                                         number:@"0046707245749"
                                         color:[object objectForKey:@"color"]
                                         babies:nil
                                         dirty:NO];
         
         [[SLKParentStorage sharedStorage] setCurrentParent:theNewParent];
         
         [[PFUser currentUser]setObject:theNewParent.parentId forKey:@"ParentFigure"];//????
       
        [[SLKParentStorage sharedStorage] setCurrentParent:theNewParent];
         
         //TODO: add a baby by reloading this view
         
         //             [_setSignatureLabel setHidden:YES];
         //             [_setSignatureTextField setHidden:YES];
         
        
         SLKPfLoginViewController *lvc = [[SLKPfLoginViewController alloc]init];
         //lvc.delegate = self;
         
         [self presentViewController:lvc animated:YES completion:NULL];
         //
     } onFailure:^(PFObject *object)
     {
         NSLog(@"FAILED :((( ");
         UIAlertView *failAlert = [[UIAlertView alloc]
                                   initWithTitle:@"FAIL"
                                   message:@"Failed to add new baby for now. Please try again later" delegate:self
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil, nil];
         [failAlert show];
         [self performSegueWithIdentifier:@"addBabyNParentSeg" sender:self];
         
     }];
}







   //  NSLog(@"objectID from parse----%@",uname);
     //[SLKPARSEService getParentWithUserName:u];
   
    


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



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
