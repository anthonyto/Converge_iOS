//
//  CreateViewController.m
//  Converge
//
//  Created by Vyshak Nagappala on 4/10/14.
//  Copyright (c) 2014 Vyshak Nagappala. All rights reserved.
//

#import "CreateViewController.h"
#import "footerView.h"
#import "LoginUIViewController.h"

@interface CreateViewController (){
    NSData * data;
    BOOL eventStartSelected;
    BOOL eventEndSelected;
    UIToolbar * dateInputDone;
    UIDatePicker * dateInput;
    UIColor * iosGray;
    NSMutableData * currData;
    footerView *footie;
    CGFloat tvx;
    CGFloat tvy;
    CGFloat tvw;
    CGFloat tvh;
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
    NSString * font = @"Raleway-Light";
    iosGray = [UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1];
    self.view.backgroundColor = [UIColor colorWithRed:90/255.0 green:194/255.0 blue:215/255.0 alpha:1];
    eventStartSelected = false;
    eventEndSelected = false;
    
    dateInput = [[UIDatePicker alloc] init];
    [dateInput setDatePickerMode:UIDatePickerModeDateAndTime];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(exitDateInput:)];
    UIBarButtonItem *paddingLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *paddingRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    dateInputDone = [[UIToolbar alloc] initWithFrame:CGRectMake(10.0, 0.0, 310.0, 40.0)];
    [dateInputDone setItems:@[paddingLeft, doneButton, paddingRight]];
    
    self.eventStart.inputView = dateInput;
    self.eventStart.inputAccessoryView = dateInputDone;
    self.eventEnd.inputView = dateInput;
    self.eventEnd.inputAccessoryView = dateInputDone;
	
    self.eventDescription.layer.borderColor = [iosGray CGColor];
    self.eventDescription.layer.borderWidth = 1.0;
    self.eventDescription.layer.cornerRadius = 8;
    self.eventDescription.inputAccessoryView = dateInputDone;
    
    self.eventTitle.delegate = self;
    self.eventLocation.delegate = self;
    self.eventDescription.delegate = self;
    
    tvx = self.eventDescription.frame.origin.x;
    tvy = self.eventDescription.frame.origin.y;
    tvw = self.eventDescription.frame.size.width;
    tvh = self.eventDescription.frame.size.height;
    
    footie = [[footerView alloc] initWithFrame:CGRectMake(0, 520, 320, 50)];
    //footie.loginName = [[userInfo userInfo] getInfo].name;
    [self.view addSubview:footie];
    [footie.logout addTarget:self action:@selector(FBLogout:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void) exitDateInput:(id) sender{
    if(eventStartSelected){
        //NSLog(dateInput.date);
        self.eventStartDate = dateInput.date;
        [self.eventStart setText:[NSDateFormatter localizedStringFromDate:dateInput.date
            dateStyle:NSDateFormatterShortStyle
            timeStyle:NSDateFormatterShortStyle]];
        [self.eventStart resignFirstResponder];
    } else if (eventEndSelected){
        self.eventEndDate = dateInput.date;
        [self.eventEnd setText:[NSDateFormatter localizedStringFromDate:dateInput.date
            dateStyle:NSDateFormatterShortStyle
            timeStyle:NSDateFormatterShortStyle]];
        [self.eventEnd resignFirstResponder];
    } else {
        [self.eventDescription resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) isValidEvent{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if([[formatter dateFromString:self.eventStart.text] compare:[formatter dateFromString:self.eventEnd.text]] == NSOrderedDescending){
        
        return NO;
    }
        
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (NSString *) urlEncode:(NSString *) str{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)str,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 ));
}

- (IBAction)createButton:(id)sender {
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy'-'MM'-'dd'T'HH:mm:ss.SSS'Z'"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSString * et = [self urlEncode:self.eventTitle.text];
    NSString * el = [self urlEncode:self.eventLocation.text ];
    NSString * es = [self urlEncode:[formatter stringFromDate:self.eventStartDate]];
    NSString * ee = [self urlEncode:[formatter stringFromDate:self.eventEndDate]];
    NSString * ed = [self urlEncode:self.eventDescription.text];
    NSString * queryString = [NSString stringWithFormat: @"event%%5Bname%%5D=%@&event%%5Blocation%%5D=%@&event%%5Bstart_time%%5D=%@&event%%5Bend_time%%5D=%@&event%%5Bdescription%%5D=%@&event%%5Buid%%5D=%@", et, el, es, ee, ed,  [[userInfo userInfo] getInfo].id];
    
    /*NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)queryString,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 ));*/
    if(self.eventStart.text.length==0 || self.eventEnd.text.length==0 || self.eventDescription.text.length==0 || self.eventLocation.text.length==0 || self.eventTitle.text.length==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"One or more fields are empty."
                                                        message:@"Please enter all fields."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if([self isValidEvent]){
        data = [queryString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Event times invalid."
                                                        message:@"Your start time must be before the end time."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[data length]];
    NSURL *url = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"http://converge-rails.herokuapp.com/api/users/%@/events", [[userInfo userInfo] getInfo].id]];
    //NSURL *url = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"http://d4dcccf.ngrok.com/api/users/%@/events", [[userInfo userInfo] getInfo].id]];
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
    if(!str || [str length] <= 0 || [str rangeOfString:@"work"].location == NSNotFound){
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

- (IBAction)eventStartSelection:(id)sender {
    eventStartSelected = true;
}

- (IBAction)eventStartSelectionEnd:(id)sender {
    eventStartSelected = false;
}
- (IBAction)eventEndSelection:(id)sender {
    eventEndSelected = true;
}

- (IBAction)eventEndSelectionEnd:(id)sender {
    eventEndSelected = false;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Description"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    textView.frame = CGRectMake(10, 65, 300, 230);
    [textView becomeFirstResponder];
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Description";
        textView.textColor = iosGray; //optional
    }
    textView.frame = CGRectMake(tvx, tvy, tvw, tvh);
    [textView resignFirstResponder];
}

- (void)FBLogout:(UIButton *) sender{
    if(FBSession.activeSession.isOpen){
        [FBSession.activeSession closeAndClearTokenInformation];
        LoginUIViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"loginUIView"];
        [self presentViewController:login animated:YES completion:nil];
       
    }
}
@end
