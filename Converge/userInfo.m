//
//  userInfo.m
//  Converge
//
//  Created by Vyshak Nagappala on 4/10/14.
//  Copyright (c) 2014 Vyshak Nagappala. All rights reserved.
//

#import "userInfo.h"

@implementation userInfo{
    id<FBGraphUser> info;
}

-(id) init {
    self = [super init];
    return self;
}

+(id) userInfo{
    
    static userInfo *info = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        info = [[self alloc] init];
    });
    return info;
    
}

-(void) setInfo:(id<FBGraphUser>) data {
    info = data;
}

-(id<FBGraphUser>) getInfo {
    return info;
}
@end