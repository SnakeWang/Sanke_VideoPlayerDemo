//
//  WYLCircleLayout.m
//  VideoPlayer
//
//  Created by Snake on 16/3/23.
//  Copyright © 2016年 Snake. All rights reserved.
//

#import "WYLCircleLayout.h"

#define ITEM_WIDTH 26
#define ITEM_HEIGHT 26
#define pad 15
@interface WYLCircleLayout ()
@property (nonatomic,assign)NSInteger sectionCount;
@property (nonatomic,assign)NSInteger cellCount;//cell数量
@property (nonatomic,assign)CGFloat radius_outmost;//最外面的半径
@property (nonatomic,assign)CGFloat radius_middle;//中间的
@property (nonatomic,assign)CGFloat radius_inmost;//最内部的
@property (nonatomic,assign)CGSize viewSize;//collectionView尺寸
@property (nonatomic,assign)CGPoint center;
@end
@implementation WYLCircleLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.sectionCount = [self.collectionView numberOfSections];
    _center = CGPointMake(self.collectionView.width/2, self.collectionView.height/2);
    _radius_outmost = MIN(self.collectionView.width, self.collectionView.height)/2.5;
    _radius_middle = _radius_outmost-ITEM_WIDTH-pad;
    _radius_inmost = _radius_middle-ITEM_WIDTH-pad;
    _cellCount = [self.collectionView numberOfItemsInSection:0];
    
}
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributesArr = [NSMutableArray array];
    
    for (int i = 0; i < self.cellCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
        [attributesArr addObject:attribute];
    }
    return attributesArr;
    
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = CGSizeMake(ITEM_WIDTH, ITEM_WIDTH);
    if (indexPath.item < 12) {
        attributes.center = CGPointMake(_center.x + _radius_outmost * cosf(2 * M_PI * indexPath.item/12), _center.y + _radius_outmost * sinf(2 * M_PI * indexPath.item/12));
    }else if (indexPath.item < 24){
        attributes.center = CGPointMake(_center.x + _radius_middle * cosf(2 *M_PI * (indexPath.item%12)/12), _center.y + _radius_middle * sinf(2 * M_PI * (indexPath.item%12)/12));
    }else{
        attributes.center = CGPointMake(_center.x + _radius_inmost * cosf(2 *M_PI * (indexPath.item%24)/12), _center.y + _radius_inmost * sinf(2 * M_PI * (indexPath.item%24)/12));
    }
    
   
//     attributes.center = CGPointMake(_center.x + _radius_outmost * cosf(2 * M_PI * indexPath.item/self.cellCount), _center.y + _radius_outmost * sinf(2 * M_PI * indexPath.item/self.cellCount));
    return attributes;
}
@end
