//
//  SLKParentListCell.h
//  SKAP
//
//  Created by Åsa Persson on 2013-04-04.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLKParentListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UITextView *numberTextView;

@end
