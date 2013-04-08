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
      controller = [[SLKAddBabyViewController alloc] init];
    currentBabe = [[SLKBabyStorage sharedStorage] getCurrentBaby];
    currentParent = [[SLKParentStorage sharedStorage]getCurrentParent];
    NSLog(@"current parent: %@", currentParent.name);
 
  
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _firstTime ? 1 : 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_firstTime) {
        if (section == 1)   return [[[SLKParentStorage sharedStorage] parentArray] count];
        else                return 6;
    } else {
        return 1;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!_firstTime) {
        static NSString *CellIdentifier = @"settingCell";
        SLKParentListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (indexPath.section == 0)
        {
            if (indexPath.row ==0 ) {
                cell.nameLabel.text = @"Back";
                [cell.numberLabel setHidden:YES];
            } else  if (indexPath.row ==1 )
            {
                cell.nameLabel.text = @"Invite";
                [cell.numberLabel setHidden:YES];
            }else  if (indexPath.row ==2 )
            {
                cell.nameLabel.text = @"Links";
                [cell.numberLabel setHidden:YES];
            }else  if (indexPath.row ==3 )
            {
                cell.nameLabel.text = @"Add baby";
                [cell.numberLabel setHidden:YES];
            }else  if (indexPath.row ==4 )
            {
                cell.nameLabel.text = @"Delete";
                [cell.numberLabel setHidden:YES];
            }else  if (indexPath.row ==5 )
            {
                cell.nameLabel.text = @"Logout";
                [cell.numberLabel setHidden:YES];
            }
            return cell;
        }
        else
        {
            //set color on every parent? //TODO: set signature!
            ParentFigures *parent = [[[SLKParentStorage sharedStorage] parentArray] objectAtIndex:indexPath.row];
             if ([parent.parentId isEqualToString:currentParent.parentId]) {
                 [cell setBackgroundColor:[UIColor orangeColor]];
                  [cell.nameLabel setTextColor:[UIColor redColor]];
             }
            cell.nameLabel.text = parent.name;
            cell.numberLabel.text = parent.number;
            return cell;
        }
    }
    else {
        static NSString *CellIdentifier = @"welcomeCell";
        SLKWelcomeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
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
    title.text =  @"All Parent figures \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t number ";
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
         [self performSegueWithIdentifier:@"addBabyNParentSeg" sender:self];
    } else {
    
    if (indexPath.section == 0){
        if (indexPath.row ==0 ) {
            [self dismissViewControllerAnimated:YES completion:^{
                NSString *color = currentBabe.babysColor;
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys: color, @"color", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName: @"changeBabyColor" object:nil userInfo:userInfo];

                
            }];
        } else  if (indexPath.row ==1 )
        {
            [self performSegueWithIdentifier:@"addBabyNParentSeg" sender:self];
        }else  if (indexPath.row ==2 )
        {
              [self performSegueWithIdentifier:@"inviteSeg" sender:self];//links
        }else  if (indexPath.row ==3 )
        {
            
            [self performSegueWithIdentifier:@"addBabyNParentSeg" sender:self];//links

//          [self presentViewController:controller animated:YES completion:^{
//              
//          }];
            
            
//            popover = [[FPPopoverController alloc] initWithViewController:controller];
//            
//            popover.tint = FPPopoverDefaultTint;
//            [popover setAlpha:1];
//            //popover.arrowDirection = FPPopoverNoArrow;
//            popover.border = NO;
//            popover.contentSize = CGSizeMake(320, 215);
////            [popover presentPopoverFromView:self.view];
//           [popover presentPopoverFromPoint:CGPointMake(20, 20)];
//            
            
        }else  if (indexPath.row ==4 )
        {
             [self performSegueWithIdentifier:@"inviteSeg" sender:self]; //delete
        }else  if (indexPath.row ==5 )
        {  [self performSegueWithIdentifier:@"inviteSeg" sender:self];//lgout
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

@end
