//
//  WYLPlayerViewController.m
//  VideoPlayer
//
//  Created by Snake on 16/3/14.
//  Copyright © 2016年 Snake. All rights reserved.
//

#import "WYLPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WYLPlayerView.h"
#import <MediaPlayer/MPVolumeView.h>

@interface WYLPlayerViewController ()
{
    CGFloat screenWidth;//屏幕宽度
    CGFloat screenHeight;//屏幕高度
    
    CGPoint beginPoint;
    CGFloat beginTouchx;
    CGFloat beginTouchy;
    CGFloat offsetX;
    CGFloat offsetY;
    CGFloat brightness;
    CGFloat sysVolume;
    
    UISlider *volumeSlider; // 改变系统声音的 MPVolumeSlider (UISlider的子类)
}
/**
 *  AVPlayerItem播放器状态对象,播放状态有3种(AVPlayerItemStatusUnknown,AVPlayerItemStatusReadyToPlay,AVPlayerItemStatusFailed)
 */
@property (weak, nonatomic) IBOutlet UISlider *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (nonatomic,strong)AVPlayerItem *playerItem;
@property (nonatomic,strong)NSURL *soureceURL;
@property (nonatomic,strong)AVPlayer *player;
@property (nonatomic,assign)BOOL playing;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet WYLPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn
;
@property (weak, nonatomic) IBOutlet UIButton *fastback;
@property (weak, nonatomic) IBOutlet UIButton *fastforward;
@property (weak, nonatomic) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UIButton *last;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (nonatomic,assign) BOOL hasPlayList;
@property (nonatomic,assign)BOOL draggingOnScreen;
@property (nonatomic,assign)BOOL canPlay;

@property (nonatomic,strong)WYLMVModel *model;
@end
/**
 *  static void *playItemStatusContext = &playItemStatusContext;这种声明方式可以导致a method to create a unique pointer at compile time.在编译的时候创建一个唯一的指针.因为kvo的时候context如果不小心重复了,会发生奇怪的事情.用这种方式可以避免.
 */
static void *playItemStatusContext = &playItemStatusContext;
static void *playItemPlayingContext = &playItemPlayingContext;
static void *playItemDurationContext = &playItemDurationContext;
@implementation WYLPlayerViewController
- (instancetype)initWithSourceModel:(WYLMVModel *)model
{
    self = [super init];
    if (self) {
        if (model) {
            _model = model;
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    screenWidth = [[UIScreen mainScreen] bounds].size.width;
    screenHeight = [[UIScreen mainScreen] bounds].size.height;
    NSLog(@"height == %f,width == %f",screenHeight,screenWidth);
    if (screenHeight > screenWidth) { // 横屏时,屏幕宽高互换
        CGFloat tmp = screenWidth;
        screenWidth = screenHeight;
        screenHeight = tmp;
    }
    
    
    
    self.headerView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3f];
    self.footerView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3f];
    self.playerView.layer.backgroundColor = [UIColor blackColor].CGColor;
    [self createPlayer];
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    for (UIView *aView in [volumeView subviews]) {
        if ([aView.class.description isEqualToString:@"MPVolumeSlider"]) {
            volumeSlider = (UISlider *)aView;
            break;
        }
    }
    // 初始的音量
    sysVolume = volumeSlider.value;
    
//    //使用拖拽和点击手势来监听工具条的显示或者隐藏,不应该用UIResponder的touches等方法.
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAtPlayerView)];
//    [self.playerView addGestureRecognizer:tap];
    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
//    [self.playerView addGestureRecognizer:pan];
    

}

//- (void)tapAtPlayerView
//{
//   
//    if (self.headerView.alpha == 0.0f || self.footerView.alpha == 0.0f) {
//        [self showToolBars];
//        
//        
//    }else{
//        [self hideToolBars];
//    }
//}
//- (void)handleGesture:(UIGestureRecognizer *)gesture
//{
//    if (self.headerView.alpha == 0.0f) {
//        [self showToolBars];
//    }
//}

/**
 *  创建播放器
 */
- (void)createPlayer
{
    [self setupPlayerDefaultSettingWithEnable:NO];
    
    //AVPlayerItem播放器状态对象,监控状态对象才能够知道什么时候开始播放
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.model.MVURL]];
    self.playerItem = playerItem;
    
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew  context:playItemStatusContext];
    
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    [self.playerView setPlayer:self.player];
}
/**
 *  能够播放之前做些默认的初始化设置
 */
