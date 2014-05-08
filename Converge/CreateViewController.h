//
//  CreateViewController.h
//  Converge
//
//  Created by Vyshak Nagappala on 4/10/14.
//  Copyright (c) 2014 Vyshak Nagappala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userInfo.h"

@interface CreateViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *eventTitle;
@property (strong, nonatomic) IBOutlet UITextField *eventLocation;
- (IBAction)createButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *eventStart;
- (IBAction)eventStartSelection:(id)sender;
- (IBAction)eventStartSelectionEnd:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *eventEnd;
- (IBAction)eventEndSelection:(id)sender;
- (IBAction)eventEndSelectionEnd:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *eventDescription;
@property (strong, nonatomic) NSDate * eventStartDate;
@property (strong, nonatomic) NSDate * eventEndDate;
- (void)FBLogout:(UIButton *) sender;

@end
