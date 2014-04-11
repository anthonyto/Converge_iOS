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
        
        // Create a FBLoginView to log the user in with basic, email and likes permissions
        // You should ALWAYS ask for basic permissions (basic_info) when logging the user in
        //FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"basic_info", @"email", @"user_likes"]];
        
        // Set this loginUIViewController to be the loginView button's delegate
        //loginView.delegate = self;
        
        // Align the button in the center horizontally
        //loginView.frame = CGRectOffset(loginView.frame,
        //                               (self.view.center.x - (loginView.frame.size.width / 2)),
        //                               5);
        
        // Align the button in the center vertically
        //loginView.center = self.view.center;
        
        // Add the button to the view
        //[self.view addSubview:loginView];
        //UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        
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
    self.FBloginButton.readPermissions = @[@"basic_info"];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
