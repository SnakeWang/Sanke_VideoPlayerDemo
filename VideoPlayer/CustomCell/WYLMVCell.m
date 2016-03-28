//
//  WYLMVCell.m
//  VideoPlayer
//
//  Created by Snake on 16/3/11.
//  Copyright © 2016年 Snake. All rights reserved.
//

#import "WYLMVCell.h"
#import "UIImageView+WebCache.h"
#import "WYLMVModel.h"
@interface WYLMVCell ()
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *translucentView;

@end

@implementation WYLMVCell

- (void)awakeFromNib {
    
    self.translucentView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];

}
- (void)setModel:(WYLMVModel *)model
{
    [self.ImageView sd_setImageWithURL:[NSURL URLWithString:model.MVImage] placeholderImage:nil];
    self.titleLabel.text = model.MVName;
    
}
@end
