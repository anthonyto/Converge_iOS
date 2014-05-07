//
//  HomeViewController.h
//  Converge
//
//  Created by Vyshak Nagappala on 4/10/14.
//  Copyright (c) 2014 Vyshak Nagappala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "userInfo.h"
#import "Event.h"
#import "EventCell.h"
#import "NoResultsCell.h"

@interface HomeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
- (IBAction)createButton:(id)sender;
- (IBAction)refreshEvents:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UITableView *eventsTable;

@end
