//
//  YMSlider.m
//  SingleAVPlayer
//
//  Created by 宋元明 on 16/5/27.
//  Copyright © 2016年 宋元明. All rights reserved.
//

#import "YMSlider.h"

static CGFloat PanDistance;

@interface LayerDelegate : NSObject

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat middleValue;
@property (nonatomic, assign) CGFloat lineLength;
@property (nonatomic, assign) CGFloat sliderDiameter;
@property (nonatomic, strong) UIColor *sliderColor;
@property (nonatomic, strong) UIColor *maxColor;
@property (nonatomic, strong) UIColor *middleColor;
@property (nonatomic, strong) UIColor *minColor;

@end

@implementation LayerDelegate

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    //max
    CGMutablePathRef maxPath = CGPathCreateMutable();
    CGPathMoveToPoint(maxPath, NULL, PanDistance+self.sliderDiameter, self.centerY);
    CGPathAddLineToPoint(maxPath, NULL, self.lineLength, self.centerY);
    CGContextSetStrokeColorWithColor(ctx, self.maxColor.CGColor);
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextAddPath(ctx, maxPath);
    CGPathCloseSubpath(maxPath);
    CGContextStrokePath(ctx);
    CGPathRelease(maxPath);
    
    //middle
    CGMutablePathRef middlePath = CGPathCreateMutable();
    CGPathMoveToPoint(middlePath, NULL, 0, self.centerY);
    CGPathAddLineToPoint(middlePath, NULL, self.middleValue * self.lineLength, self.centerY);
    CGContextSetStrokeColorWithColor(ctx, self.middleColor.CGColor);
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextAddPath(ctx, middlePath);
    CGPathCloseSubpath(middlePath);
    CGContextStrokePath(ctx);
    CGPathRelease(middlePath);
    
    //min
    CGMutablePathRef minPath = CGPathCreateMutable();
    CGPathMoveToPoint(minPath, NULL, 0, self.centerY);
    CGPathAddLineToPoint(minPath, NULL, PanDistance, self.centerY);
    CGContextSetStrokeColorWithColor(ctx, self.minColor.CGColor);
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextAddPath(ctx, minPath);
    CGPathCloseSubpath(minPath);
    CGContextStrokePath(ctx);
    CGPathRelease(minPath);
    
    //point
    CGMutablePathRef pointPath = CGPathCreateMutable();
    CGPathAddEllipseInRect(pointPath, NULL, CGRectMake(PanDistance, self.centerY - self.sliderDiameter/2.0, self.sliderDiameter, self.sliderDiameter));
    CGContextSetFillColorWithColor(ctx, self.sliderColor.CGColor);
    CGContextAddPath(ctx, pointPath);
    CGPathCloseSubpath(pointPath);
    CGContextFillPath(ctx);
    CGPathRelease(pointPath);
}

-(void)dealloc{
    NSLog(@"slider delegate dealloc");
}

@end

@interface YMSlider (){
    CALayer *_lineLayer;
    LayerDelegate *_delegate;
}

@end

@implementation YMSlider

@synthesize sliderColor=_sliderColor, lineWidth=_lineWidth, minColor=_minColor, middleColor=_middleColor, maxColor=_maxColor, sliderDiameter=_sliderDiameter;

-(instancetype)init{
    if (self = [super init]) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [self addGestureRecognizer:pan];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
        [tap requireGestureRecognizerToFail:pan];
        
        _delegate = [[LayerDelegate alloc] init];
        _delegate.maxColor = self.maxColor;
        _delegate.middleColor = self.middleColor;
        _delegate.minColor = self.minColor;
        _delegate.sliderDiameter = self.sliderDiameter;
        _delegate.sliderColor = self.sliderColor;
        _delegate.lineWidth = self.lineWidth;
        
        _lineLayer = [CALayer layer];
        _lineLayer.delegate = _delegate;
        [self.layer addSublayer:_lineLayer];
        [_lineLayer setNeedsDisplay];
        
        [self addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"middleValue" options:NSKeyValueObservingOptionNew context:nil];
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _delegate.centerY = self.frame.size.height / 2.0f;
    _delegate.lineLength = self.frame.size.width;
    _lineLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [_lineLayer setNeedsDisplay];
}

