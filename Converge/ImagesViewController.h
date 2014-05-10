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
#import "AsyncImageView.h"
#import "QuartzCore/QuartzCore.h"
#import "CameraViewController.h"
#import "ImageDetailController.h"
#import "InviteFriendsViewController.h"

@interface ImagesViewController : UIViewController <UICollectionViewDataSource>
{
	
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) Event * event;
@property (weak, nonatomic) IBOutlet UITextView *descriptionView;
@property (weak, nonatomic) IBOutlet UILabel *StartTime;
@property (weak, nonatomic) IBOutlet UILabel *EndTime;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *noImagesLabel;
- (IBAction)refreshButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end
