//
//  GitHubHTTPClient.h
//  gitHubClient
//
//  Created by Olena Synenka on 3/15/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@protocol APIHTTPClientDelegate;

@interface GitHubHTTPClient : AFHTTPSessionManager

@property (nonatomic, weak) id<APIHTTPClientDelegate>delegate;

+ (GitHubHTTPClient *)sharedGitHubHTTPClient;

@end

@protocol APIHTTPClientDelegate <NSObject>

-(void)gitHubHTTPClient:(GitHubHTTPClient *)client didFailWithError:(NSError *)error;

@end