#pragma mark -KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"value"]){
        [_lineLayer setNeedsDisplay];
        if (self.valueChangeBlock) {
            self.valueChangeBlock(self);
        }
    }
    if ([keyPath isEqualToString:@"middleValue"]) {
        [_lineLayer setNeedsDisplay];
    }
}

#pragma mark - Gesture action
- (void)panAction:(UIPanGestureRecognizer *)panGesture {
    
    CGFloat detalX = [panGesture translationInView:self].x;
    PanDistance += detalX;
    //Limited the sliding
    PanDistance = PanDistance >= 0 ? PanDistance : 0;
    PanDistance = PanDistance <= (self.frame.size.width - self.sliderDiameter) ? PanDistance : (self.frame.size.width - self.sliderDiameter);
    
    [panGesture setTranslation:CGPointZero inView:self];
    
    self.value = PanDistance / (self.frame.size.width - self.sliderDiameter);
    
    if (panGesture.state ==  UIGestureRecognizerStateEnded && self.finishChangeBlock) {
        self.finishChangeBlock(self);
        
    }else if((panGesture.state == UIGestureRecognizerStateChanged || UIGestureRecognizerStateBegan) && self.draggingSliderBlock) {
        self.draggingSliderBlock(self);
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tapGesture {
    
    CGPoint location = [tapGesture locationInView:self];
    PanDistance = location.x;
    self.value =  PanDistance / (self.frame.size.width - self.sliderDiameter);
    if (self.finishChangeBlock) {
        self.finishChangeBlock(self);
    }
}

#pragma mark setter and getter
- (void)setSliderColor:(UIColor *)sliderColor {
    _sliderColor = sliderColor;
    _delegate.sliderColor = _sliderColor;
}

- (UIColor *)sliderColor {
    if (!_sliderColor) {
        return [UIColor whiteColor];
    }
    return _sliderColor;
}

- (void)setSliderDiameter:(CGFloat)sliderDiameter {
    _sliderDiameter = sliderDiameter;
    _delegate.sliderDiameter = sliderDiameter;
}

- (CGFloat)sliderDiameter {
    if (!_sliderDiameter) {
        return 10.0f;
    }
    return _sliderDiameter;
}

- (void)setMinColor:(UIColor *)minColor {
    _minColor = minColor;
    _delegate.minColor = minColor;
}

- (UIColor *)minColor {
    if (!_minColor) {
        return [UIColor redColor];
    }
    return _minColor;
}

- (void)setMaxColor:(UIColor *)maxColor {
    _maxColor = maxColor;
    _delegate.maxColor = maxColor;
}

- (UIColor *)maxColor {
    if (!_maxColor) {
        return [UIColor grayColor];
    }
    return _maxColor;
}

- (void)setMiddleColor:(UIColor *)middleColor {
    _middleColor = middleColor;
    _delegate.middleColor = middleColor;
}

- (UIColor *)middleColor {
    if (!_middleColor) {
        return  [UIColor lightGrayColor];
    }
    return _middleColor;
}

- (CGFloat)lineWidth {
    if (!_lineWidth) {
        return 1.0f;
    }
    return _lineWidth;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    _delegate.lineWidth = lineWidth;
}

-(void)setMiddleValue:(CGFloat)middleValue {
    _middleValue = middleValue;
    _delegate.middleValue = middleValue;
}

- (void)setValue:(CGFloat)value {
    _value = value;
    PanDistance = value * (self.frame.size.width - self.sliderDiameter);
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"value"];
    [self removeObserver:self forKeyPath:@"middleValue"];
    PanDistance = 0.0;
    NSLog(@"slider -- dealloc");
}


@end
