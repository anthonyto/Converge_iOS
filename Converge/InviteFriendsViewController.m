//
//  InviteFriendsViewController.m
//  Converge
//
//  Created by Vyshak Nagappala on 5/8/14.
//  Copyright (c) 2014 Vyshak Nagappala. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FriendCell.h"

@interface InviteFriendsViewController  (){
    NSArray * friends;
    NSMutableDictionary *InvitedFriends;
    NSInteger *numFriendsInvited;
}

@end

@implementation InviteFriendsViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    friends = [[NSArray alloc] init];
	FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        friends = [result objectForKey:@"data"];
        [self.friendsTable reloadData];
    }];
    
    numFriendsInvited = 0;
    InvitedFriends = [[NSMutableDictionary alloc] init];
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    FriendCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[FriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[friends objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.friendSelected = NO;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSObject * temp = [friends objectAtIndex:indexPath.row];
    FriendCell * cell = (FriendCell *)[self.friendsTable cellForRowAtIndexPath:indexPath];
    if(cell.friendSelected == YES){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        cell.friendSelected = NO;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [InvitedFriends removeObjectForKey:[NSString stringWithFormat:@"%d", indexPath.row]];
        
    }
    else{
        cell.friendSelected = YES;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        [InvitedFriends setObject:temp forKey:[NSString stringWithFormat:@"%d", indexPath.row]];
    }
    numFriendsInvited++;
    return;
}


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
//}




@end