- (void)setupPlayerDefaultSettingWithEnable:(BOOL)enabled
{
    if (self.hasPlayList) {
        self.next.enabled = enabled;
        self.last.enabled = enabled;
    }
    self.progressLabel.hidden = YES;
    self.playBtn.enabled = enabled;
    self.progressView.enabled = enabled;
    self.fastback.enabled = enabled;
    self.fastforward.enabled = enabled;
}
- (IBAction)backBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  播放
 */
- (void)play
{
    [self.player play];
    self.playing = YES;
}
- (void)pause
{
    [self.player pause];
    self.playing = NO;
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (BOOL)shouldAutorotate
{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
#pragma mark -进度条控制

- (IBAction)dragProgressView:(UISlider *)sender {
   
    
   
}
/**
 *  拖拽进度条改变播放进度
 *
 *  @param sender 进度条控件
 */
- (IBAction)progressValueChanged:(UISlider *)sender {
    
    //取消隐藏工具条
    [self cancelDelayHideHeaderAndFooterViewSelector:@selector(hideToolBars)];
    
    CGFloat totalTime = CMTimeGetSeconds(self.playerItem.duration);
    
//timescale表示1秒钟有多少frame(帧)构成,CMTimeMakeWithSeconds的第一个参数代表当前时间
    CMTime time = CMTimeMakeWithSeconds(totalTime * sender.value, self.playerItem.duration.timescale);
    
    [self seekToTime:time progress:sender.value];
    
}

- (void)seekToTime:(CMTime)targetTime progress:(CGFloat)progressPersent
{
    self.progressLabel.hidden = NO;
    
  
    
    if (progressPersent *100>= 0 && progressPersent *100<=100) {
        self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%",progressPersent *100];
    }
    if (_playing) {
        //如果在播放先暂停
        [self.player pause];
        
    }
    [self.player seekToTime:targetTime completionHandler:^(BOOL finished) {
        if (_playing) {
            [self.player play];
        }
    }];
    [self performSelector:@selector(hidePrgressLabel) withObject:nil afterDelay:1.0f];
}
- (void)hidePrgressLabel
{
    [self.progressLabel setHidden:YES];
}
// 视图展示的时候优先展示为 home键在右边的 横屏
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}
#pragma mark -准备播放
- (void)readyToPlay
{
    
    self.canPlay = YES;
    //播放前处理视频需要展示的信息
    [self handleVideoData];
    //延迟隐藏工具条
    [self delayHideHeaderViewAndFooterView];
   
    
}
#pragma mark -延迟隐藏工具条
- (void)delayHideHeaderViewAndFooterView
{
     [self performSelector:@selector(hideToolBars) withObject:nil afterDelay:5.0f];
}
- (void)cancelDelayHideHeaderAndFooterViewSelector:(SEL)selector
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:selector object:nil];
}

#pragma mark -准备播放前处理视频信息
- (void)handleVideoData
{
    self.titleLabel.text = self.model.MVName;
    
    //设置按钮都可以使用
    [self setupPlayerDefaultSettingWithEnable:YES];
    
    //处理时间进度条的显示
    self.remainTimeLabel.text = [NSString stringWithFormat:@"-%@",[self setupDurationTimeOrPlayerTime:self.playerItem.duration]];
    __weak typeof(self) weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(3, 30) queue:nil usingBlock:^(CMTime time) {
        weakSelf.currentTimeLabel.text = [weakSelf setupDurationTimeOrPlayerTime:time];
        NSString *text = [weakSelf setupDurationTimeOrPlayerTime:CMTimeSubtract(weakSelf.playerItem.duration, time)];
        weakSelf.remainTimeLabel.text = [NSString stringWithFormat:@"-%@",text];
        
        weakSelf.progressView.value = CMTimeGetSeconds(time)/CMTimeGetSeconds(weakSelf.playerItem.duration);
    }];
}

/**
 *  设置视频全部时间或者当前时间
 *
 *  @param time 一个CMTime结构体
 *
 *  @return 格式化后的时间字符串
 */
