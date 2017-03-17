//
//  Repository.h
//  gitHubClient
//
//  Created by Olena Synenka on 3/16/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"

@interface Repository : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *repoDescription;
@property (nonatomic, strong) User *author;

@property (nonatomic, assign) NSInteger countOfForks;
@property (nonatomic, assign) NSInteger countOfWatchers;

- (instancetype)initWithName:(NSString *)name
                 description:(NSString *)description
                      author:(User *)author
                countOfForks:(NSInteger)countOfForks
             countOfWatchers:(NSInteger)countOfWatchers;

@end
