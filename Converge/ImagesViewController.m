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
    NSString * font;
    UIActivityIndicatorView * spin;
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
-(void) viewWillAppear:(BOOL)animated{
    [self retrieveEventInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    font = @"Raleway-Light";
    pictures = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor colorWithRed:90/255.0 green:194/255.0 blue:215/255.0 alpha:1];
    
    [self.scrollView setScrollEnabled:YES];
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.scrollView setContentSize:CGSizeMake(320, 503)];
    
    spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spin setColor: [UIColor grayColor]];
    spin.center = CGPointMake(160,270);
    spin.hidesWhenStopped = YES;
    [self.view addSubview:spin];
    
    [self navigationItem].title = self.event.name;
    self.noImagesLabel.font = [UIFont fontWithName:font size:self.noImagesLabel.font.pointSize];
    
    //self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    self.descriptionView.editable = NO;
    self.descriptionView.backgroundColor = [UIColor clearColor];
    self.descriptionView.contentInset = UIEdgeInsetsZero;
    self.automaticallyAdjustsScrollViewInsets = NO;

    footie = [[footerView alloc] initWithFrame:CGRectMake(0, 520, 320, 50)];
    //footie.loginName = [[userInfo userInfo] getInfo].name;
    [self.view addSubview:footie];
    [footie.logout addTarget:self action:@selector(FBLogout:) forControlEvents:UIControlEventTouchUpInside];
    footie.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
    
    [self.view bringSubviewToFront:self.cameraButton];
    //self.cameraButton.layer.zPosition = 10;
    self.StartTime.text = self.event.start;
    self.EndTime.text = self.event.start;
    // Open API call to get array of image urls
    //[self retrieveEventInfo];
}

-(void) retrieveEventInfo{
    pictures = [[NSMutableArray alloc] init];
    [spin startAnimating];
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
    if(piclist.count > 0){
        self.noImagesLabel.hidden = YES;
    }
    [self.collectionView reloadData];

    CGFloat collectionPos = self.collectionView.frame.origin.y;
    CGRect cvFrame = self.collectionView.frame;
    cvFrame.size.height = 160* ((pictures.count+1)/2);
    self.collectionView.frame = cvFrame;
    CGFloat newSize = collectionPos + self.collectionView.frame.size.height + 48;
    newSize = newSize < 503 ? 503: newSize;
    [self.scrollView setContentSize:CGSizeMake(320, newSize)];
    [spin stopAnimating];
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
    static NSString * identifier = @"imageCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    AsyncImageView * currImage = (AsyncImageView*)[cell viewWithTag:74];
    currImage.contentMode = UIViewContentModeScaleAspectFill;
    currImage.imageURL = [[NSURL alloc] initWithString: [pictures objectAtIndex:indexPath.row]];
    return cell;
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return pictures.count;
}
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (IBAction)refreshButton:(id)sender {
    [self retrieveEventInfo];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"cameraSegue"]){
        CameraViewController * next = [segue destinationViewController];
        next.eventid = self.event.eventid;
    }
}
@end
