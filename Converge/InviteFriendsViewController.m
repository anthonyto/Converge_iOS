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
    NSMutableData * currData;
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
    self.friendsTable.allowsMultipleSelection = YES;
    
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
    self.sendButton.titleLabel.font = [UIFont fontWithName:@"Raleway-Light" size:20];
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
    cell.textLabel.font = [UIFont fontWithName:@"Raleway-Light" size:cell.textLabel.font.pointSize];
    cell.textLabel.text = [[friends objectAtIndex:indexPath.row] objectForKey:@"name"];
    // Necessary because cells are reused.
    if(![InvitedFriends objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]]){
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
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

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    currData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    //NSString *str = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    [currData appendData:d];
    return;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    /*    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
     message:[error localizedDescription]
     delegate:nil
     cancelButtonTitle:NSLocalizedString(@"OK", @"")
     otherButtonTitles:nil] show];*/
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString * str = [[NSString alloc] initWithData:currData encoding:NSUTF8StringEncoding];
    if(!str || [str length] <= 0){
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Unable to create event."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [connection cancel];
    /*    NSString *responseText = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
     
     // Do anything you want with it
     
     [responseText release];*/
}


- (IBAction)SendInvites:(id)sender {
    if(InvitedFriends.count == 0)
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Invite at least one friend to event."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    
        NSMutableArray *friendQueryString = [[NSMutableArray alloc] init];
    /*for (NSDictionary<FBGraphUser>* friend in InvitedFriends) {
        [temp setValue:[NSString stringWithFormat:@"%@",[friend objectForKey:@"name"]] forKey:@"name"];
        [temp setValue:[NSString stringWithFormat:@"%@",[friend objectForKey:@"id"]] forKey:@"uid"];
        [tempFriend setValue:temp forKey:@"friend"];
        [friendQueryString addObject:tempFriend];
    }*/
    for(NSString * key in InvitedFriends){
        NSMutableDictionary *tempFriend = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];

         FBGraphObject *curr= [InvitedFriends objectForKey:key];
        [temp setValue:[NSString stringWithFormat:@"%@", [curr objectForKey:@"name"]] forKey:@"name"];
        [temp setValue:[NSString stringWithFormat:@"%@", [curr objectForKey:@"id"]] forKey:@"uid"];
        [tempFriend setValue:temp forKey:@"friend"];
        [friendQueryString addObject:tempFriend];
    }
    /*NSString * tmp = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:friendQueryString options:1 error:nil] encoding:NSUTF8StringEncoding];
    return;*/
    NSError * e;
    NSData * data = [NSJSONSerialization dataWithJSONObject:friendQueryString options:kNilOptions error:&e];
    //NSString * js = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", js);
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[data length]];
    NSURL *url = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"http://converge-rails.herokuapp.com/api/users/%@/events", [[userInfo userInfo] getInfo].id]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
}

- (NSString *) urlEncode:(NSString *) str{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)str,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 ));
}
@end

