//
//  MKVerticalSlider.h
//  MKSlider
//
//  Created by Make on 2019/1/11.
//  Copyright © 2019 Make. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GQYVerticalSlider : UIView


@property (nonatomic,strong)UIImage * minImage;
@property (nonatomic,strong)UIImage * maxImage;
@property (nonatomic,strong)UIImage * thumbImage;


@property(nonatomic) float value;                                 // default 0.0. this value will be pinned to min/max
@property(nonatomic) float minimumValue;                          // default 0.0. the current value may change if outside new min value
@property(nonatomic) float maximumValue;                          // default 1.0. the current value may change if outside new max value


@property (nonatomic,copy)void (^touchSliderValueChange)(CGFloat value);


- (void)setValue:(float)value animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
