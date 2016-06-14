//
//  YMAVPlayerView.m
//  SingleAVPlayer
//
//  Created by 宋元明 on 16/5/27.
//  Copyright © 2016年 宋元明. All rights reserved.
//

#import "YMAVPlayerView.h"
#import "YMSlider.h"
#import "Masonry.h"
#import "YMTableViewCell.h"
#import "UIView+Extension.h"

static const CGFloat LabelFont = 12;
static const CGFloat BottomViewHeight = 30;
static const CGFloat BottomViewAnimationTime = 0.5;
static const CGFloat BottomViewShowTime = 4;
static const CGFloat PlayOrPauseBtnSize = 30;
static const CGFloat BottomOpacity = 0.7;
//#define ScreenWidth [UIScreen mainScreen].bounds.size.width;

@interface YMAVPlayerView()
{

}

@property (strong, nonatomic) AVPlayerItem *playerItem;

@property (strong, nonatomic) AVPlayer *player;

@property (strong, nonatomic) AVPlayerLayer *playerLayer;

@property (strong, nonatomic) id progressObserver;

@property (strong, nonatomic) UIWindow *keyWindow;

//UI
@property (strong, nonatomic) UIButton *playOrPauseBtn;

@property (strong, nonatomic) UIView *bottomView;

@property (strong, nonatomic) UILabel *totalTimeLabel;

@property (strong, nonatomic) UILabel *progressLabel;

@property (strong, nonatomic) YMSlider *slider;

@property (strong, nonatomic) UIButton *scaleBtn;

@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@property (strong, nonatomic) UIView *blindView;

@property (assign, nonatomic) CGRect originFrame;

@property (assign, nonatomic) CGFloat current;

@property (assign, nonatomic) CGFloat total;

@property (assign, nonatomic) BOOL inOperation;

@property (assign, nonatomic) BOOL notInitialFrame;

@property (assign, nonatomic) AVPlayerStatus currentStatus;

@end

@implementation YMAVPlayerView

-(id)init{
    if (self = [super init]) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHideBottomView)];
        [self addGestureRecognizer:tapRecognizer];
        
        [self addSubview:self.playOrPauseBtn];
        [self addSubview:self.bottomView];
        [self addSubview:self.indicatorView];
    }
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    //初始化设置frame
    if (!_notInitialFrame) {
        self.originFrame = self.frame;        
        self.bottomView.frame = CGRectMake(0, self.frame.size.height-BottomViewHeight, self.frame.size.width ,BottomViewHeight);
        self.playOrPauseBtn.frame = CGRectMake((self.frame.size.width - PlayOrPauseBtnSize) / 2, (self.frame.size.height - PlayOrPauseBtnSize) / 2, PlayOrPauseBtnSize, PlayOrPauseBtnSize);
        self.indicatorView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
        
        _notInitialFrame = YES;
    }
    self.playerLayer.frame = self.bounds;
}

-(void)scaleView:(UIButton *)btn{
    if (!btn.selected) {
        [self orientationLeftFullScreen];
//        [self orientationRightFullScreen];
    }
    else{
        [self smallScreen];
    }
    btn.selected = !btn.selected;
}

- (void)orientationLeftFullScreen {
    self.blindView = self.superview;
    [self.keyWindow addSubview:self];    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeRotation(M_PI / 2);
        self.frame = self.keyWindow.bounds;
        
        self.bottomView.frame = CGRectMake(0, self.keyWindow.bounds.size.width - BottomViewHeight, self.keyWindow.bounds.size.height, BottomViewHeight);
        self.playOrPauseBtn.frame = CGRectMake((self.keyWindow.bounds.size.height - PlayOrPauseBtnSize) / 2, (self.keyWindow.bounds.size.width - PlayOrPauseBtnSize) / 2, PlayOrPauseBtnSize, PlayOrPauseBtnSize);
        self.indicatorView.center = CGPointMake(self.keyWindow.bounds.size.height / 2, self.keyWindow.bounds.size.width / 2);
        [self updateConstraintsIfNeeded];
    }];
    
    [self setStatusBarHidden:YES];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];

}

