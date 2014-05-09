//
//  HomeViewController.m
//  Converge
//
//  Created by Vyshak Nagappala on 4/10/14.
//  Copyright (c) 2014 Vyshak Nagappala. All rights reserved.
//

#import "HomeViewController.h"
#import "footerView.h"
#import "LoginUIViewController.h"

@interface HomeViewController (){
    NSMutableData * eventList;
    NSMutableArray * events;
    UIActivityIndicatorView * spin;
    NSString * font;
    footerView *footie;
    BOOL emptyList;
    NSString * currEventId;
    NSString * currEventTitle;
    Event * currEventParam;
}

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
   //[self getEventsJSON];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    font = @"Raleway-Light";
    eventList = [[NSMutableData alloc] init];
    events = [[NSMutableArray alloc] init];
    emptyList = true;
    // begin getting data from the server
    self.eventsTable.layer.cornerRadius = 10;
    self.eventsTable.contentInset = UIEdgeInsetsZero;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.createButton.titleLabel.font = [UIFont fontWithName:font size:self.createButton.titleLabel.font.pointSize];
    
    NSDictionary * navSettings = @{
                                   UITextAttributeFont: [UIFont fontWithName:@"Raleway-Light" size:24.0],
                                   UITextAttributeTextColor: [UIColor whiteColor]
    };
    
    self.navigationController.navigationBar.titleTextAttributes = navSettings;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.view.backgroundColor = [UIColor colorWithRed:90/255.0 green:194/255.0 blue:215/255.0 alpha:1];
    spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spin setColor: [UIColor grayColor]];
    spin.center = CGPointMake(160,240);
    spin.hidesWhenStopped = YES;
    [self.view addSubview:spin];
    [self getEventsJSON];
    footie = [[footerView alloc] initWithFrame:CGRectMake(0, 520, 320, 50)];
    //footie.loginName = [[userInfo userInfo] getInfo].name;
    [self.view addSubview:footie];
    [footie.logout addTarget:self action:@selector(FBLogout:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void) getEventsJSON {
    [spin startAnimating];
    NSURL *url = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"http://converge-rails.herokuapp.com/api/users/%@/events", [[userInfo userInfo] getInfo].id] ];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    [connection start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createButton:(id)sender {
    [self performSegueWithIdentifier:@"createSegue" sender:self];
}

- (IBAction)refreshEvents:(id)sender {
    events = [[NSMutableArray alloc] init];
    [self getEventsJSON];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return events.count > 0 ? events.count : 2;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //Event * currEvent = ((Event *)[events objectAtIndex:indexPath.row]);
    //currEventId = currEvent.eventid;
    //currEventTitle = currEvent.name;
    currEventParam = ((Event *)[events objectAtIndex:indexPath.row]);
    [self performSegueWithIdentifier:@"eventViewSegue" sender:self];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"listIdentifier";
    if(emptyList){
        if(indexPath.row == 0){
            cellIdentifier = @"blankIdentifier";
            UITableViewCell * bc = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(bc == nil){
                bc = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            return bc;
        } else {
            cellIdentifier = @"noResultsIdentifier";
            NoResultsCell*  nrsc = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(nrsc == nil){
                nrsc = [[NoResultsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            nrsc.messageLabel.text = @"No Events :(";
            nrsc.messageLabel.font = [UIFont fontWithName:font size:20];
            return nrsc;
        }
    }
    
    
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[EventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Event * currE = ((Event *)[events objectAtIndex:indexPath.row]);
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", currE.name];
    cell.startLabel.text = [NSString stringWithFormat:@"%@", currE.start];
    cell.titleLabel.font = [UIFont fontWithName:font size:cell.titleLabel.font.pointSize];
    cell.startLabel.font = [UIFont fontWithName:font size:cell.startLabel.font.pointSize];
    cell.acceptButton.titleLabel.font = [UIFont fontWithName:font size:15.0];
    cell.declineButton.titleLabel.font = [UIFont fontWithName:font size:15.0];
    return cell;
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [eventList setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [eventList appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *error = nil;
    NSArray*data = [NSJSONSerialization JSONObjectWithData:eventList options:NSJSONReadingAllowFragments error:&error];
    if(!data){
        NSLog(@"Error parsing JSON");
    } else {
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: @"yyyy'-'MM'-'dd'T'HH:mm:ss.SSS'Z'"];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        for(NSDictionary * curr in data){
            NSDictionary * info = [curr objectForKey:@"event"];
            Event * currE = [[Event alloc] init];
            currE.eventid = [info objectForKey:@"id"];
            currE.name = [info objectForKey:@"name"];
            currE.location = [info objectForKey:@"location"];
            currE.start = [info objectForKey:@"start_time"];
            currE.end = [info objectForKey:@"end_time"];
            currE.description = [info objectForKey:@"description"];
            [events addObject:currE];
            if([currE.start isEqual: [NSNull null]]){
                currE.start = @"blank";
            } else {
                currE.start = [NSDateFormatter localizedStringFromDate:[formatter dateFromString:currE.start] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
            }
            if([currE.end isEqual: [NSNull null]]){
                currE.end = @"blank";
            } else {
                currE.end = [NSDateFormatter localizedStringFromDate:[formatter dateFromString:currE.end] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
            }
            //NSLog(@"Event: %@", currE.name);
        }
    }
    if([events count] == 0){
        emptyList = true;
    } else {
        emptyList = false;
    }
    [connection cancel];
    [spin stopAnimating];
    [self.eventsTable reloadData];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //NSLog(@"Error During Connection: %@", [error description]);
    [spin stopAnimating];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Retrieve Events"
                                                    message:@"Hit refresh to try again"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

}

- (void)FBLogout:(UIButton *) sender{
    if(FBSession.activeSession.isOpen){
        [FBSession.activeSession closeAndClearTokenInformation];
        LoginUIViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"loginUIView"];
        [self presentViewController:login animated:YES completion:nil];
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"eventViewSegue"]){
        ImagesViewController * next = [segue destinationViewController];
        //next.eventId = currEventId;
        //next.eventTitle = currEventTitle;
        next.event = currEventParam;
    }
}
@end
