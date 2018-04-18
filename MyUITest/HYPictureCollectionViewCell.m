//
//  HYPictureCollectionViewCell.m
//  MyUITest
//
//  Created by BlackCoffee on 2018/4/17.
//  Copyright © 2018年 BaiMao. All rights reserved.
//

#import "HYPictureCollectionViewCell.h"

@interface HYPictureCollectionViewCell ()<UIScrollViewDelegate>



@end

@implementation HYPictureCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.zoomScrollView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
        [doubleTap setNumberOfTapsRequired:2];
        [self addGestureRecognizer:doubleTap];
        
         // 关键在这一行，如果双击确定偵測失败才會触发单击
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
    }
    return self;
}


- (void)singleTapAction:(UITapGestureRecognizer *)gesture {
    NSLog(@"singleTapAction");
    
    CGPoint point = [gesture locationInView:(UIView *)self.zoomScrollView.imageView];
    [self.zoomScrollView handleSingleTap:point];
    
}

- (void)doubleTapAction:(UITapGestureRecognizer *)gesture {
    NSLog(@"doubleTapAction");
    
    CGPoint point = [gesture locationInView:(UIView *)self.zoomScrollView.imageView];
    if (!CGRectContainsPoint(self.zoomScrollView.imageView.bounds, point)) {
        return;
    }
    
    [self.zoomScrollView handleDoubleTap:point];

}

- (HYZoomScrollView *)zoomScrollView {
    if (!_zoomScrollView) {
        _zoomScrollView = [[HYZoomScrollView alloc]init];
    }
    return _zoomScrollView;
}





@end
