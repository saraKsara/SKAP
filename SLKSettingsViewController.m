//
//  SLKSettingsViewController.m
//  SKAP
//
//  Created by Åsa Persson on 2013-04-04.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKSettingsViewController.h"
#import "SLKParentListCell.h"
#import "SLKInviteViewController.h"
#import "FPPopoverController.h"
#import "FPTouchView.h"
#import "FPPopoverView.h"
#import "ARCMacros.h"
#import "SLKAddBabyViewController.h"
#import "SLKAppDelegate.h"
#import "SLKBabyStorage.h"
#import "Baby.h"
#import "SLKAddBabyViewController.h"
#import "SLKWelcomeCell.h"
#import "SLKParentStorage.h"
#import "ParentFigures.h"
@interface SLKSettingsViewController ()

@end

@implementation SLKSettingsViewController
{
    FPPopoverController *popover;
    SLKAddBabyViewController *controller;
    Baby *currentBabe;
    ParentFigures *currentParent;
    
  }
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addBabyNParentSeg"]) {
        SLKAddBabyViewController *addVc = [segue destinationViewController];
        addVc.addBabyMode = !_firstTime;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
     if ([[[SLKParentStorage sharedStorage]parentArray]count] == 0 ) {
         _firstTime = YES;
     } else{
         _firstTime = NO;
     }
      controller = [[SLKAddBabyViewController alloc] init];
    currentBabe = [[SLKBabyStorage sharedStorage] getCurrentBaby];
    currentParent = [[SLKParentStorage sharedStorage]getCurrentParent];
    NSLog(@"current parent: %@", currentParent.name);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(login)
                                                 name:@"loginNot"
                                               object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[[self navigationController] navigationBar] setHidden:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)login
{
    [self performSegueWithIdentifier:@"addBabyNParentSeg" sender:self];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _firstTime ? 1 : 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_firstTime) {
        if (section == 1)   return [[[SLKParentStorage sharedStorage] parentArray] count];
        else                return 3;
    } else {
        return 1;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!_firstTime) {
        static NSString *CellIdentifier = @"settingCell";
        //SLKParentListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        SLKParentListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (indexPath.section == 0)
        {
            if (indexPath.row ==0 ) {
                cell.nameLabel.text = @"Add another Parent figure";
                [cell.numberTextView setHidden:YES];
                [cell.signatureLabel setHidden:YES];
            } else  if (indexPath.row ==1 )
            {
                cell.nameLabel.text = @"Add another baby";
                [cell.numberTextView setHidden:YES];
                  [cell.signatureLabel setHidden:YES];
            }else  if (indexPath.row ==2 )
            {
                cell.nameLabel.text = @"log out";
                [cell.numberTextView setHidden:YES];
                  [cell.signatureLabel setHidden:YES];
            }
            return cell;
        }
        else
        {
            //set color on every parent? //TODO: set signature!
            ParentFigures *parent = [[[SLKParentStorage sharedStorage] parentArray] objectAtIndex:indexPath.row];
             if ([parent.parentId isEqualToString:currentParent.parentId]) {
                 [cell setBackgroundColor:[UIColor redColor]];
                  [cell.nameLabel setTextColor:[UIColor redColor]];
             }
            cell.nameLabel.text = parent.name;
            cell.signatureLabel.text = parent.signature;
            cell.numberTextView.text = parent.number;
            return cell;
        }
    }
    else {
        SLKWelcomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"welcomeCell"];
 
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(0, 0, 320, 30);
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0f];
    title.text =  @"All Parent figures \t\t\t\t\t\t\t\t\t signature\t\t\t\t\t\t\t\t\t number ";
    title.backgroundColor = [UIColor blackColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [view addSubview:title];
    
    return  view;
    }
    else return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_firstTime) {
         //[self performSegueWithIdentifier:@"addBabyNParentSeg" sender:self];
    } else {
    
    if (indexPath.section == 0){
        if (indexPath.row ==0 ) {
          [self performSegueWithIdentifier:@"inviteSeg" sender:self];
            
        } else  if (indexPath.row ==1 )
        {
            [self performSegueWithIdentifier:@"addBabyNParentSeg" sender:self];
        } else  if (indexPath.row ==2 )
        {
            UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure you wanna log out?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
            [logoutAlert show];
        }
    } else {
        //make telepfone number interactive and callable.
    }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_firstTime)     return 455;
     else               return 44;
    
}

#pragma mark Alertview Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
           [[NSNotificationCenter defaultCenter] postNotificationName: @"setUpAppFirstTime" object:nil userInfo:nil];
        NSLog(@"Bye bye!");
    }
}
- (void)viewDidUnload {

    [super viewDidUnload];
}
- (IBAction)login:(id)sender {
}
@end
