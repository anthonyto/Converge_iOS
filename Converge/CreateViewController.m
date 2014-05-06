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
    BOOL eventStartSelected;
    BOOL eventEndSelected;
    UIToolbar * dateInputDone;
    UIDatePicker * dateInput;
    UIColor * iosGray;
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
}

-(void) exitDateInput:(id) sender{
    if(eventStartSelected){
        [self.eventStart setText:[NSDateFormatter localizedStringFromDate:dateInput.date
            dateStyle:NSDateFormatterShortStyle
            timeStyle:NSDateFormatterShortStyle]];
        [self.eventStart resignFirstResponder];
    } else if (eventEndSelected){
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
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)createButton:(id)sender {
    
 
    NSString * et = self.eventTitle.text;
    NSString * el = self.eventLocation.text;
    NSString * es = self.eventStart.text;
    NSString * ee = self.eventEnd.text;
    NSString * ed = self.eventDescription.text; //NEED TO ESCAPE CHARACTERS
    NSString * queryString = [NSString stringWithFormat: @"event[name]=%@&event[location]=%@&event[start_time]=%@&event[end_time]=%@&event[description]=%@", et, el, es, ee, ed ];
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)queryString,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 ));
    if([self isValidEvent]){
        data = [queryString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    } else {
        //error
    }
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[data length]];
    
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://converge-rails.herokuapp.com/api/events"];
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
    [textView becomeFirstResponder];
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Description";
        textView.textColor = iosGray; //optional
    }
    [textView resignFirstResponder];
}
@end
