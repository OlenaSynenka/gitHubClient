//
//  RepoDetailsVC.m
//  gitHubClient
//
//  Created by Olena Synenka on 3/16/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import "RepoDetailsVC.h"
#import "CommitTableViewCell.h"
#import "NetworkingServices.h"
#import "Commit.h"

#import <MBProgressHUD.h>

@interface RepoDetailsVC () <UITableViewDelegate, UITableViewDataSource>

@property ( nonatomic, strong) NSMutableArray *commits;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NetworkingServices *networkingServices;

@property (nonatomic, assign) BOOL isPageRefresing;
@property (nonatomic, assign) NSInteger currentPageNumber;

@end

@implementation RepoDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.commits = [NSMutableArray new];
    self.isPageRefresing = NO;
    self.currentPageNumber = 1;
    self.networkingServices = [NetworkingServices new];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommitTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([CommitTableViewCell class])];
        
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 40;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[self.networkingServices getCommitsForUserWithName:self.repo.author.name repoWithName:self.repo.name forPage:1] subscribeNext:^(NSArray *commits) {
        self.commits = [commits mutableCopy];
        [self.tableView reloadData];
        [hud hideAnimated:YES];
    }];

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.commits.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
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
    CommitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CommitTableViewCell class])];
    Commit *commit = [self.commits objectAtIndex:indexPath.section];
    
    cell.commitMassegeLabel.text = commit.commitDescription;
    cell.committerNameLabel.text = commit.authorName;
    cell.committerEmailLabel.text = commit.authorEmail;
    cell.cretionDateLabel.text = commit.created;
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height)) {
        
        if(!self.isPageRefresing){
            self.isPageRefresing = YES;
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.currentPageNumber = self.currentPageNumber +1;
            [[self.networkingServices getCommitsForUserWithName:self.repo.author.name repoWithName:self.repo.name forPage:self.currentPageNumber] subscribeNext:^(NSArray *nextCommits) {
                [self.commits addObjectsFromArray:nextCommits];
                [hud hideAnimated:YES];
                self.isPageRefresing = NO;
            }];
            
        }
    }
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
