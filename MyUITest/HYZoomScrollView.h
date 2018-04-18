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

@property (nonatomic,assign)BOOL imageViewIsMoving;

/**
 处理单击手势

 @param touchPoint touchPoint
 */
- (void)handleSingleTap:(CGPoint)touchPoint;


/**
 处理双击手势

 @param touchPoint touchPoint
 */
- (void)handleDoubleTap:(CGPoint)touchPoint;



@end