- (void)orientationRightFullScreen {
    self.blindView = self.superview;
    [self.keyWindow addSubview:self];
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeRight] forKey:@"orientation"];
    
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        self.frame = self.keyWindow.bounds;
        self.bottomView.frame = CGRectMake(0, self.keyWindow.bounds.size.width - BottomViewHeight, self.keyWindow.bounds.size.height, BottomViewHeight);
        self.playOrPauseBtn.frame = CGRectMake((self.keyWindow.bounds.size.height - PlayOrPauseBtnSize) / 2, (self.keyWindow.bounds.size.width - PlayOrPauseBtnSize) / 2, PlayOrPauseBtnSize, PlayOrPauseBtnSize);
        self.indicatorView.center = CGPointMake(self.keyWindow.bounds.size.height / 2, self.keyWindow.bounds.size.width / 2);
    }];
    [self setStatusBarHidden:YES];
}

- (void)smallScreen {
    if (self.blindView) {
        [self.blindView addSubview:self];
        self.blindView = nil;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = self.originFrame;
        self.bottomView.frame = CGRectMake(0, self.originFrame.size.height - BottomViewHeight, self.self.originFrame.size.width, BottomViewHeight);
        self.playOrPauseBtn.frame = CGRectMake((self.originFrame.size.width - PlayOrPauseBtnSize) / 2, (self.originFrame.size.height - PlayOrPauseBtnSize) / 2, PlayOrPauseBtnSize, PlayOrPauseBtnSize);
        self.indicatorView.center = CGPointMake(self.originFrame.size.width / 2, self.originFrame.size.height / 2);
        [self updateConstraintsIfNeeded];
    }];
    [self setStatusBarHidden:NO];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
}

-(void)play{
    [self.player play];
}

-(void)pause{
   [self.player pause];
}

-(void)stop{
    [self pause];
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    
    self.current = 0.0;
    self.total = 0.0;
    self.slider.value = 0.0;
    self.blindView = nil;
    
    [self removeFromSuperview];
}

-(void)playOrPause:(UIButton *)btn{
    BOOL selected = btn.selected;
    if (selected) {
        [self pause];
    }
    else{
        [self play];
    }
    btn.selected = !btn.selected;
}

#pragma mark - PlayerItem （status，loadedTimeRanges）
-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //network loading progress
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)addProgressObserver{
    //get current playerItem object
    AVPlayerItem *playerItem = self.player.currentItem;
    __weak typeof(self) weakSelf = self;
    
    //Set once per second
    self.progressObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0f, 1.0f) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        float current = CMTimeGetSeconds(time);
        weakSelf.current = current;
        float total = CMTimeGetSeconds([playerItem duration]);
        weakSelf.total = total;
        if (current) {
            weakSelf.slider.value = current / total;
            if (weakSelf.slider.value == 1.0f) {      //complete block
                if (weakSelf.completedPlayingBlock) {
                    [weakSelf setStatusBarHidden:NO];
                    if ( weakSelf.completedPlayingBlock) {
                        weakSelf.completedPlayingBlock(weakSelf);
                    }
                    weakSelf.completedPlayingBlock = nil;
                }
                else {       //finish and loop playback
                    weakSelf.playOrPauseBtn.selected = NO;
                    [weakSelf showOrHideBottomView];
                    CMTime currentCMTime = CMTimeMake(0, 1);
                    [weakSelf.player seekToTime:currentCMTime completionHandler:^(BOOL finished) {
                        weakSelf.slider.value = 0.0f;
                    }];
                }
            }
        }
    }];
}

