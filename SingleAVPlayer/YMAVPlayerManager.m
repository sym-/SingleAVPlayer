//
//  YMAVPlayer.m
//  SingleAVPlayer
//
//  Created by 宋元明 on 16/5/27.
//  Copyright © 2016年 宋元明. All rights reserved.
//

#import "YMAVPlayerManager.h"


@interface YMAVPlayerManager()
{
    
}
@property (strong, nonatomic) YMAVPlayerView *playerView;
@property (copy, nonatomic) NSString *url;
@end

@implementation YMAVPlayerManager

static YMAVPlayerManager *manager;

-(void)setVideoModel:(YMVideoModel *)videoModel{
    _videoModel = videoModel;
    self.url = videoModel.mp4_url;
}

-(void)setUrl:(NSString *)url{
    _url = url;
    if (_playerView) {
        [self destroyPlayerView];
    }
    self.playerView.urlString = url;
}

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[super allocWithZone:NULL] init];
        };
    });
    
    return manager;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

-(id)init{
    if (self = [super init]) {
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    
    return self;
}

-(YMAVPlayerView *)playerView{
    if (!_playerView) {
        _playerView = [[YMAVPlayerView alloc] init];
    }
    
    return _playerView;
}

-(void)showVideoPlayerViewInView:(UIView *)view frame:(CGRect)frame{
    NSAssert(self.url != nil, @"必须先传入视频url！！！");
    self.playerView.frame = frame;
    [view addSubview:self.playerView];
}

-(void)destroyPlayerView{
    [self.playerView stop];
    _playerView = nil;
}

-(BOOL)videoPlayerViewExisted{
    if (_playerView) {
        return YES;
    }
    
    return NO;
}

#pragma mark -app生命周期
-(void)appWillResignActive{
    _playerView.inBackground = YES;
    [_playerView pause];
}

-(void)appDidBecomeActive{
    _playerView.inBackground = NO;
    [_playerView play];
}

#pragma mark - Screen Orientation

- (void)statusBarOrientationChange:(NSNotification *)notification {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationLandscapeLeft) {
        [_playerView orientationLeftFullScreen];
    }else if (orientation == UIDeviceOrientationLandscapeRight) {
        [_playerView orientationRightFullScreen];
    }else if (orientation == UIDeviceOrientationPortrait) {
        [_playerView smallScreen];
    }
}

-(void)dealloc{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
