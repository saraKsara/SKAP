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
#import "SLKPopOverViewController.h"
@interface SLKBabyListTableViewController ()

@end

@implementation SLKBabyListTableViewController
{
    UIView *aNewBabyPopover;
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

//- (IBAction)addBaby:(id)sender {
//    
//    NSDictionary *toCouchdb = [NSDictionary dictionaryWithObjectsAndKeys:
//                               _babyNameTextField.text, @"name",
//                               nil, @"pii",
//                               nil, @"poo",
//                               nil, @"feedTimespan",
//                               nil, @"bottle",
//                               nil, @"breast",
//                               nil, @"date",nil];
//    
//    if ([NSJSONSerialization isValidJSONObject: toCouchdb])
//    {
//        //TODO: CHECK FOR INTERNET CONNECTION (REACHABILITY?) AND DECIDE WHAT TO DO WHEN THERE'S NO CONNECTION
//        NSLog(@"Baby IS JSON valid");
//        [SLKJSONService postBaby:toCouchdb onSuccess:^(NSDictionary *successDict) {
//            NSLog(@"SUCCESS %@", [successDict valueForKey:@"id"]);
//            [[SLKBabyStorage sharedStorage] createBabyWithName: _babyNameTextField.text
//                                                        babyId:[successDict valueForKey:@"id"]
//                                                           pii:nil
//                                                           poo:nil
//                                                  feedTimespan:nil
//                                                        bottle:nil
//                                                        breast:nil
//                                                          date:nil];
//            
//        } onFailure:^(NSDictionary *failDict, NSHTTPURLResponse *resp) {
//            
//            NSLog(@"FAIL %@", failDict);
//            
//        }];
//        
//    } else {
//        NSLog(@"Baby is not valid JSON");
//    }
//    
//    
//}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)   return [[[SLKBabyStorage sharedStorage] babyArray] count];
    
     else  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"babyListCell";
    SLKBabyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    
    if (indexPath.section == 0)
    {
       cell.babyNameLabel.text =@"bäbis som finns";
        
                   return cell;
    } else if (indexPath.section == 1)
    {
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        [cell.babyNameLabel setTextColor:[UIColor blackColor]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
         cell.babyNameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:23.0f];
        cell.babyNameLabel.text =@"Add a new baby";
        
        return cell;
    }
   
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        
        CGRect arect = [tableView rectForRowAtIndexPath:indexPath];
        
    
        // Create a new ImageViewController and set its image
//        ImageViewController *ivc = [[ImageViewController alloc] init];
//        [ivc setImage:img];
        SLKPopOverViewController *popOverView = [[SLKPopOverViewController alloc] init];
        
        _popover = [[UIPopoverController alloc] initWithContentViewController:popOverView];
        [_popover setDelegate:self];
        [_popover setPopoverContentSize:CGSizeMake(300, 200)];
        
        [_popover presentPopoverFromRect:arect
                                      inView:[self view]
                    permittedArrowDirections:UIPopoverArrowDirectionAny
                                    animated:YES];
        
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/





@end
