//
//  RecommendViewController.m
//  VideoPlayer
//
//  Created by Snake on 16/3/10.
//  Copyright © 2016年 Snake. All rights reserved.
//

#import "RecommendViewController.h"
#import "WYLMVCell.h"
#import "WYLMVModel.h"
#import "WYLPlayerViewController.h"
@interface RecommendViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UICollectionView *listView;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSMutableArray *modelArr;
@end
static NSString *ID = @"movieCell";
@implementation RecommendViewController

- (NSMutableArray *)modelArr
{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;

}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    [self readLocalDataSource];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //当使用weak修饰控件时,需要先用一个指针强引用,之后再用weak的_list引用这个对象
    UICollectionView *listView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64-49) collectionViewLayout:flowLayout];
    _listView = listView;
    _listView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_listView];
    self.listView.dataSource = self;
    self.listView.delegate = self;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    [self.listView registerNib:[UINib nibWithNibName:@"WYLMVCell" bundle:nil] forCellWithReuseIdentifier:ID];
    
    [self.listView reloadData];
}
- (void)readLocalDataSource
{
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"MVSource" ofType:@"plist"];
    NSArray *dataArr = [NSArray arrayWithContentsOfFile:dataPath];
    self.dataArray = [NSArray arrayWithArray:dataArr];
    for (NSDictionary *dataDict in self.dataArray) {
        WYLMVModel *MV_model = [WYLMVModel mj_objectWithKeyValues:dataDict];
        [self.modelArr addObject:MV_model];
    }
}
#pragma - mark collectionViewDataSourceMethods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    WYLMVCell *MVCell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    MVCell.model = self.modelArr[indexPath.row];
    return MVCell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.width-70)/2, 100);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 30, 10, 30);

}
#pragma - mark collectionViewDelegateMethods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WYLMVModel *model = self.modelArr[indexPath.row];
    WYLPlayerViewController *playerVC = [[WYLPlayerViewController alloc] initWithSourceModel:model];
    [self.tabBarController presentViewController:playerVC animated:YES completion:nil];
}




@end
