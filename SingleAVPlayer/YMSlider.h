//
//  YMSlider.h
//  SingleAVPlayer
//
//  Created by 宋元明 on 16/5/27.
//  Copyright © 2016年 宋元明. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YMSlider;

typedef void (^SliderValueChangeBlock) (YMSlider *slider);
typedef void (^SliderFinishChangeBlock) (YMSlider *slider);
typedef void (^DraggingSliderBlock) (YMSlider *slider);

@interface YMSlider : UIView

@property (nonatomic, assign) CGFloat value; //0-1
@property (nonatomic, assign) CGFloat middleValue; //0-1

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat sliderDiameter;

@property (strong, nonatomic) UIColor *sliderColor;
@property (strong, nonatomic) UIColor *maxColor;
@property (strong, nonatomic) UIColor *middleColor;
@property (strong, nonatomic) UIColor *minColor;

@property (nonatomic, copy) SliderValueChangeBlock valueChangeBlock;
@property (nonatomic, copy) SliderFinishChangeBlock finishChangeBlock;
@property (nonatomic, strong) DraggingSliderBlock draggingSliderBlock;

@end
