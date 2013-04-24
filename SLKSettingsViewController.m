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
#import "SLKParentStorage.h"
#import "ParentFigures.h"
#import "SLKColors.h"
#import "SLKAlertWithBlock.h"
#import "SLKUserDefaults.h"

@interface SLKSettingsViewController ()

@end

@implementation SLKSettingsViewController
{
    FPPopoverController *popover;
    SLKAddBabyViewController *controller;
    Baby *currentBabe;
    ParentFigures *currentParent;
    NSIndexPath *checkedIndexPath;
    
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
    NSLog(@"current baby: %@", currentBabe.name);
    
    
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
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0)           return 3;
    else if (section == 1)      return [[[SLKParentStorage sharedStorage] parentArray] count];
    else                        return [[[SLKBabyStorage sharedStorage] babyArray] count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   // if (!_firstTime) {
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
        else  if (indexPath.section == 1) //show list of parents
        {
            //set color on every parent? //TODO: set signature!
            ParentFigures *parent = [[[SLKParentStorage sharedStorage] parentArray] objectAtIndex:indexPath.row];
             if ([parent.parentId isEqualToString:currentParent.parentId]) {
                 [cell setBackgroundColor:[UIColor redColor]];
//                  [cell.nameLabel setTextColor:[UIColor colorWithHexValue:parent.parentColor]];
             }
            cell.nameLabel.text = parent.name;
            cell.signatureLabel.text = parent.signature;
            cell.numberTextView.text = parent.number;
            return cell;
        }
        else //show list of babies
        {  
            Baby *babe = [[[SLKBabyStorage sharedStorage] babyArray] objectAtIndex:indexPath.row];
            if ([babe.babyId isEqualToString:currentBabe.babyId]) {
//                [cell.nameLabel setTextColor:[UIColor colorWithHexValue:babe.babysColor]];
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                [cell setSelected:YES];
                checkedIndexPath = indexPath;
            }
            cell.nameLabel.text = babe.name;
            [cell.signatureLabel setHidden:YES];
            [cell.numberTextView setHidden:YES];
            return cell;
        }
   // }

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
    } else  if (section == 2) {
        
        UILabel *title = [[UILabel alloc] init];
        title.frame = CGRectMake(0, 0, 320, 30);
        title.textColor = [UIColor whiteColor];
        title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0f];
        title.text =  @"All babies";
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
    }
    else if (indexPath.section == 1)
    {
        //parents. Make phonenumber callable?
        NSLog(@"parents");
    }
    else if (indexPath.section == 2)
    {
        //babies
        SLKAlertWithBlock *alert = [[SLKAlertWithBlock alloc] initWithTitle:@"Switch baby" message:@"Are you sure you wanna switch baby?" completion:^(BOOL cancelled, NSInteger buttonIndex) {
            
            if (buttonIndex == 1)
            {
//            [[SLKBabyStorage sharedStorage] setCurrentBaby:[[[SLKBabyStorage sharedStorage] babyArray] objectAtIndex:indexPath.row]];
            //TODO: when finishing changing baby, reload table in calendar!? Add sompletionhandler???
                NSString *changeToBabyID = [[[[SLKBabyStorage sharedStorage] babyArray] objectAtIndex:indexPath.row]babyId];
                [SLKUserDefaults setTheCurrentBaby:changeToBabyID OnCompleted:^{
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCalendar" object:nil];
                    if(checkedIndexPath)
                    {
                        UITableViewCell* uncheckCell = [tableView cellForRowAtIndexPath:checkedIndexPath];
                        uncheckCell.accessoryType = UITableViewCellAccessoryNone;
                        
                    }
                    UITableViewCell *acell = [tableView cellForRowAtIndexPath:indexPath];
                    acell.accessoryType = UITableViewCellAccessoryCheckmark;
                    checkedIndexPath = indexPath;
                }];

                
                
            } else {
                NSLog(@"button index cancel");
            }
            
        } cancelButtonTitle:@"Cancel" otherButtonTitles:@"yes", nil];
        [alert show];
    }
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 44;
    
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
