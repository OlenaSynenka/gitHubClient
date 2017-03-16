//
//  GitHubHTTPClient.m
//  gitHubClient
//
//  Created by Olena Synenka on 3/15/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import "GitHubHTTPClient.h"
#import "Constants.h"

@implementation GitHubHTTPClient

+ (GitHubHTTPClient *)sharedGitHubHTTPClient {
    static GitHubHTTPClient *sharedGitHubHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGitHubHTTPClient = [[self alloc] initPrivate];
    });
    
    return sharedGitHubHTTPClient;
}

- (instancetype)initPrivate
{
    self = [super initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    }
    
    return self;
}

- (instancetype)initWithBaseURL:(NSURL *)url;
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[GitHubHTTPClient sharedGitHubHTTPClient]"
                                 userInfo:nil];
    return nil;
}


@end
