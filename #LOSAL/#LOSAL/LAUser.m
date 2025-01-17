
//
//  LAUser.m
//  #LOSAL
//
//  Created by Joaquin Brown on 8/12/13.
//  Copyright (c) 2013 Localism. All rights reserved.
//

#import "LAUser.h"
#define  DEFAULT_ICON "\uE00C"

@implementation LAUser

- (id)initWithDisplayName:(NSString *)name
           userIconString:(NSString *)icon
            userIconColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        [self setDisplayName:name];
        [self setIconString:icon];
        [self setIconColor:color];
    }
    return self;
}

- (id)init
{
    // set the flag for user verified. 
    [self setUserVerified:NO];
    return [self initWithDisplayName:@"Non-Registered"
                      userIconString:[NSString stringWithUTF8String:DEFAULT_ICON]
                       userIconColor:[UIColor whiteColor]];
}

@end
