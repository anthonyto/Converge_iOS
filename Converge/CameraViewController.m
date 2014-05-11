//
//  CameraViewController.m
//  Converge
//
//  Created by Vyshak Nagappala on 4/3/14.
//  Copyright (c) 2014 Vyshak Nagappala. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController (){
    NSMutableData * currData;
    UIActivityIndicatorView * spin;
    UIImagePickerController * currPicker;
    UIButton * select;
    UIButton * capture;
}

@end

@implementation CameraViewController

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
    //self.view.backgroundColor = [UIColor colorWithRed:90/255.0 green:194/255.0 blue:215/255.0 alpha:1];
    self.view.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    //NSLog(@"Event: %@", self.eventid);
	// Do any additional setup after loading the view.
    self.uploadButton.hidden = YES;
    
    spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spin.center = CGPointMake(160,240);
    spin.hidesWhenStopped = YES;
    [self.view addSubview:spin];
    
    UIButton * cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 488, 80, 80)];
    [cameraButton setBackgroundImage:[UIImage imageNamed:@"capture.png"] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(capturePicture) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * selectButton = [[UIButton alloc] initWithFrame:CGRectMake(240,488, 80,80)];
    [selectButton setBackgroundImage:[UIImage imageNamed:@"upload_button.png" ] forState:UIControlStateNormal];
    [selectButton addTarget:self action:@selector(switchToUpload) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame = CGRectMake(0, 520, 70, 25);
//    cancelButton.titleLabel.text = @"Cancel
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelCamera) forControlEvents:UIControlEventTouchUpInside];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    [picker.view addSubview:selectButton];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [picker.view addSubview:cameraButton];
    [picker.view addSubview: cancelButton];
    picker.showsCameraControls= NO;
    select = selectButton;
    capture = cameraButton;
    currPicker = picker;
    
    [self presentViewController:picker animated:NO completion:NULL];
}

- (void) cancelCamera {
    [currPicker dismissViewControllerAnimated:NO completion:NULL];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) capturePicture {
    //iselect.hidden = YES;
    [currPicker takePicture];
}

- (void) postImage {
    // Dictionary that holds post parameters. You can set your post parameters that your server accepts or programmed to accept.
    [spin startAnimating];
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:@"1.0" forKey:@"ver"];
    [_params setObject:@"en" forKey:@"lan"];
    [_params setObject:[NSString stringWithFormat:@"%@", [[userInfo userInfo] getInfo].id] forKey:@"picture[uid]"];
    [_params setObject:[NSString stringWithFormat:@"%@",self.eventid] forKey:@"picture[event_id]"];
    
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    
    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differß
    NSString* FileParamConstant = @"picture[image]";
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://converge-rails.herokuapp.com/api/users/%@/events/%@/pictures", [[userInfo userInfo] getInfo].id, self.eventid]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in _params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 1.0);
    uint8_t c;
    [imageData getBytes:&c length:1];
    
    //NSString * imgMME = @"Content-Type: image/jpeg\r\n\r\n";
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        /*[body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];*/
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:requestURL];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhoto:(UIButton *)sender {
    
    /*UIButton * selectButton = [[UIButton alloc] initWithFrame:CGRectMake(220, 470, 100,100)];
    [selectButton setBackgroundImage:[UIImage imageNamed:@"upload_button.png" ] forState:UIControlStateNormal];
    [selectButton addTarget:self action:@selector(switchToUpload) forControlEvents:UIControlEventTouchUpInside];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [picker.view addSubview:selectButton];
    currPicker = pick*/
    
    [self presentViewController:currPicker animated:YES completion:NULL];
}

- (void) switchToUpload {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [currPicker dismissViewControllerAnimated:NO completion:NULL];
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)selectPhoto:(UIButton *)sender {
    [self switchToUpload];
    /*UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //[picker.view addSubview:self.selectButton];
    [self presentViewController:picker animated:YES completion:NULL];*/
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = chosenImage;
    self.uploadButton.hidden = NO;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:NO completion:NULL];
    if(picker.sourceType != UIImagePickerControllerSourceTypeCamera){
        [self presentViewController:currPicker animated:YES completion:NULL];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)uploadButton:(id)sender {
    [self postImage];
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
    [spin stopAnimating];
    [connection cancel];
    if(!str || [str length] <= 0 || [str rangeOfString:@"work"].location == NSNotFound){
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Unable to Upload image."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else {
        // good stuff.
        [self.navigationController popViewControllerAnimated:YES];
    }
    /*    NSString *responseText = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
     
     // Do anything you want with it
     
     [responseText release];*/
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([[segue identifier] isEqualToString:@"eventViewSegue"]){
        //ImagesViewController * next = [segue destinationViewController];
        //next.eventId = currEventId;
        //next.eventTitle = currEventTitle;
        //next.event = currEventParam;
    }
}

@end
