//
//  CreateViewController.m
//  Converge
//
//  Created by Vyshak Nagappala on 4/10/14.
//  Copyright (c) 2014 Vyshak Nagappala. All rights reserved.
//

#import "CreateViewController.h"

@interface CreateViewController (){
    NSData * data;
}

@end

@implementation CreateViewController

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
    self.eventTitle.delegate = self;
    self.eventLocation.delegate = self;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) isValidEvent{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)createButton:(id)sender {

    NSString * et = self.eventTitle.text;
    NSString * el = self.eventLocation.text;
    NSString * ed = [NSDateFormatter localizedStringFromDate:self.eventDate.date
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    //NSString * queryString = [NSString stringWithFormat:@"name=%@&location=%@&start_time=%@&end_time=%@", et, el, ed, ed ];
    NSString * queryString = @"event[name]=testasdale&event[location]=tomorrow&event[start_time]=z&event[end_time]=b&event[description]=fuck";
    if([self isValidEvent]){
        data = [queryString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    } else {
        //error
    }
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[data length]];
    
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://22271f7b.ngrok.com/api/events"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
/*    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                 message:[error localizedDescription]
                                delegate:nil
                       cancelButtonTitle:NSLocalizedString(@"OK", @"")
                       otherButtonTitles:nil] show];*/
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [connection cancel];
/*    NSString *responseText = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    
    // Do anything you want with it
    
    [responseText release];*/
}

@end
