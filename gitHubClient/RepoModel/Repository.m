//
//  Repository.m
//  gitHubClient
//
//  Created by Olena Synenka on 3/16/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import "Repository.h"

@implementation Repository

- (instancetype)initWithName:(NSString *)name
                 description:(NSString *)description
                      author:(User *)author
                countOfForks:(NSInteger)countOfForks
             countOfWatchers:(NSInteger)countOfWatchers {
    self = [super init];
    if (self) {
        _name = name;
        _repoDescription = description;
        _author = author;
        _countOfForks = countOfForks;
        _countOfWatchers = countOfWatchers;
    }
    return self;
}

@end
