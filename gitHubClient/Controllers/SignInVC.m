//
//  SignInVC.m
//  gitHubClient
//
//  Created by Olena Synenka on 3/16/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import "SignInVC.h"
#import "NetworkingServices.h"
#import "Constants.h"
#import "GitHubHTTPClient.h"

const NSString *base_url = @"https://github.com";

@interface SignInVC ()

@end

@implementation SignInVC 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signInButtonPressed:(id)sender {
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    
    NSString *tenantURLString = [NSString stringWithFormat:@"%@/login/oauth/authorize", base_url];
    tenantURLString = [NSString stringWithFormat:@"%@?%@=%@", tenantURLString, @"client_id", CLIENT_ID];
    NSURL *tenantURL = [NSURL URLWithString:tenantURLString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:tenantURL];
    
    [webView loadRequest:urlRequest];
    
}

#pragma  mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *callbackURL = navigationAction.request.URL;
    if ([[callbackURL resourceSpecifier] hasPrefix:@"//github_client/callback"]) {
        
        NSArray *queryItems = [[NSURLComponents componentsWithURL:callbackURL resolvingAgainstBaseURL:NO] queryItems];
        NSString *code = ((NSURLQueryItem *)[queryItems firstObject]).value;
        
        NetworkingServices *services = [NetworkingServices new];
        [[services getAccessTokenWithCode:code] subscribeCompleted:^{
            [self performSegueWithIdentifier:@"showRepoList" sender:self];
        }];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
