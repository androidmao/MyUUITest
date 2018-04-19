//
//  HYGestureScrollView.m
//  MyUITest
//
//  Created by BlackCoffee on 2018/4/19.
//  Copyright © 2018年 BaiMao. All rights reserved.
//

#import "HYGestureScrollView.h"


@interface HYGestureScrollView ()<UIScrollViewDelegate>

@end

@implementation HYGestureScrollView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDelegate:self];
        [self setBackgroundColor:[UIColor clearColor]];
//        [self setAlwaysBounceVertical:YES];
//        [self setAlwaysBounceHorizontal:YES];
        [self setShowsVerticalScrollIndicator:NO];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setDecelerationRate:UIScrollViewDecelerationRateFast];
        [self setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [self addSubview:self.moveView];
    }
    return self;
}

- (UIView *)moveView {
    if (!_moveView) {
        _moveView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 20)];
        [_moveView setBackgroundColor:[UIColor whiteColor]];
    }
    return _moveView;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.moveView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{
    if (scrollView.minimumZoomScale != scale) return;
    [self setZoomScale:self.minimumZoomScale animated:YES];
    //    [self resetScrollViewStatusWithImage:self.model.currentPageImage]
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    // 图片在移动的时候停止居中布局
    if (self.viewIsMoving == YES) {
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.moveView.center = CGPointMake(self.center.x, self.center.y + 10);
    }];
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidScroll");
    
    NSLog(@"(%f,%f)",scrollView.contentOffset.x,scrollView.contentOffset.y);
   
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
