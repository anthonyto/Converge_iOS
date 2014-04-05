//
//  LoginUIViewController.h
//  Converge
//
//  Created by Vyshak Nagappala on 3/30/14.
//  Copyright (c) 2014 Vyshak Nagappala. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import <UIKit/UIKit.h>

@interface LoginUIViewController : UIViewController<FBLoginViewDelegate>
{
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *statusLabel;
    IBOutlet FBProfilePictureView *profilePictureView;


    
}

@end
