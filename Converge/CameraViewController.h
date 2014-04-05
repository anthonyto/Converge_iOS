//
//  CameraViewController.h
//  Converge
//
//  Created by Vyshak Nagappala on 4/3/14.
//  Copyright (c) 2014 Vyshak Nagappala. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)takePhoto:(UIButton *)sender;

- (IBAction)selectPhoto:(UIButton *)sender;


@end
