//
//  ListTableViewCell.h
//  HYN
//
//  Created by 이승희 on 20/03/2017.
//  Copyright © 2017 이승희. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentageLabel;

@end
