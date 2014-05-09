//
//  InviteFriendsViewController.h
//  Converge
//
//  Created by Vyshak Nagappala on 5/8/14.
//  Copyright (c) 2014 Vyshak Nagappala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userInfo.h"

@interface InviteFriendsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *friendsTable;

- (IBAction)SendInvites:(id)sender;



@end
