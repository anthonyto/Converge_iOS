//
//  HomeViewController.m
//  Converge
//
//  Created by Vyshak Nagappala on 4/10/14.
//  Copyright (c) 2014 Vyshak Nagappala. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController (){
    NSMutableData * eventList;
    NSMutableArray * events;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    eventList = [[NSMutableData alloc] init];
    events = [[NSMutableArray alloc] init];
    // begin getting data from the server
    [self getEventsJSON];
}

- (void) getEventsJSON {
    NSURL *url = [[NSURL alloc] initWithString:@"http://converge-rails.herokuapp.com/api/events"];
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
    return events.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"listIdentifier";
    
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[EventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", ((Event *)[events objectAtIndex:indexPath.row]).name];
    cell.startLabel.text = [NSString stringWithFormat:@"%@", ((Event *)[events objectAtIndex:indexPath.row]).start];
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
            NSLog(@"Event: %@", currE.name);
        }
    }
    [connection cancel];
    [self.eventsTable reloadData];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error During Connection: %@", [error description]);
}
@end
