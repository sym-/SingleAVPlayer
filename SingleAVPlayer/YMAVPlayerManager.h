//
//  YMAVPlayer.h
//  SingleAVPlayer
//
//  Created by 宋元明 on 16/5/27.
//  Copyright © 2016年 宋元明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMAVPlayerView.h"

@interface YMAVPlayerManager : NSObject

+(instancetype)sharedInstance;

-(void)play;

-(void)pause;

-(void)show;

-(void)destroy;

-(void)videoURL;

@property (strong, nonatomic) YMAVPlayerView *playerView;


@end
