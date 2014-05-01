//
//  Event.h
//  Converge
//
//  Created by Kevin Hsiung on 4/30/14.
//  Copyright (c) 2014 Vyshak Nagappala. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (strong, nonatomic) NSString * eventid;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * location;
@property (strong, nonatomic) NSString * start;
@property (strong, nonatomic) NSString * end;
@property (strong, nonatomic) NSString * description;

@end