/**
 *  通过KVO监控播放器状态
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if(status == AVPlayerStatusReadyToPlay){
            CGFloat totalDuration = CMTimeGetSeconds(playerItem.duration);
            self.totalTimeLabel.text = [self timeFormatted:totalDuration];
            [self showOrHideBottomView];
            [self hideIndicator];
            self.playOrPauseBtn.selected = YES;
            self.currentStatus = AVPlayerStatusReadyToPlay;
        }
        else{
            self.currentStatus = AVPlayerStatusUnknown;
        }
    }
    else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array = playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        self.slider.middleValue = totalBuffer / CMTimeGetSeconds(playerItem.duration);
        
        //loading animation
        if (self.slider.middleValue  <= self.slider.value || (totalBuffer - 1.0) < self.current) {
            NSLog(@"正在缓冲...");
            [self showIndicator];
        }
        else {
            [self hideIndicator];
            if (self.playOrPauseBtn.selected && !self.inBackground) {
                [self play];
            }
        }
    }
}

#pragma mark - status/title and bottom hiden
- (void)setStatusBarHidden:(BOOL)hidden {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    statusBar.hidden = hidden;
}

- (void)showOrHideBottomView {
    if (self.bottomView.hidden) {
        [self showBottomViewAndTitle];
    }else {
        [self hideBottomViewAndTitle];
    }
}

-(void)showBottomViewAndTitle{
    self.bottomView.hidden = NO;
    if (self.currentStatus == AVPlayerStatusReadyToPlay) {
        self.playOrPauseBtn.hidden = NO;
    }
    
    [UIView animateWithDuration:BottomViewAnimationTime animations:^{
        self.bottomView.layer.opacity = 1.0;
        if (self.currentStatus == AVPlayerStatusReadyToPlay) {
            self.playOrPauseBtn.layer.opacity = 1.0;
        }
        
    } completion:^(BOOL finished) {
        if (finished) {
            [self performBlock:^{
                if (!self.self.bottomView.hidden && !self.inOperation) {
                    [self hideBottomViewAndTitle];
                }
            } afterDelay:BottomViewShowTime];
        }
    }];
}

-(void)hideBottomViewAndTitle{
    self.inOperation = NO;
    [UIView animateWithDuration:BottomViewAnimationTime animations:^{
        self.bottomView.layer.opacity = 0.0f;
        self.playOrPauseBtn.layer.opacity = 0.0f;
    } completion:^(BOOL finished){
        if (finished) {
            self.playOrPauseBtn.hidden = YES;
            self.bottomView.hidden = YES;
        }
    }];
}

-(void)showIndicator{
    self.indicatorView.hidden = NO;
    self.indicatorView.center = self.center;
    [self.indicatorView startAnimating];
    self.playOrPauseBtn.opaque = 0.0;
    self.playOrPauseBtn.hidden = YES;
}

-(void)hideIndicator{
    [self.indicatorView stopAnimating];
    self.indicatorView.hidden = YES;
    self.playOrPauseBtn.opaque = 1.0;
    self.playOrPauseBtn.hidden = NO;
}

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay {
    [self performSelector:@selector(callBlockAfterDelay:) withObject:block afterDelay:delay];
}

- (void)callBlockAfterDelay:(void (^)(void))block {
    block();
}

#pragma mark slider call back
- (void)sliderValueChange:(YMSlider *)slider {
    NSString *time = [self timeFormatted:slider.value * self.total];
    NSLog(@"time:%f",[self.totalTimeLabel.text doubleValue]);
    self.progressLabel.text = time;
}

- (void)finishChange {
    self.inOperation = NO;
    [self performBlock:^{
        if (!self.bottomView.hidden && !self.inOperation) {
            [self hideBottomViewAndTitle];
        }
    } afterDelay:BottomViewShowTime];
    
    [self pause];
    
    CMTime currentCMTime = CMTimeMake(self.slider.value * self.total, 1);
    if (self.slider.middleValue) {
        [self.player seekToTime:currentCMTime completionHandler:^(BOOL finished) {
            [self play];
            self.playOrPauseBtn.selected = YES;
        }];
    }
}

//Dragging the thumb to suspend video playback
- (void)dragSlider {
    self.inOperation = YES;
    [self.player pause];
}


-(void)dealloc{
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.player removeTimeObserver:self.progressObserver];
    
    NSLog(@"playerview -- dealloc");
}

#pragma mark - timeFormat
- (NSString *)timeFormatted:(int)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;

    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}


#pragma mark 懒加载
-(void)setUrlString:(NSString *)urlString{
    _urlString = urlString;
    [self.layer insertSublayer:self.playerLayer atIndex:0];
    [self play];
    [self showIndicator];
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:BottomOpacity];
        
        //progress label
        UILabel *progress = [[UILabel alloc] init];
        progress.translatesAutoresizingMaskIntoConstraints = NO;
        progress.font = [UIFont systemFontOfSize:LabelFont];
        progress.textColor = [UIColor whiteColor];
        progress.textAlignment = NSTextAlignmentRight;
        progress.text = @"00:00";
        [progress sizeToFit];
        self.progressLabel = progress;
        [_bottomView addSubview:progress];
        [progress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bottomView).with.offset(0);
            make.left.equalTo(_bottomView).with.offset(10);
            make.bottom.equalTo(_bottomView).with.offset(0);
            make.width.mas_equalTo(@(CGRectGetWidth(progress.frame) + 2));
        }];
        
        //slider
        __weak typeof(self) weakSelf = self;
        YMSlider *slider = [[YMSlider alloc] init];
        slider.translatesAutoresizingMaskIntoConstraints = NO;
        [_bottomView addSubview:slider];
        slider.draggingSliderBlock = ^(YMSlider *slider){
            [weakSelf dragSlider];
        };
        slider.finishChangeBlock = ^(YMSlider *slider){
            [weakSelf finishChange];
        };
        slider.valueChangeBlock = ^(YMSlider *slider){
            [weakSelf sliderValueChange:slider];
        };
        self.slider = slider;
        [slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(progress.mas_right).with.offset(10);
            make.top.equalTo(_bottomView).with.offset(0);
            make.bottom.equalTo(_bottomView).with.offset(0);
        }];
        [slider setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [slider setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        
        
        //total label
        UILabel *total = [[UILabel alloc] init];
        total.translatesAutoresizingMaskIntoConstraints = NO;
        total.font = [UIFont systemFontOfSize:LabelFont];
        total.textColor = [UIColor whiteColor];
        total.text = @"00:00";
        [total sizeToFit];
        self.totalTimeLabel = total;
        [_bottomView addSubview:total];
        [total mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(slider.mas_right).with.offset(10);
            make.top.equalTo(_bottomView).with.offset(0);
            make.bottom.equalTo(_bottomView).with.offset(0);
            make.width.mas_equalTo(@(CGRectGetWidth(total.frame) + 2));
        }];
        
        //scale button
        UIButton *scale = [UIButton buttonWithType:UIButtonTypeCustom];
        [scale setImage:[UIImage imageNamed:@"TTshrink"] forState:UIControlStateSelected];
        [scale setImage:[UIImage imageNamed:@"TTblowup"] forState:UIControlStateNormal];
        scale.translatesAutoresizingMaskIntoConstraints = NO;
        scale.contentMode = UIViewContentModeCenter;
        [scale addTarget:self action:@selector(scaleView:) forControlEvents:UIControlEventTouchUpInside];
        self.scaleBtn = scale;
        [_bottomView addSubview:scale];
        [scale mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(total.mas_right).with.offset(10);
            make.right.equalTo(_bottomView.mas_right).with.offset(-10);
            make.top.equalTo(_bottomView).with.offset(0);
            make.bottom.equalTo(_bottomView).with.offset(0);
            make.width.mas_equalTo(@20);
        }];
        
        [self updateConstraintsIfNeeded];
    }
    
    return _bottomView;
}

-(UIButton *)playOrPauseBtn{
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playOrPauseBtn.contentMode = UIViewContentModeCenter;
        [_playOrPauseBtn setImage:[UIImage imageNamed:BtnSelectImage] forState:UIControlStateSelected];
        [_playOrPauseBtn setImage:[UIImage imageNamed:BtnDeselectImage] forState:UIControlStateNormal];
        [_playOrPauseBtn addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _playOrPauseBtn;
}

-(UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    
    return _indicatorView;
}

//AVPlayerItem
- (AVPlayerItem *)getAVPlayItem{
    
    NSAssert(self.urlString != nil, @"必须先传入视频url！！！");
    
    if ([self.urlString rangeOfString:@"http"].location != NSNotFound) {
        AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:[NSURL URLWithString:[self.urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        return playerItem;
    }else{
        AVAsset *movieAsset  = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:self.urlString] options:nil];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        return playerItem;
    }
    
//    AVAsset *movieAsset  = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:self.urlString] options:nil];
//    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
//    
//    return playerItem;
}

-(AVPlayer *)player{
    if (!_player) {
        AVPlayerItem *playerItem = [self getAVPlayItem];
        self.playerItem = playerItem;
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        
        [self addProgressObserver];
        
        [self addObserverToPlayerItem:playerItem];
        
        // 解决8.1系统播放无声音问题，8.0、9.0以上未发现此问题
        AVAudioSession * session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
    }
    
    return _player;
}

- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.backgroundColor = [UIColor blackColor].CGColor;
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;//视频填充模式
        
    }
    return _playerLayer;
}

-(UIWindow *)keyWindow{
    if (!_keyWindow) {
        _keyWindow = [[UIApplication sharedApplication] keyWindow];
    }
    
    return _keyWindow;
}

@end
