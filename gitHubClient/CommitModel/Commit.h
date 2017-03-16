//
//  Commit.h
//  gitHubClient
//
//  Created by Olena Synenka on 3/16/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Commit : NSObject

@property (nonatomic, strong) NSString *commitDescription;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *created;


@end
