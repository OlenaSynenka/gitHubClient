//
//  Repository.h
//  gitHubClient
//
//  Created by Olena Synenka on 3/16/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Repository : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *repoDescription;

@property (nonatomic, assign) NSInteger countOfForks;
@property (nonatomic, assign) NSInteger countOfWatchers;

@end
