//
//  LoginUIViewController.h
//  Converge
//
//  Created by Vyshak Nagappala on 3/30/14.
//  Copyright (c) 2014 Vyshak Nagappala. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import <UIKit/UIKit.h>
#import "userInfo.h"
#import "HomeViewController.h"

@interface LoginUIViewController : UIViewController<FBLoginViewDelegate>

@property (strong, nonatomic) IBOutlet FBLoginView *FBloginButton;


@end