- (NSString *)setupDurationTimeOrPlayerTime:(CMTime)time
{
    //CMTime转换成为秒数 CMTime.value/CMTime.tiemscale = seconds
    CGFloat seconds = time.value/time.timescale;
    
    //将seconds转化为时间戳,自从1970年的起始时间过了多少秒
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    //转换为格林尼治标准时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //在中国就设置为0个小时时差,当做不跨越时区
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    [formatter setDateFormat:(seconds/3600 >= 1)?@"h:mm:ss":@"mm:ss"];
    
    return [formatter stringFromDate:date];
}
#pragma mark - KVO监听
/**
 *  KVO监听回调方法
 *
 *  @param keyPath 监听的属性名
 *  @param object  哪个对象被监听
 *  @param change  被监听的属性的改变
 *  @param context 上下文
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    
    AVPlayerItemStatus status = [[change valueForKey:NSKeyValueChangeNewKey] integerValue];
    if (context == playItemStatusContext) {
        
        
        if (status == AVPlayerItemStatusReadyToPlay) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self readyToPlay];
                
            });
        }
    }else if(context == playItemPlayingContext){
       
        
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}
#pragma mark - 按钮的响应事件
- (IBAction)playOrPause:(UIButton *)sender {
    
    self.playBtn.selected = !self.playBtn.selected;
    if (!self.playing) {
        [self play];
    }else{
        [self pause];
    }
    
    
}
- (IBAction)next:(id)sender {
}

- (IBAction)last:(id)sender {
}
- (IBAction)stop:(id)sender {
}

#pragma mark -隐藏/显示工具条
- (void)hideToolBars
{
    
    [UIView animateWithDuration:0.3f animations:^{
        self.headerView.alpha = 0.0f;
        self.footerView.alpha = 0.0f;
    }];
    
    
}
- (void)showToolBars
{
    [UIView animateWithDuration:0.3f animations:^{
        self.headerView.alpha = 1.0f;
        self.footerView.alpha = 1.0f;
        self.headerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
        self.footerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
    }];
  
   
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    // 初始的亮度
    brightness = [UIScreen mainScreen].brightness;
    
    // 改变音量的控件
  
    
    UITouch *touch = [touches anyObject];
    beginPoint = [touch locationInView:touch.view];
    beginTouchx = [touch locationInView:touch.view].x;
    beginTouchy = [touch locationInView:touch.view].y;
    
    if (self.headerView.alpha == 0.0f) {
        [self showToolBars];
    }else{
        
        [self hideToolBars];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideToolBars) object:nil];
    }
    
}
/**
 *  当来电话时中断触摸了,才出发cancel状态
 *
 *  @param touches
 *  @param event
 */
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    //视频应该暂停
    
    if (self.headerView.alpha == 0) {
        
        [self delayHideHeaderViewAndFooterView];
    }
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //触摸动作还是屏幕上时
    [super touchesMoved:touches withEvent:event];
    
    UITouch *oneTouch = [touches anyObject];
    
    offsetX = [oneTouch locationInView:oneTouch.view].x - beginTouchx;
    offsetY = [oneTouch locationInView:oneTouch.view].y - beginTouchy;
    
    //要改变的音量或亮度
    CGFloat changValue = -offsetY/screenHeight;
    
    CGFloat touchX = [oneTouch locationInView:oneTouch.view].x;
    //上下滑动,并且横向滑动不超过屏幕的1/3
    if (touchX < (1.0/3 * screenWidth) && offsetY !=0 ) {
        if (sysVolume + changValue > 0.0 && sysVolume + changValue < 1.0) {
            [volumeSlider setValue:sysVolume + changValue]; // 设置音量
        }
        
    }else if (touchX > (1.0/3 * screenWidth) && touchX < (2.0/3 * screenWidth) && offsetX != 0) {
        // 中屏幕中间左右滑动改变进度
        
        if (self.canPlay) { // 如果视频可以播放才可以调整播放进度
            // 要改变的进度值
            CGFloat deltaProgress = offsetX / screenWidth*0.2;
            
            // 如果正在播放先暂停播放（但是不改变_playing的值为NO，因为拖动进度完成后要根据_playing来判断是否要继续播放），再根据进度条表示的值进行播放定位
            if (_playing) {
                [self.player pause];
            }
            
            Float64 totalSeconds = CMTimeGetSeconds(self.playerItem.duration);
            
            CMTime time = CMTimeMakeWithSeconds(CMTimeGetSeconds(self.player.currentTime) + totalSeconds * deltaProgress, self.playerItem.duration.timescale);
            
            CGFloat persent = (CMTimeGetSeconds(self.player.currentTime) + totalSeconds * deltaProgress) / totalSeconds;
            
            [self seekToTime:time progress:persent];
        }
    }

    if (self.headerView.alpha == 0.0f) {
        [self showToolBars];
    }else{
        [self cancelDelayHideHeaderAndFooterViewSelector:@selector(hideToolBars)];
    }
    
    
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    //延迟隐藏工具条
    if (self.headerView.alpha == 0.0f) {
        
    }else{
        [self delayHideHeaderViewAndFooterView];
    }
    
    self.draggingOnScreen = NO;
}

/**
 *  3D触摸事件(暂时不知道干啥的:-D)
 *
 *  @param touches
 */
- (void)touchesEstimatedPropertiesUpdated:(NSSet *)touches{
    
}
- (void)dealloc
{
    [self.playerItem removeObserver:self forKeyPath:@"status" context:playItemStatusContext];
}
@end
