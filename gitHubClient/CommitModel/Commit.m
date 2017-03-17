//
//  Commit.m
//  gitHubClient
//
//  Created by Olena Synenka on 3/16/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import "Commit.h"

@implementation Commit

- (instancetype)initWithDescription:(NSString *)description
                         authorName:(NSString *)authorName
                        authorEmail:(NSString *)authtoEmail
                       creationDate:(NSString *)creationDate {
    self = [super init];
    if (self) {
        _commitDescription= description;
        _authorName = authorName;
        _authorEmail = authtoEmail;
        _created = creationDate;
    }
    return self;
}


@end
