//
//  LoginUIViewController.m
//  Converge
//
//  Created by Vyshak Nagappala on 3/30/14.
//  Copyright (c) 2014 Vyshak Nagappala. All rights reserved.
//

#import "LoginUIViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "userInfo.h"

@interface LoginUIViewController ()

//@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
//@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
//@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;

@end

@implementation LoginUIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        
    }
    return self;
}



- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    if(user == [[userInfo userInfo] getInfo]){ return; }
    [[userInfo userInfo] setInfo:user];
    //self performSegueWithIdentifier:@"homeSegue" sender:self];
    HomeViewController *hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"homeNavigation"];
    [self presentViewController:hvc animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:90/255.0 green:194/255.0 blue:215/255.0 alpha:1];
    self.FBloginButton.readPermissions = @[@"basic_info", @"user_friends"];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
