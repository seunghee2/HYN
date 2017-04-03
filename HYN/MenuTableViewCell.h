//
//  MenuTableViewCell.h
//  HYN
//
//  Created by 이승희 on 03/04/2017.
//  Copyright © 2017 이승희. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentageLabel;
@property (weak, nonatomic) IBOutlet UIView *percentageView;
    
@end
