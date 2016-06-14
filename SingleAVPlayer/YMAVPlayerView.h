//
//  YMAVPlayerView.h
//  SingleAVPlayer
//
//  Created by 宋元明 on 16/5/27.
//  Copyright © 2016年 宋元明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMSlider.h"
#import <AVFoundation/AVFoundation.h>

@class YMAVPlayerView;

typedef void (^VideoCompletedPlayingBlock) (YMAVPlayerView *videoPlayer);

@interface YMAVPlayerView : UIView

@property (copy, nonatomic) NSString *urlString;

@property (nonatomic, assign) BOOL inBackground;

@property (nonatomic, copy) VideoCompletedPlayingBlock completedPlayingBlock;

-(void)stop;

-(void)play;

-(void)pause;

- (void)orientationLeftFullScreen;

- (void)orientationRightFullScreen;

- (void)smallScreen;

@end
