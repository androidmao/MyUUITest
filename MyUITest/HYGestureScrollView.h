//
//  HYGestureScrollView.h
//  MyUITest
//
//  Created by BlackCoffee on 2018/4/19.
//  Copyright © 2018年 BaiMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYGestureScrollView : UIScrollView

@property (nonatomic,strong) UIView *moveView;

@property (nonatomic,assign) BOOL viewIsMoving;

@end
