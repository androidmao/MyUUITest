//
//  HYZoomScrollView.m
//  MyUITest
//
//  Created by BlackCoffee on 2018/4/17.
//  Copyright © 2018年 BaiMao. All rights reserved.
//

#import "HYZoomScrollView.h"
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


@interface HYZoomScrollView ()<UIScrollViewDelegate>




@end

@implementation HYZoomScrollView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDelegate:self];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setAlwaysBounceVertical:YES];
        [self setShowsVerticalScrollIndicator:NO];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setDecelerationRate:UIScrollViewDecelerationRateFast];
        [self setFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [self setMinimumZoomScale:MinZoomScale];
        [self addSubview:self.imageView];
        
        [[SDWebImageManager sharedManager]loadImageWithURL:[NSURL URLWithString:@"http://p7.pstatp.com/large/w960/5321000135125ebb938a"] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            NSLog(@"图片宽度：%f",image.size.width);
            NSLog(@"图片高度：%f",image.size.height);
            
            self.imageView.frame = CGRectMake(0, 0, self.width, 0);
            if (image.size.height / image.size.width > self.height / self.width) {
                self.imageView.height = floor(image.size.height / (image.size.width / self.width));
            }else {
                CGFloat height = image.size.height / image.size.width * self.width;;
                self.imageView.height = floor(height);
                self.imageView.centerY = self.height / 2;
            }
            if (self.imageView.height > self.height && self.imageView.height - self.height <= 1) {
                self.imageView.height = self.height;
            }
            self.contentSize = CGSizeMake(self.width, MAX(self.imageView.height, self.height));
            [self setContentOffset:CGPointZero];
            
            if (self.imageView.height > self.height) {
                self.alwaysBounceVertical = YES;
            } else {
                self.alwaysBounceVertical = NO;
            }
            
            if (self.imageView.contentMode != UIViewContentModeScaleToFill) {
                self.imageView.contentMode =  UIViewContentModeScaleToFill;
                self.imageView.clipsToBounds = NO;
            }
            
            self.maximumZoomScale = MaxZoomScale;
            [self.imageView setImage:image];
            
        }];
        
    }
    return self;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
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


- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        [_imageView setUserInteractionEnabled:YES];
        [_imageView setClipsToBounds:YES];
        [_imageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)]];
    }
    return _imageView;
}

- (void)longPressAction:(UILongPressGestureRecognizer *)gesture {
    
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"longPressAction");
    }
    
    
}


- (void)handleSingleTap:(CGPoint)touchPoint {
    NSLog(@"handleSingleTap");
}


- (void)handleDoubleTap:(CGPoint)touchPoint {
    NSLog(@"handleDoubleTap");
    
    if (self.maximumZoomScale == self.minimumZoomScale) {
        return;
    }
    if (self.zoomScale != self.minimumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        CGFloat newZoomScale = self.maximumZoomScale;
        CGFloat xsize = self.bounds.size.width / newZoomScale;
        CGFloat ysize = self.bounds.size.height / newZoomScale;
        [self zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
    
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    // 图片在移动的时候停止居中布局
    if (self.imageViewIsMoving == YES) {
        return;
    }
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.imageView.frame;
    // Horizontally floor：如果参数是小数，则求最大的整数但不大于本身.
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    // Center
    if (!CGRectEqualToRect(self.imageView.frame, frameToCenter)){
        self.imageView.frame = frameToCenter;
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
