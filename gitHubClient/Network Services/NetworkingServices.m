//
//  NetworkingServices.m
//  gitHubClient
//
//  Created by Olena Synenka on 3/16/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import "NetworkingServices.h"

#import "GitHubHTTPClient.h"
#import "Constants.h"
#import "Repository.h"
#import "Commit.h"
#import "KeychainWrapper.h"

@implementation NetworkingServices

- (RACSignal *)getAccessTokenWithCode:(NSString *)code {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSDictionary *params = @{
                                 @"client_id" : CLIENT_ID,
                                 @"client_secret" : CLIENT_SECRET,
                                 @"code" : code
                                 };
        NSString *tenantURL = [NSString stringWithFormat:@"/login/oauth/access_token"];
        
        AFHTTPSessionManager *httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://github.com"]];
        httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
        httpSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [httpSessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [httpSessionManager POST:tenantURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *accessToken = [responseObject objectForKey:@"access_token"];
            
            KeychainWrapper *keychainWrapper = [KeychainWrapper new];
            [keychainWrapper mySetObject:accessToken forKey:(NSString *)kSecValueData];
            [keychainWrapper writeToKeychain];
            
            [[GitHubHTTPClient sharedGitHubHTTPClient].requestSerializer setValue:[NSString stringWithFormat:@"token %@",accessToken] forHTTPHeaderField:@"Authorization"];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[GitHubHTTPClient sharedGitHubHTTPClient] handleError:error];
        }];
        return nil;
    }];
}

- (RACSignal *)getCurrentUserRepos {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *tenantURL = [NSString stringWithFormat:@"/user/repos"];
        [[GitHubHTTPClient sharedGitHubHTTPClient] GET:tenantURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSMutableArray *repos  = [NSMutableArray new];
            for (NSDictionary *dictionary in responseObject) {
                NSDictionary *authorDict = [dictionary objectForKey:@"owner"];
                NSString *description = [dictionary objectForKey:@"description"];
                if (description == (id)[NSNull null]) { description = @"";}
                User *author = [[User alloc] initWithName:[authorDict objectForKey:@"login"] avatarURL:[authorDict objectForKey:@"avatar_url"]];
                Repository *repo  = [[Repository alloc] initWithName:[dictionary objectForKey:@"name"] description:description author:author countOfForks:[[dictionary objectForKey:@"forks_count"] integerValue] countOfWatchers:[[dictionary objectForKey:@"watchers_count"] integerValue]];
                [repos addObject:repo];
            }
            [subscriber sendNext:repos];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[GitHubHTTPClient sharedGitHubHTTPClient] handleError:error];
        }];
        return nil;
    }];
}

- (RACSignal *)getCommitsForUserWithName:(NSString *)username repoWithName:(NSString *)repoName {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *tenantURL = [NSString stringWithFormat:@"/repos/%@/%@/commits", username, repoName];
        [[GitHubHTTPClient sharedGitHubHTTPClient] GET:tenantURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSMutableArray *commits  = [NSMutableArray new];
            for (NSDictionary *dictionary in responseObject) {
                NSDictionary *commitDict = [dictionary objectForKey:@"commit"];
                NSDictionary *authorDict = [commitDict objectForKey:@"committer"];
                
                NSDateFormatter *dateFormatter = [NSDateFormatter new];
                dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
                NSDate *cretionDate = [dateFormatter dateFromString:[authorDict objectForKey:@"date"]];
                dateFormatter.dateFormat = @"dd MMM yyyy";
                NSString *created = [dateFormatter stringFromDate:cretionDate];
                
                Commit *commit  = [[Commit alloc] initWithDescription:[commitDict objectForKey:@"message"] authorName:[authorDict objectForKey:@"name"] authorEmail:[authorDict objectForKey:@"email"] creationDate:created];
                [commits addObject:commit];
            }
            [subscriber sendNext:commits];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[GitHubHTTPClient sharedGitHubHTTPClient] handleError:error];
        }];
        return nil;
    }];
}


@end

