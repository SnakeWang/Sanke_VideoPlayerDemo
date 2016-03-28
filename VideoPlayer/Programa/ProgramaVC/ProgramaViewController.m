//
//  ProgramaViewController.m
//  VideoPlayer
//
//  Created by Snake on 16/3/11.
//  Copyright © 2016年 Snake. All rights reserved.
//

#import "ProgramaViewController.h"
#import "WYLCircleLayout.h"
#import "WYLDOTA2Cell.h"
#import "WYLDOTA2Model.h"
#import "WYLDetailHerosViewController.h"

@interface ProgramaViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
@property (nonatomic,strong)UICollectionView *circleView;
@property (nonatomic,strong)NSMutableArray *groupArray;
@property (nonatomic,strong)NSMutableArray *itemArray;
@end
static NSString *heroID = @"heroCell";
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
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.view.width/2-50, 0, 100, 50);
    [btn setTitle:@"卡片式" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor orangeColor]];
    [btn addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self loadDefaultDataSource];
    
    WYLCircleLayout *layout = [[WYLCircleLayout alloc] init];
    
    self.circleView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-49 ) collectionViewLayout:layout];
    self.circleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.circleView];
    self.circleView.delegate = self;
    self.circleView.dataSource = self;
    [self.circleView addSubview:btn];
    [self.circleView registerNib:[UINib nibWithNibName:@"WYLDOTA2Cell" bundle:nil] forCellWithReuseIdentifier:heroID];
    /**
     *  读取本地数据
     */
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.circleView reloadData];
        NSLog(@"thread === %@",[NSThread currentThread]);
    });
    
}
- (void)buttonClicked
{
    
}
#pragma markl - 读取本地数据
- (void)loadDefaultDataSource
{
    NSString *sourecPath = [[NSBundle mainBundle] pathForResource:@"DOTA2HEROS" ofType:@"plist"];
    NSArray *tempArray = [NSArray arrayWithContentsOfFile:sourecPath];
    [self.groupArray addObjectsFromArray:tempArray];
    NSArray *modelArr = [self.groupArray firstObject];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSDictionary *dict in modelArr) {
            WYLDOTA2Model *dota2Model = [WYLDOTA2Model mj_objectWithKeyValues:dict];
            [self.itemArray addObject:dota2Model];
        }
    });
    
    
    
}
#pragma mark -collerctionDataSourceMethod

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return self.groupArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.itemArray.count;
//    return 36;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WYLDOTA2Cell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:heroID forIndexPath:indexPath];
    cell.model = self.itemArray[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WYLDetailHerosViewController *detailVC = [[WYLDetailHerosViewController alloc] init];
    WYLDOTA2Model *model = self.itemArray[indexPath.item];
    detailVC.sourceURL = model.contentURL;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
