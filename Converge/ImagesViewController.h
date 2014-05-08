//
//  ImagesViewController.h
//  Converge
//
//  Created by Anthony To on 5/5/14.
//  Copyright (c) 2014 Vyshak Nagappala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userInfo.h"
#import "Event.h"
#import "footerView.h"
#import "LoginUIViewController.h"

@interface ImagesViewController : UIViewController <UICollectionViewDataSource>
{
	
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *pictures;
@property (strong, nonatomic) Event * event;
@property (weak, nonatomic) IBOutlet UITextView *descriptionView;
@property (weak, nonatomic) IBOutlet UILabel *StartTime;
@property (weak, nonatomic) IBOutlet UILabel *EndTime;

@end
