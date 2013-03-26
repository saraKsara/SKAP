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
#import "SLKJSONService.h"
#import "SLKBabyCell.h"
#import "FPPopoverController.h"
#import "FPTouchView.h"
#import "FPPopoverView.h"
#import "ARCMacros.h"
#import "SLKBabyPopViewController.h"
#import "SLKAddBabyCell.h"
#import "SLKAlertWithBlock.h"

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
        popover.contentSize = CGSizeMake(310, 320);
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
    NSString *newBabyName = [notification.userInfo objectForKey:@"babyName"];
    NSString *babyBirthday = [notification.userInfo objectForKey:@"date"];
    
    NSDictionary *toCouchdb = [NSDictionary dictionaryWithObjectsAndKeys:
                               newBabyName, @"name",
                               nil, @"pii",
                               nil, @"poo",
                               nil, @"feedTimespan",
                               nil, @"bottle",
                               nil, @"breast",
//                                 babyBirthday, @"date",nil];
                               nil, @"date",nil];
    
    if ([NSJSONSerialization isValidJSONObject: toCouchdb])
    {
        //TODO: CHECK FOR INTERNET CONNECTION (REACHABILITY?) AND DECIDE WHAT TO DO WHEN THERE'S NO CONNECTION
        NSLog(@"Baby IS JSON valid");
        [SLKJSONService postBaby:toCouchdb onSuccess:^(NSDictionary *successDict) {
            NSLog(@"SUCCESS %@", [successDict valueForKey:@"id"]);
            [[SLKBabyStorage sharedStorage] createBabyWithName:newBabyName
                                                        babyId:[successDict
                                                                valueForKey:@"id"]
                                                          date:nil
                                                          type:nil];

    
            [popover dismissPopoverAnimated:YES completion:^{
                [self.tableView reloadData];
            }];
            
        } onFailure:^(NSDictionary *failDict, NSHTTPURLResponse *resp) {
            
            NSLog(@"FAIL %@", failDict);
            [popover dismissPopoverAnimated:YES completion:^{
                [self.tableView reloadData];
            }];
            
        }];
        
      //  [[NSNotificationCenter defaultCenter] postNotificationName: @"dismissThePopover" object:nil userInfo:nil];
        
    } else {
        NSLog(@"Baby is not valid JSON");
    }
    
    
}




@end
