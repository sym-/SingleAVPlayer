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

@property (copy, nonatomic) NSString *url;

+(instancetype)sharedInstance;

-(BOOL)videoPlayerViewExisted;

-(void)showVideoPlayerViewInView:(UIView *)view frame:(CGRect)frame;

-(void)destroyPlayerView;


@end
