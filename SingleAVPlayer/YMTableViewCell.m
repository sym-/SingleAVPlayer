//
//  YMTableViewCell.m
//  SingleAVPlayer
//
//  Created by 宋元明 on 16/5/27.
//  Copyright © 2016年 宋元明. All rights reserved.
//

#import "YMTableViewCell.h"
#import "UIImageView+WebCache.h"

NSString *const BtnSelectImage = @"TTpausea.png";
NSString *const BtnDeselectImage = @"TTplay.png";

@interface YMTableViewCell(){
    UITapGestureRecognizer *_tap;
}

@end

@implementation YMTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.playOrPauseBtn setImage:[UIImage imageNamed:BtnDeselectImage] forState:UIControlStateNormal];
    self.playOrPauseBtn.selected = NO;
    
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.bgImage setUserInteractionEnabled:YES];
    [self.bgImage addGestureRecognizer:_tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(YMVideoModel *)model{
    _model = model;
    
    self.title.text = model.title;
    self.duration.text = @"";
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    self.from.text = model.videosource;
    if (model.playCount > 99) {
        self.commentCount.text = @"99+";
    }
    else if (model.playCount <= 0){
        self.commentCount.text = @"";
    }
    else{
        self.commentCount.text = [NSString stringWithFormat:@"%ld",(long)model.playCount];
    }
}

-(void)tapAction{
    [self playOrPause:self.playOrPauseBtn];
}

- (IBAction)playOrPause:(UIButton *)sender {
    self.playOrPause(self.model);
}

@end
