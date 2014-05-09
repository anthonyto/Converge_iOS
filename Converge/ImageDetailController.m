//
//  ImageDetailController.m
//  Converge
//
//  Created by Vyshak Nagappala on 5/9/14.
//  Copyright (c) 2014 Vyshak Nagappala. All rights reserved.
//

#import "ImageDetailController.h"

@interface ImageDetailController ()

@end

@implementation ImageDetailController

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
    self.view.backgroundColor= [UIColor blackColor];
    self.image.contentMode = UIViewContentModeScaleAspectFit;
    //[self.image setImage: self.param.image];
    self.image.image = self.param.image;

    //[self.image setImage:self.param.image ];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
