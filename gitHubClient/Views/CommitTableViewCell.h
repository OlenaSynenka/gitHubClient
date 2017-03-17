//
//  CommitTableViewCell.h
//  gitHubClient
//
//  Created by Olena Synenka on 3/16/17.
//  Copyright © 2017 Olena Synenka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommitTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *commitMassegeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cretionDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *committerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *committerEmailLabel;

@end
