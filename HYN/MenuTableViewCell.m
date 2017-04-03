//
//  MenuTableViewCell.m
//  HYN
//
//  Created by 이승희 on 03/04/2017.
//  Copyright © 2017 이승희. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    // Clear contentView
    BOOL hasContentView = [self.subviews containsObject:self.contentView];
    if (hasContentView) {
        [self.contentView removeFromSuperview];
    }
}

@end
