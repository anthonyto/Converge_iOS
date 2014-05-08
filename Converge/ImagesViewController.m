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
    footerView * footie;
    NSMutableArray * pictures;
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
    pictures = [[NSMutableArray alloc] init];
    [self.scrollView setScrollEnabled:YES];
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.scrollView setContentSize:CGSizeMake(320, 1000)];
    self.view.backgroundColor = [UIColor colorWithRed:90/255.0 green:194/255.0 blue:215/255.0 alpha:1];
    [self navigationItem].title = self.event.name;

    self.descriptionView.editable = NO;
    self.descriptionView.backgroundColor = [UIColor clearColor];
    self.descriptionView.contentInset = UIEdgeInsetsZero;
    /*CGFloat topCorrect = ([self.descriptionView bounds].size.height - [self.descriptionView contentSize].height*[self.descriptionView zoomScale]/2.0);
    topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect;
    self.descriptionView.contentOffset = CGPointMake(0, -topCorrect);*/
    self.automaticallyAdjustsScrollViewInsets = NO;

    footie = [[footerView alloc] initWithFrame:CGRectMake(0, 520, 320, 50)];
    //footie.loginName = [[userInfo userInfo] getInfo].name;
    [self.view addSubview:footie];
    [footie.logout addTarget:self action:@selector(FBLogout:) forControlEvents:UIControlEventTouchUpInside];
    footie.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    
    self.StartTime.text = self.event.start;
    self.EndTime.text = self.event.start;
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
    NSArray *data = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    if(error || [data count] > 1){
        // Unnecessary duplication but I'm tired
        [[[UIAlertView alloc] initWithTitle:@"Unable to retrieve event info"
                                    message:@"Sorry :("
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    NSDictionary * info = [[data objectAtIndex:0] objectForKey:@"event"];
    NSArray * piclist = [info objectForKey:@"pictures"];
    for(int i = 0; i < piclist.count; i++){
        NSDictionary * curr = [piclist objectAtIndex:i];
        [pictures addObject:[[curr objectForKey:@"picture"] objectForKey:@"url" ]];
    }
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
- (void)FBLogout:(UIButton *) sender{
    if(FBSession.activeSession.isOpen){
        [FBSession.activeSession closeAndClearTokenInformation];
        LoginUIViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"loginUIView"];
        [self presentViewController:login animated:YES completion:nil];
        
    }
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
@end
