//
//  SLKTabbar.m
//  SKAP
//
//  Created by Åsa Persson on 2013-04-29.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import "SLKTabbar.h"

@implementation SLKTabbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.tintColor = [UIColor redColor];
}


@end
