//
//  ProgramaViewController.m
//  VideoPlayer
//
//  Created by Snake on 16/3/11.
//  Copyright © 2016年 Snake. All rights reserved.
//

#import "ProgramaViewController.h"
#import "WYLCircleLayout.h"
@interface ProgramaViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
@property (nonatomic,strong)UICollectionView *circleView;
@property (nonatomic,strong)NSMutableArray *groupArray;
@property (nonatomic,strong)NSMutableArray *itemArray;
@end

@implementation ProgramaViewController

- (NSMutableArray *)groupArray
{
    if (_groupArray == nil) {
        _groupArray = [NSMutableArray array];
    }
    return _groupArray;
}
- (NSMutableArray *)itemArray
{
    if (_itemArray == nil) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    WYLCircleLayout *layout = [[WYLCircleLayout alloc] init];
    
    self.circleView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-49-64) collectionViewLayout:layout];
    [self.view addSubview:self.circleView];
    self.circleView.delegate = self;
    self.circleView.dataSource = self;

}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.groupArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.itemArray = self.groupArray[section];
    return self.itemArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
