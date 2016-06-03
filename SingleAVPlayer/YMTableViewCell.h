//
//  YMTableViewCell.h
//  SingleAVPlayer
//
//  Created by 宋元明 on 16/5/27.
//  Copyright © 2016年 宋元明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMVideoModel.h"

typedef NS_ENUM(NSInteger, PlayerState) {
    kPlay = 0,
    kStop
};

typedef void (^playOrPause) (PlayerState state);

extern NSString *const BtnSelectImage;

extern NSString *const BtnDeselectImage;

@interface YMTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UILabel *from;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;

@property (copy,nonatomic) playOrPause playOrPause;

@property (strong, nonatomic) YMVideoModel *model;

@end
