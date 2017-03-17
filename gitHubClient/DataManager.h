//
//  DataManager.h
//  gitHubClient
//
//  Created by Olena Synenka on 3/16/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface DataManager : NSObject

+ (instancetype) sharedDataManager;

@property (strong, nonatomic) NSMutableArray *repos;

@end
