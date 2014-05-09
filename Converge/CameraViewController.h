//
//  CameraViewController.h
//  Converge
//
//  Created by Vyshak Nagappala on 4/3/14.
//  Copyright (c) 2014 Vyshak Nagappala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userInfo.h"

@interface CameraViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)takePhoto:(UIButton *)sender;

- (IBAction)selectPhoto:(UIButton *)sender;

@property(strong, nonatomic) NSString * eventid;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
- (IBAction)uploadButton:(id)sender;
@end
