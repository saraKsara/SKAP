//
//  SLKBabyListTableViewController.m
//  SKAP
//
//  Created by Åsa Persson on 2013-03-22.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKBabyListTableViewController.h"
#import "SLKBabyStorage.h"
#import "Baby.h"
#import "SLKPARSEService.h"
#import "SLKBabyCell.h"
#import "FPPopoverController.h"
#import "FPTouchView.h"
#import "FPPopoverView.h"
#import "ARCMacros.h"
#import "SLKBabyPopViewController.h"
#import "SLKAddBabyCell.h"
#import "SLKAlertWithBlock.h"
#import <Parse/Parse.h>
#import "SLKAppDelegate.h"

@interface SLKBabyListTableViewController ()

@end

@implementation SLKBabyListTableViewController
{
    FPPopoverController *popover;
    Baby *currentBaby;
    NSArray *babyArray;
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

-(void)viewWillAppear:(BOOL)animated
{
   
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addBaby:)
                                                 name:@"addBaby"
                                               object:nil];
    
    currentBaby = [[SLKBabyStorage sharedStorage]getCurrentBaby];
    
    NSLog(@"did user default work? name: %@", currentBaby.name);
    
    babyArray = [[SLKBabyStorage sharedStorage] babyArray];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)   return [[[SLKBabyStorage sharedStorage] babyArray] count];
    
     else  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        
        static NSString *CellIdentifier = @"babyListCell";
        SLKBabyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        Baby *babe = [[[SLKBabyStorage sharedStorage] babyArray] objectAtIndex:indexPath.row];
       
        
        if ([babe.babyId isEqualToString:currentBaby.babyId]) {
            [cell.babyNameLabel setTextColor:[UIColor redColor]];
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            [cell setSelected:YES];
             checkedIndexPath = indexPath;
        }
         cell.babyNameLabel.text = babe.name;
        return cell;
    } else
    {
        static NSString *CellIdentifier = @"addBabyCell";
        SLKAddBabyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.addBabuLabel setTextColor:[UIColor blackColor]];
        cell.addBabuLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0f];
        cell.addBabuLabel.text =@"Add a new baby";
    
        return cell;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"Choose what baby to report on:";
    } else{
        return @"Choose other things";
    }
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        SLKBabyPopViewController *controller = [[SLKBabyPopViewController alloc] init];
        
        popover = [[FPPopoverController alloc] initWithViewController:controller];
        
        popover.tint = FPPopoverDefaultTint;
        [popover setAlpha:0.8];
        popover.arrowDirection = FPPopoverNoArrow;
        popover.border = NO;
        popover.contentSize = CGSizeMake(320, 115);
       
        [popover presentPopoverFromPoint:CGPointMake(70, 70)];
        
        } else {
        SLKAlertWithBlock *alert = [[SLKAlertWithBlock alloc] initWithTitle:@"Switch baby" message:@"Are you sure you wanna switch baby?" completion:^(BOOL cancelled, NSInteger buttonIndex) {
             if (buttonIndex == 1) {
                 
                NSLog(@"button index yes");
                [[SLKBabyStorage sharedStorage] setCurrentBaby:[babyArray objectAtIndex:indexPath.row]];
              
                 if(checkedIndexPath)
                 {
                     UITableViewCell* uncheckCell = [tableView cellForRowAtIndexPath:checkedIndexPath];
                     uncheckCell.accessoryType = UITableViewCellAccessoryNone;
                 
                 }
                 UITableViewCell *acell = [tableView cellForRowAtIndexPath:indexPath];
                 acell.accessoryType = UITableViewCellAccessoryCheckmark;
                 checkedIndexPath = indexPath;
   
                 
             } else {
                     NSLog(@"button index cancel");
             }
            
        } cancelButtonTitle:@"Cancel" otherButtonTitles:@"yes", nil];
            [alert show];
        }
}


#pragma mark notification method

-(void) addBaby:(NSNotification *) notification
{
       NSLog(@"namnet på nya NOTTT: %@", [notification.userInfo allKeys]);
    NSString *newBabyName = [notification.userInfo objectForKey:@"babyName"];
    NSString *babyBirthday = [notification.userInfo objectForKey:@"date"];
    NSLog(@"namnet på nya bebben: %@", newBabyName);
    
    PFObject *babyObject = [PFObject objectWithClassName:@"Baby"];
     [babyObject setObject:newBabyName forKey:@"name"];
//     [babyObject setObject:newBabyName forKey:@"date"];

        //TODO: CHECK FOR INTERNET CONNECTION (REACHABILITY?) AND DECIDE WHAT TO DO WHEN THERE'S NO CONNECTION
        
       [SLKPARSEService postObject:babyObject onSuccess:^(PFObject *object)
    {
           [[SLKBabyStorage sharedStorage] createBabyWithName:[object objectForKey:@"name"]
                                                       babyId:[object objectId]
                                                         date:nil
                                                         type:nil];
          NSLog(@"SUCCEED to create %@",[object objectForKey:@"name"] );
        [popover dismissPopoverAnimated:YES completion:^{

            [self.tableView reloadData];
        }];

        
       } onFailure:^(PFObject *object)
    {
           NSLog(@"FAILED :((( ");
           
           [popover dismissPopoverAnimated:YES completion:^{
               [self.tableView reloadData];
           }];
            
        }];
            //  [[NSNotificationCenter defaultCenter] postNotificationName: @"dismissThePopover" object:nil userInfo:nil]
    
    
}




@end
