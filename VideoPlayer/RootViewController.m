//
//  RootViewController.m
//  VideoPlayer
//
//  Created by Snake on 16/3/10.
//  Copyright © 2016年 Snake. All rights reserved.
//

#import "RootViewController.h"
#import "RecommendViewController.h"
#import "ProgramaViewController.h"
#import "SearchViewController.h"
#import "MeViewController.h"
#import "WYLCustomTabBar.h"
#import "WYLNavigationViewController.h"
#import "WYLAnimationViewController.h"

#define TabbarTitleNormalColor [UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:1.0]
#define TabbarTitleSelectColor [UIColor colorWithRed:255.0/255.0 green:118/255.0 blue:0/255.0 alpha:1.0]

@interface RootViewController ()<WYLCustomTabBarDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addChildVC:[[RecommendViewController alloc] init] title:@"推荐" normalImage:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    [self addChildVC:[[ProgramaViewController alloc] init] title:@"栏目" normalImage:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    [self addChildVC:[[SearchViewController alloc] init] title:@"搜索" normalImage:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    [self addChildVC:[[MeViewController alloc] init] title:@"我的" normalImage:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    WYLCustomTabBar *tabBar = [[WYLCustomTabBar alloc] init];
    tabBar.customTabBarDelegate = self;
    [self setValue:tabBar forKey:@"tabBar"];
}

- (void)addChildVC:(UIViewController *)childVC title:(NSString *)title normalImage:(NSString *)image selectedImage:(NSString *)selectedimage
{
    childVC.title = title;
    
    childVC.tabBarItem.image = [UIImage imageNamed:image];
    
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedimage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : TabbarTitleNormalColor} forState:UIControlStateNormal];
    [childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]} forState:UIControlStateSelected];
    WYLNavigationViewController *navVC = [[WYLNavigationViewController alloc] initWithRootViewController:childVC];
    
    [self addChildViewController:navVC];
}
/**
 *  customTabbarDelegate方法(加号按钮的回调)
 */
- (void)tabBarDidClickPlusButton:(UIButton *)Button
{
    WYLAnimationViewController *animationVC = [[WYLAnimationViewController alloc] init];
    
    [animationVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:animationVC animated:YES completion:nil];
    
}
/**
 *  横屏显示设置,根试图上禁止横屏显示
 *
 *  @return NO是禁止横屏,YES可以自旋(可以横屏)
 */
- (BOOL)shouldAutorotate
{
    return NO;
}
@end
