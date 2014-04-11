//
//  userInfo.h
//  Converge
//
//  Created by Vyshak Nagappala on 4/10/14.
//  Copyright (c) 2014 Vyshak Nagappala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface userInfo : NSObject

+(id)userInfo;
-(void) setInfo:(id<FBGraphUser>) data;
-(id<FBGraphUser>) getInfo;

@end
