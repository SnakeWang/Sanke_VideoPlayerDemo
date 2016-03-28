//
//  WYLPlayerView.m
//  VideoPlayer
//
//  Created by Snake on 16/3/14.
//  Copyright © 2016年 Snake. All rights reserved.
//

#import "WYLPlayerView.h"

@implementation WYLPlayerView

+ (Class)layerClass
{
    return [AVPlayerLayer class];

}
- (AVPlayer *)player
{
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player
{
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}
@end
