//
//  WYLDOTA2Cell.m
//  VideoPlayer
//
//  Created by Snake on 16/3/24.
//  Copyright © 2016年 Snake. All rights reserved.
//

#import "WYLDOTA2Cell.h"

@interface WYLDOTA2Cell ()
@property (weak, nonatomic) IBOutlet UIImageView *heroImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation WYLDOTA2Cell

- (void)awakeFromNib {
//    self.heroImageView.layer.backgroundColor = [UIColor yellowColor].CGColor;
    self.heroImageView.layer.cornerRadius = 13.0f;
    self.heroImageView.clipsToBounds = YES;
    
}
- (void)setModel:(WYLDOTA2Model *)model
{
    if (_model != model) {
        _model = model;
        [self.heroImageView sd_setImageWithURL:[NSURL URLWithString:_model.iconURL] placeholderImage:nil];
    }

}
@end
