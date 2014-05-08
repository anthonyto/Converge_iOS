//
//  ImagesViewController.m
//  Converge
//
//  Created by Anthony To on 5/5/14.
//  Copyright (c) 2014 Vyshak Nagappala. All rights reserved.
//

#import "Picture.h"
#import "ImagesViewController.h"

@interface ImagesViewController (){
  NSMutableData * responseData;
}

@end

@implementation ImagesViewController

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
    self.view.backgroundColor = [UIColor colorWithRed:90/255.0 green:194/255.0 blue:215/255.0 alpha:1];
    [self navigationItem].title = self.event.name;

    self.descriptionView.editable = NO;
    self.descriptionView.backgroundColor = [UIColor clearColor];
    self.descriptionView.contentInset = UIEdgeInsetsZero;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.StartTime.text = [NSString stringWithFormat:@"Start: %@", self.event.start];
    self.EndTime.text = [NSString stringWithFormat:@"End: %@", self.event.start];
    // Open API call to get array of image urls
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://converge-rails.herokuapp.com/api/users/%@/events/%@", [[userInfo userInfo] getInfo].id, self.event.eventid]];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    self.descriptionView.text = self.event.description;
    [connection start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NSURLConnection Delegate Methods
 
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    responseData = [[NSMutableData alloc] init];
}
 
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
	[responseData appendData:data];
}
 
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection 
    return nil;
}
 
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
	
	  NSError *error = nil;
	  NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
		NSLog(data);
	  [connection cancel];
    
}
 
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    [[[UIAlertView alloc] initWithTitle:@"Unable to retrieve event info"
                                message:@"Sorry :("
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
