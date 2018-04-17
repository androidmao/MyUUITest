//
//  HYZoomScrollView.h
//  MyUITest
//
//  Created by BlackCoffee on 2018/4/17.
//  Copyright © 2018年 BaiMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "UIView+LBFrame.h"

#define MinZoomScale 1.0
#define MaxZoomScale 3.0


@interface HYZoomScrollView : UIScrollView

@property (nonatomic,strong) UIImageView *imageView;

@end
