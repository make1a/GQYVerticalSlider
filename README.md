# GQYVerticalSlider
可以自定义背景图片和滑块的Slider，纵向（竖向）滑动
API 跟系统UISlider 类似
```

@property (nonatomic,strong)UIImage * minImage;
@property (nonatomic,strong)UIImage * maxImage;
@property (nonatomic,strong)UIImage * thumbImage;


@property(nonatomic) float value;                                 // default 0.0. this value will be pinned to min/max
@property(nonatomic) float minimumValue;                          // default 0.0. the current value may change if outside new min value
@property(nonatomic) float maximumValue;                          // default 1.0. the current value may change if outside new max value


@property (nonatomic,copy)void (^touchSliderValueChange)(CGFloat value);


- (void)setValue:(float)value animated:(BOOL)animated;
```

使用：

```
    GQYVerticalSlider *slider = [[GQYVerticalSlider alloc]initWithFrame:CGRectMake(100, 200, 20, 200)];
    [self.view addSubview:slider];
    
    slider.maximumValue = 100;
    slider.minimumValue = 30;

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [slider setValue:34 animated:YES];
        
    });
```

效果：
![demo](https://github.com/make1a/GQYVerticalSlider/blob/master/demo.png)
