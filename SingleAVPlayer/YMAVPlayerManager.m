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

@end

@implementation YMAVPlayerManager

static YMAVPlayerManager *manager;

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

#pragma mark -app生命周期
-(void)appWillResignActive{
    
}

-(void)appDidBecomeActive{
    
}

@end
