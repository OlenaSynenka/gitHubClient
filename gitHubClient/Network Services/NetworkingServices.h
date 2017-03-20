//
//  NetworkingServices.h
//  gitHubClient
//
//  Created by Olena Synenka on 3/16/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <WebKit/WebKit.h>

@interface NetworkingServices : NSObject 

- (RACSignal *)getAccessTokenWithCode:(NSString *)code;

- (RACSignal *)getCurrentUserReposForPage:(NSInteger)page;
- (RACSignal *)getCommitsForUserWithName:(NSString *)username repoWithName:(NSString *)repoName forPage:(NSInteger)page;
@end
