//
//  ReposListVC.m
//  gitHubClient
//
//  Created by Olena Synenka on 3/16/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import "ReposListVC.h"
#import "NetworkingServices.h"
#import "RepoTableViewCell.h"
#import "Repository.h"
#import "RepoDetailsVC.h"
#import "KeychainWrapper.h"
#import "GitHubHTTPClient.h"

#import <WebKit/WebKit.h>
#import <MBProgressHUD.h>


@interface ReposListVC () <UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *repos;

@end

@implementation ReposListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.repos = [NSMutableArray new];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RepoTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([RepoTableViewCell class])];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 40;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NetworkingServices * services = [NetworkingServices new];
    [[services getCurrentUserRepos] subscribeNext:^(NSArray *repos) {
        self.repos = [repos mutableCopy];
        [self.tableView reloadData];
        [hud hideAnimated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logOutButtonPressed:(id)sender {
    
    KeychainWrapper *keychainWrapper = [KeychainWrapper new];
    [keychainWrapper mySetObject:@"" forKey:(NSString *)kSecValueData];
    [keychainWrapper writeToKeychain];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    
    NSString *tenantURLString = @"https://github.com/logout";
    NSURL *tenantURL = [NSURL URLWithString:tenantURLString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:tenantURL];
    
    [webView loadRequest:urlRequest];

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.repos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat cellSpacingHeight = 8.;
    return cellSpacingHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RepoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RepoTableViewCell class])];
    Repository *repo = [self.repos objectAtIndex:indexPath.section];
    
    cell.repoNameLabel.text = repo.name;
    cell.repoDescriptionLabel.text = repo.repoDescription;
    cell.forksCountLabel.text = [NSString stringWithFormat:@"forks: %ld", (long)repo.countOfForks];
    cell.watchersCountLabel.text = [NSString stringWithFormat:@"watchers: %ld", (long)repo.countOfWatchers];
    cell.ownerNameLabel.text = repo.author.name;
    NSData *avatarData = [NSData dataWithContentsOfURL:[NSURL URLWithString:repo.author.avatarURL]];
    cell.ownerAvatarImageView.image = [UIImage imageWithData:avatarData scale:0.2f];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"showRepoCommits" sender:self];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[RepoDetailsVC class]]) {
        ((RepoDetailsVC *)segue.destinationViewController).repo = self.repos[[self.tableView indexPathForSelectedRow].section];
    }
}

#pragma  mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if ([[navigationAction.request.URL absoluteString] isEqualToString:@"https://github.com/"]) {
        UINavigationController *firstVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SignInVC"];
        
        UIViewController *currentVC = (UIViewController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
        while (currentVC.presentedViewController && (![currentVC.presentedViewController isKindOfClass:[UIAlertController class]])) {
            currentVC = currentVC.presentedViewController;
        }
        [currentVC presentViewController:firstVC animated:YES completion:nil];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}


@end
