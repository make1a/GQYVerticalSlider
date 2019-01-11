//
//  MKVerticalSlider.m
//  MKSlider
//
//  Created by Make on 2019/1/11.
//  Copyright © 2019 Make. All rights reserved.
//

#import "GQYVerticalSlider.h"
#import "Masonry.h"
@interface GQYVerticalSlider()<CAAnimationDelegate>
@property (nonatomic,strong)UIImageView *minImageView;
@property (nonatomic,strong)UIImageView *maxImageView;
@property (nonatomic,strong)UIImageView * thumbImageView;

//maskView
@property (nonatomic,strong)CAShapeLayer * maskLayer;

@property (nonatomic,strong)UIPanGestureRecognizer * recognizer;

@property (nonatomic,strong)CABasicAnimation * ani;
@end
@implementation GQYVerticalSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self masLayoutSubviews];
        [self addPan];
        self.maximumValue = 1.0;
        self.minimumValue = 0;
        [self confiMask];
    }
    return self;
}



#pragma  mark - UI
- (void)confiMask{
    CGRect bounds = self.bounds;
    bounds.size.height = self.frame.size.height;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:bounds];
    self.maskLayer.path = path.CGPath;
//    self.maskLayer.frame = bounds;
    self.minImageView.layer.mask = self.maskLayer;
    
}
- (void)masLayoutSubviews{
    
    [self addSubview:self.maxImageView];
    [self addSubview:self.minImageView];
    [self addSubview:self.thumbImageView];
    
    [self.minImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.maxImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.minImageView);
    }];
    
    [self.thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];
    

    
    
}

- (void)addPan{
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveSlider:)];
    [self.thumbImageView addGestureRecognizer:recognizer];
    self.recognizer = recognizer;
}

- (void)setValue:(float)value animated:(BOOL)animated{
    if (value<self.minimumValue) {
        value = self.minimumValue;
        return;
    }
    _value = value;
    if (animated == YES) {

        [UIView animateWithDuration:.1 animations:^{
            CGFloat p = self.frame.size.height * (1-((value-self.minimumValue)/(self.maximumValue-self.minimumValue)));
            CGPoint center = CGPointMake(self.thumbImageView.center.x, p);
            self.thumbImageView.center = center;
        }];

        CABasicAnimation *aniY = [CABasicAnimation animationWithKeyPath:@"position.y"];
        CGRect bounds = self.bounds;
        bounds.size.height = self.frame.size.height * (((value-self.minimumValue)/(self.maximumValue-self.minimumValue)));
        aniY.toValue = @(-bounds.size.height);
        aniY.delegate = self;
        aniY.removedOnCompletion = NO;
        aniY.duration = .1;
        [self.minImageView.layer.mask addAnimation:aniY forKey:@"aniY"];

    }else{
        [self fillWithValue:value];
        CGFloat p = self.frame.size.height * (1-((value-self.minimumValue)/(self.maximumValue-self.minimumValue)));
        CGPoint center = CGPointMake(self.thumbImageView.center.x, p);
        self.thumbImageView.center = center;
    }

}

- (void)fillWithValue:(CGFloat)value{
    if (value<self.minimumValue) {
        value = self.minimumValue;
        return;
    }
    _value = value;
    CGRect bounds = self.bounds;
    bounds.size.height = self.frame.size.height * (1-((value-self.minimumValue)/(self.maximumValue-self.minimumValue)));
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:bounds];
    self.maskLayer.path = path.CGPath;
}

#pragma  mark - Animation Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
   CAAnimation *ani = [self.maskLayer animationForKey:@"aniY"];
    if (flag && ani==anim) {
        [self fillWithValue:_value];
        [self.maskLayer removeAnimationForKey:@"aniY"];
    }
}
#pragma  mark - Action
- (void)moveSlider:(UIPanGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateChanged) {
//        NSLog(@"self.thumbImageView.frame.origin.y==%f",self.thumbImageView.frame.origin.y);
        if (self.thumbImageView.frame.origin.y + self.thumbImageView.frame.size.height <= self.frame.size.height &&
            self.thumbImageView.frame.origin.y >= 0
            ) {
            CGPoint translation = [recognizer translationInView:self];
            translation = CGPointApplyAffineTransform(translation, self.thumbImageView.transform);
            CGFloat moveY;
            moveY = self.thumbImageView.center.y + translation.y;
//            NSLog(@"MOVEY=%f",moveY);
            if (self.thumbImageView.center.y + translation.y > self.frame.size.height - self.thumbImageView.frame.size.height/2 ) {
                moveY = self.frame.size.height - self.thumbImageView.frame.size.height/2;
                
            }else if (self.thumbImageView.center.y + translation.y < self.thumbImageView.frame.size.height/2){
                moveY = self.thumbImageView.frame.size.height/2;
            }else if (self.thumbImageView.frame.origin.y < 0){
                moveY = self.thumbImageView.frame.size.height/2;
            }
            self.thumbImageView.center = CGPointMake(self.thumbImageView.center.x, moveY);
            [recognizer setTranslation:CGPointZero inView:self]; // 移动的时候，注意在最后重设当前的 translation。
            
            CGFloat value =  (self.frame.size.height - self.thumbImageView.center.y - self.thumbImageView.frame.size.height/2)/(self.frame.size.height-self.thumbImageView.frame.size.height) * (self.maximumValue-self.minimumValue) + self.minimumValue;

            [self fillWithValue:value];
            
            if (self.touchSliderValueChange) {
                self.touchSliderValueChange(value);
            }
        }
    }
}


#pragma  mark - GET SET

- (void)setValue:(float)value{
    if (value<self.minimumValue) {
        value = self.minimumValue;
    }
    _value = value;
    [self setValue:value animated:YES];
}


- (void)setMinimumValue:(float)minimumValue{
    _minimumValue = minimumValue;
    if (_value == 0) {
        _value = minimumValue;
    }
}
- (void)setMinImage:(UIImage *)minImage{
    _minImage = minImage;
    self.minImageView.image = minImage;
}

- (void)setMaxImage:(UIImage *)maxImage{
    _maxImage = maxImage;
    self.maxImageView.image = maxImage;
}

- (void)setThumbImage:(UIImage *)thumbImage{
    _thumbImage = thumbImage;
    self.thumbImageView.image = thumbImage;
}

- (UIImageView *)minImageView{
    if (!_minImageView) {
        _minImageView = [[UIImageView alloc]init];
        _minImageView.image = [UIImage imageNamed:@"control_grey"];
    }
    return _minImageView;
}
- (UIImageView *)maxImageView{
    if (!_maxImageView) {
        _maxImageView = [[UIImageView alloc]init];
        _maxImageView.image = [UIImage imageNamed:@"control_yellow"];
    }
    return _maxImageView;
}
- (UIImageView *)thumbImageView{
    if (!_thumbImageView) {
        _thumbImageView = [[UIImageView alloc]init];
        _thumbImageView.userInteractionEnabled = YES;
        _thumbImageView.image = [UIImage imageNamed:@"control_botton"];
    }
    return _thumbImageView;
}

- (CAShapeLayer *)maskLayer{
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
    }
    return _maskLayer;
}
@end
