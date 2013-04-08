//
//  SLKWelcomeCell.m
//  SKAP
//
//  Created by Åsa Persson on 2013-04-08.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKWelcomeCell.h"

@implementation SLKWelcomeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    _welcomeLabel.text = @"Welcome! this is the first time you use baby feed. Tap on screen to register as a parent figure and start using the app. Enjoy!";
}

@end
