//
//  User.m
//  gitHubClient
//
//  Created by Olena Synenka on 3/16/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithName:(NSString *)name avatarURL:(NSString *)avatarURL {
    self = [super init];
    if (self) {
        _name = name;
        _avatarURL = avatarURL;
    }
    return self;
}

@end
