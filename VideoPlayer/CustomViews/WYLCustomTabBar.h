//
//  WYLCustomTabBar.h
//  VideoPlayer
//
//  Created by Snake on 16/3/11.
//  Copyright © 2016年 Snake. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WYLCustomTabBarDelegate <NSObject>

- (void)tabBarDidClickPlusButton:(UIButton *)Button;

@end

@interface WYLCustomTabBar : UITabBar
@property (nonatomic,weak)id<WYLCustomTabBarDelegate>customTabBarDelegate;
@end
