//
//  YMAVPlayerView.m
//  SingleAVPlayer
//
//  Created by 宋元明 on 16/5/27.
//  Copyright © 2016年 宋元明. All rights reserved.
//

#import "YMAVPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "YMSlider.h"
#import "Masonry.h"
#import "YMTableViewCell.h"

static const CGFloat LabelFont = 12;
static const CGFloat BottomViewHeight = 40;
static const CGFloat BottomViewAnimationTime = 0.5;
static const CGFloat BottomViewShowTime = 4;
static const CGFloat PlayOrPauseBtnSize = 60;
static const CGFloat BottomOpacity = 0.7;
//#define ScreenWidth [UIScreen mainScreen].bounds.size.width;

@interface YMAVPlayerView()
{
    
}

@property (strong, nonatomic) AVPlayerItem *playerItem;

@property (strong, nonatomic) AVPlayer *player;

@property (strong, nonatomic) AVPlayerLayer *playerLayer;

//UI
@property (strong, nonatomic) UIButton *playOrPauseBtn;

@property (strong, nonatomic) UIView *bottomView;

@property (strong, nonatomic) UILabel *totalTimeLabel;

@property (strong, nonatomic) UILabel *progressLabel;

@property (strong, nonatomic) YMSlider *slider;

@property (strong, nonatomic) UIButton *scaleBtn;

@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@property (assign, nonatomic) CGRect originFrame;


@end

@implementation YMAVPlayerView

-(id)init{
    if (self = [super init]) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHideBottomBar)];
        [self addGestureRecognizer:tapRecognizer];
        
        [self addSubview:self.playOrPauseBtn];
        [self addSubview:self.bottomView];
        [self addSubview:self.indicatorView];
    }
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    //设置frame
    self.originFrame = self.frame;
    self.playerLayer.frame = self.bounds;
    self.bottomView.frame = CGRectMake(0, self.frame.size.height-BottomViewHeight, self.frame.size.width ,BottomViewHeight);
    self.playOrPauseBtn.frame = CGRectMake((self.frame.size.width - PlayOrPauseBtnSize) / 2, (self.frame.size.height - PlayOrPauseBtnSize) / 2, PlayOrPauseBtnSize, PlayOrPauseBtnSize);
    self.indicatorView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
}

-(void)showOrHideBottomBar{
    
}

-(void)scaleView:(UIButton *)btn{
    
}

-(void)playOrPause:(UIButton *)btn{
    
}

#pragma mark - PlayerItem （status，loadedTimeRanges）
-(void)addProgressObserver{
    //get current playerItem object
    AVPlayerItem *playerItem = self.player.currentItem;
    __weak typeof(self) weakSelf = self;
    
    //Set once per second
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0f, 1.0f) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
//        
//        float current = CMTimeGetSeconds(time);
//        weakSelf.current = current;
//        float total = CMTimeGetSeconds([playerItem duration]);
//        weakSelf.progressLabel.text = [weakSelf timeFormatted:current];
//        if (current) {
//            //            NSLog(@"current --- %f", current );
//            weakSelf.slider.value = current / total;
//            
//            if (weakSelf.slider.value == 1.0f) {      //complete block
//                if (weakSelf.completedPlayingBlock) {
//                    [weakSelf setStatusBarHidden:NO];
//                    if ( weakSelf.completedPlayingBlock) {
//                        weakSelf.completedPlayingBlock(weakSelf);
//                    }
//                    weakSelf.completedPlayingBlock = nil;
//                }else {       //finish and loop playback
//                    weakSelf.playOrPauseBtn.selected = NO;
//                    [weakSelf showOrHidenBar];
//                    CMTime currentCMTime = CMTimeMake(0, 1);
//                    [weakSelf.player seekToTime:currentCMTime completionHandler:^(BOOL finished) {
//                        weakSelf.slider.value = 0.0f;
//                    }];
//                }
//            }
//        }
    }];
}

-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //network loading progress
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

/**
 *  通过KVO监控播放器状态
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem = object;
//    if ([keyPath isEqualToString:@"status"]) {
//        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
//        if(status == AVPlayerStatusReadyToPlay){
//            self.totalDuration = CMTimeGetSeconds(playerItem.duration);
//            self.totalDurationLabel.text = [self timeFormatted:self.totalDuration];
//        }
//    }
//    else if([keyPath isEqualToString:@"loadedTimeRanges"]){
//        NSArray *array = playerItem.loadedTimeRanges;
//        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
//        float startSeconds = CMTimeGetSeconds(timeRange.start);
//        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
//        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
//        self.slider.middleValue = totalBuffer / CMTimeGetSeconds(playerItem.duration);
//        //        NSLog(@"totalBuffer：%.2f",totalBuffer);
//        
//        //loading animation
//        if (self.slider.middleValue  <= self.slider.value || (totalBuffer - 1.0) < self.current) {
//            NSLog(@"正在缓冲...");
//            self.activityIndicatorView.hidden = NO;
//            //            self.activityIndicatorView.center = self.center;
//            [self.activityIndicatorView startAnimating];
//        }else {
//            self.activityIndicatorView.hidden = YES;
//            if (self.playOrPauseBtn.selected) {
//                [self.player play];
//            }
//        }
//    }
}

#pragma mark - timeFormat
- (NSString *)timeFormatted:(int)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}


#pragma mark 懒加载
-(void)setUrlString:(NSString *)urlString{
    _urlString = urlString;
    
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor blackColor];
        
        //progress label
        UILabel *progress = [[UILabel alloc] init];
        progress.translatesAutoresizingMaskIntoConstraints = NO;
        progress.font = [UIFont systemFontOfSize:LabelFont];
        progress.textColor = [UIColor whiteColor];
        self.progressLabel = progress;
        [_bottomView addSubview:progress];
        [progress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bottomView).with.offset(0);
            make.left.equalTo(_bottomView).with.offset(0);
            make.bottom.equalTo(_bottomView).with.offset(0);
            make.size.width.mas_equalTo(@65);
        }];
        
        //slider
        YMSlider *slider = [[YMSlider alloc] init];
        slider.translatesAutoresizingMaskIntoConstraints = NO;
        [_bottomView addSubview:slider];
        self.slider = slider;
        [slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(progress).with.offset(0);
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
        self.totalTimeLabel = total;
        [_bottomView addSubview:total];
        [total mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(slider).with.offset(0);
            make.top.equalTo(_bottomView).with.offset(0);
            make.bottom.equalTo(_bottomView).with.offset(0);
            make.width.mas_equalTo(@65);
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
            make.left.equalTo(total).with.offset(0);
            make.right.equalTo(total).with.offset(0);
            make.centerY.equalTo(_bottomView).width.offset(0);
            make.width.mas_equalTo(@40);
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
//        AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:[NSURL URLWithString:[self.urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:[NSURL  URLWithString:[self.urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]]];

        return playerItem;
    }
    else{
        AVAsset *movieAsset  = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:self.urlString] options:nil];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        return playerItem;
    }
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

@end
