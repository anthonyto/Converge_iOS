//
//  footerView.m
//  Converge
//
//  Created by Vyshak Nagappala on 4/29/14.
//  Copyright (c) 2014 Vyshak Nagappala. All rights reserved.
//

#import "footerView.h"
#import "userInfo.h"

@interface footerView (){
    NSString * font;
}

@end

@implementation footerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        font = @"Raleway-Light";
        /*UIColor *iosGray = [UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1];
        UITextField *userName = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        userName.text = [[userInfo userInfo] getInfo].name;
        userName.font = [UIFont systemFontOfSize:10];
        userName.placeholder = @"login name";
        userName.backgroundColor = iosGray;
        userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        userName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        userName.textAlignment = NSTextAlignmentCenter;*/
        UILabel * username = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 50)];
        username.text = [NSString stringWithFormat:@" %@", [[userInfo userInfo] getInfo].name];
        username.font = [UIFont fontWithName:font size:20];
        username.textColor = [UIColor whiteColor];
        //username.backgroundColor = [UIColor redColor];
        username.textAlignment = NSTextAlignmentLeft;
        //userName.backgroundColor = [UIColor blackColor];
        [self addSubview:username];
        //self.backgroundColor = [UIColor blackColor];
        self.logout = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.logout.frame = CGRectMake(240, 0, 70, 50);
        //self.logout.backgroundColor = [UIColor blueColor];
        [self.logout setTitle:@"Logout" forState:UIControlStateNormal];
        self.logout.titleLabel.font = [UIFont fontWithName:font size:20];
        self.logout.titleLabel.textColor = [UIColor whiteColor];
        //self.logout.backgroundColor = [UIColor redColor];
        [self addSubview:self.logout];
        //[self.logout addTarget:self action:@selector(FBLogout:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

/*- (void)FBLogout:(UIButton *) sender{
    if(FBSession.activeSession.isOpen){
        [FBSession.activeSession closeAndClearTokenInformation];
        //[];
    }
}*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
