//
//  ViewController.m
//  MKSlider
//
//  Created by Make on 2019/1/11.
//  Copyright © 2019 Make. All rights reserved.
//

#import "ViewController.h"
#import "GQYVerticalSlider.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 20, 375, 200)];
//    view.backgroundColor = [UIColor redColor];
//    [self.view addSubview:view];
    
    GQYVerticalSlider *slider = [[GQYVerticalSlider alloc]initWithFrame:CGRectMake(100, 200, 20, 200)];
    [self.view addSubview:slider];
    
    slider.maximumValue = 100;
    slider.minimumValue = 30;

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [slider setValue:34 animated:YES];
        
    });
}


@end
