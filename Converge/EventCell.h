//
//  EventCell.h
//  Converge
//
//  Created by Kevin Hsiung on 4/30/14.
//  Copyright (c) 2014 Vyshak Nagappala. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
//@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
//- (IBAction)acceptTouchUp:(id)sender;
//@property (weak, nonatomic) IBOutlet UIButton *declineButton;
//- (IBAction)declineTouchUp:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;

@end
