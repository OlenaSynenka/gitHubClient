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

- (NSDictionary *)handleError:(NSError *)error
{
    NSDictionary *userInfo = error.userInfo;
    NSLog(@"Handle Error = %@\n", error);
    NSData *data = [userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
    NSString *errorMsg = nil;
    NSDictionary *json;
    if (data) {
        NSError *serialError;
        json = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:data options:0 error:&serialError];
        if (serialError) {
            return nil;
        } else {
            if ([json objectForKey:@"error_description"] != nil) {
                errorMsg = [json objectForKey:@"error_description"];
            }
            if ([json objectForKey:@"message"] != nil) {
                errorMsg = [json objectForKey:@"message"];
            }
            if ([self processParsedObject:json message:@"Error" parent:nil]) {
                errorMsg = [self processParsedObject:json message:@"Error" parent:nil];
            }
            [self showErrorAlertWithDescription:errorMsg];
        }
    } else if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
        errorMsg = @"Your request cannot be completed because you are not connected to the internet. Verify your network connection and try again.";
        [self showErrorAlertWithDescription:errorMsg];
    } else {
        [self showErrorAlertWithDescription:nil];
    }
    
    return json;
}

-(NSString *)processParsedObject:(id)object message:(NSString *)msg parent:(id)parent{
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        for(NSString * key in [object allKeys]){
            if (![key isEqualToString:@"message"] && ![key isEqualToString:@"code"]) {
                id child = [object objectForKey:key];
                msg = [self processParsedObject:child message:msg parent:object];
            }
        }
    } else if([object isKindOfClass:[NSArray class]]) {
        
        for(id child in object){
            msg = [self processParsedObject:child message:msg parent:object];
        }
        
    } else {
        //This object is not a container you might be interested in it's value
        if (![[object description] isEqualToString:@""]) {
            NSLog(@"Node: %@", [object description]);
            msg = [object description];
        }
    }
    
    return msg;
}


- (void)showErrorAlertWithDescription:(NSString *)description
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:description preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        alertController.preferredAction = okAction;
        UIViewController *currentVC = (UIViewController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
        while (currentVC.presentedViewController && (![currentVC.presentedViewController isKindOfClass:[UIAlertController class]])) {
            currentVC = currentVC.presentedViewController;
        }
        [currentVC presentViewController:alertController animated:YES completion:nil];
    });
    
}


@end
