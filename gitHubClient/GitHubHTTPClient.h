//
//  GitHubHTTPClient.h
//  gitHubClient
//
//  Created by Olena Synenka on 3/15/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>


@interface GitHubHTTPClient : AFHTTPSessionManager

+ (GitHubHTTPClient *)sharedGitHubHTTPClient;
- (NSDictionary *)handleError:(NSError *)error;

@end

