//
//  RepoTableViewCell.h
//  gitHubClient
//
//  Created by Olena Synenka on 3/16/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *repoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *repoDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *forksCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *watchersCountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *ownerAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *ownerNameLabel;

@end
