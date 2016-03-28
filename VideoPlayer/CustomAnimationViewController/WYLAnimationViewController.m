//
//  WYLAnimationViewController.m
//  VideoPlayer
//
//  Created by Snake on 16/3/21.
//  Copyright © 2016年 Snake. All rights reserved.
//

#import "WYLAnimationViewController.h"

#define pad 10

@interface WYLAnimationViewController ()
@property (nonatomic,strong)UIImageView *carRunView;
@property (nonatomic,strong)UIImageView *blackSeed;
@property (nonatomic,strong)UIImageView *whiteSeed;
@property (nonatomic,strong)UIButton *talkBtn_white;
@property (nonatomic,strong)UIButton *talkBtn_right;
@property (nonatomic,strong)UIButton *talkBtn_end;
@property (nonatomic,assign)BOOL isAnimatiing;
@end

@implementation WYLAnimationViewController
{
    CGFloat beginPositionX;
    CGFloat beginPositionY;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    UIImageView *bg_image = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:bg_image];
    
    bg_image.image = [UIImage imageNamed:@"lanchImage.jpg"];
    
  
    /**
     *  汽车动画
     */
    [self setupRunningCarAnimation];
    /**
     *  高达动画
     */
    [self setupSeedAnimation];
    
}
- (void)setupSeedAnimation
{
    
    self.whiteSeed = [[UIImageView alloc] initWithFrame:CGRectMake(pad, CGRectGetHeight(self.view.frame)-110-pad, 140, 100)];
    self.whiteSeed.image = [UIImage imageNamed:@"white"];
    [self.view addSubview:self.whiteSeed];
    UIImage *talkImage = [UIImage imageNamed:@"chat_recive_nor"];
    NSInteger leftCapWidth = talkImage.size.width *0.5;
    NSInteger topCapHeight = talkImage.size.height *0.5;
    UIImage *capTalkImage_left = [talkImage stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    self.talkBtn_white = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.talkBtn_white setBackgroundImage:capTalkImage_left forState:UIControlStateNormal];
    self.talkBtn_white.frame = CGRectMake(self.whiteSeed.x+100, self.whiteSeed.y+10, 100, 50);
    [self.talkBtn_white setTitle:@"hei!man" forState:UIControlStateNormal];
    [self.talkBtn_white setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    self.blackSeed = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-pad-CGRectGetWidth(self.whiteSeed.frame), CGRectGetMinY(self.whiteSeed.frame), CGRectGetWidth(self.whiteSeed.frame), CGRectGetHeight(self.whiteSeed.frame))];
    [self.view addSubview:self.blackSeed];
    self.blackSeed.image = [UIImage imageNamed:@"black"];
    UIImage *talkImage_right = [UIImage imageNamed:@"chat_send_nor"];
    self.talkBtn_right = [UIButton buttonWithType:UIButtonTypeCustom];
    self.talkBtn_right.frame = self.talkBtn_white.frame;
    NSInteger leftCapWidth_1 = talkImage_right.size.width *0.5;
    NSInteger topCapHeight_1 = talkImage_right.size.height *0.5;
    UIImage *capTalkImage_right = [talkImage_right stretchableImageWithLeftCapWidth:leftCapWidth_1 topCapHeight:topCapHeight_1];
    [self.talkBtn_right setBackgroundImage:capTalkImage_right forState:UIControlStateNormal];
    [self.talkBtn_right setTitle:@"滚!" forState:UIControlStateNormal];
    [self.talkBtn_right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.talkBtn_right.alpha = 0.0f;
    [self.view addSubview:self.talkBtn_right];
    [self.view addSubview:self.talkBtn_white];
    
    UIImage *talkImage_end = [UIImage imageNamed:@"chat_recive_nor"];
    [talkImage_end stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    self.talkBtn_end = [UIButton buttonWithType:UIButtonTypeCustom];
    self.talkBtn_end.frame = self.talkBtn_white.frame;
    [self.talkBtn_end setBackgroundImage:talkImage_end forState:UIControlStateNormal];
    [self.view addSubview:self.talkBtn_end];
    [self.talkBtn_end setTitle:@"$#%%^" forState:UIControlStateNormal];
    [self.talkBtn_end setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.talkBtn_end.alpha = 0.0f;
    
}
- (void)setupRunningCarAnimation
{
    self.carRunView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"runningCar"]];
    beginPositionX = -(self.carRunView.size.width/2);
    beginPositionY = CGRectGetMaxY(self.view.frame)-(self.carRunView.size.height/2);
    self.carRunView.center = CGPointMake(beginPositionX, beginPositionY);
    [self.view addSubview:self.carRunView];
  
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
   
    [self.presentingViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    if (!self.isAnimatiing) {
        self.isAnimatiing = !self.isAnimatiing;
        [UIView animateKeyframesWithDuration:5.0f delay:0.0f options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.3f animations:^{
                self.talkBtn_white.alpha = 0.0f;
                
            }];
            
            [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.3f animations:^{
                
                self.talkBtn_right.alpha = 1.0f;
            }];
            
            [UIView addKeyframeWithRelativeStartTime:0.6 relativeDuration:0.1 animations:^{
                self.talkBtn_right.alpha = 0.0f;
                
            }];
            
            [UIView addKeyframeWithRelativeStartTime:0.6 relativeDuration:0.3f animations:^{
                
                self.talkBtn_end.alpha = 1.0f;
                
            }];
            
            [UIView addKeyframeWithRelativeStartTime:0.9 relativeDuration:0.1f animations:^{
                self.talkBtn_end.alpha = 0.0f;
            }];
            
        } completion:^(BOOL finished) {
            
            [self whiteSeedFlyAnimation];
            
        }];
        

    }
    
    
//    [UIView animateWithDuration:3.0f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.carRunView.center = CGPointMake(CGRectGetWidth(self.view.frame)-beginPositionX, beginPositionY);
//        
//        
//    } completion:^(BOOL finished) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }];
//    

}
- (void)whiteSeedFlyAnimation
{
    [UIView animateKeyframesWithDuration:3.0f delay:1.0f options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.7 animations:^{
            self.whiteSeed.centerX += CGRectGetWidth(self.view.frame)-(CGRectGetWidth(self.whiteSeed.frame)-pad);
            self.whiteSeed.centerY -= self.view.height - self.whiteSeed.height-pad;
            self.whiteSeed.transform = CGAffineTransformMakeScale(0.01, 0.01);
            
        }];
        [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.3 animations:^{
            self.whiteSeed.alpha = 0.0f;
            
        }];
        
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
