//
//  SLKPfLoginViewController.h
//  SKAP
//
//  Created by Student vid Yrkeshögskola C3L on 5/1/13.
//  Copyright (c) 2013 Student vid Yrkeshögskola C3L. All rights reserved.
//

#import <Parse/Parse.h>
#import "widespace-4.lib/WSAdSpace.h"


@interface SLKPfLoginViewController : PFLogInViewController<WSAdSpaceDelegate>
{
    WSAdSpace *splashAdView;
}

- (void)loadSplashAd;


@end
