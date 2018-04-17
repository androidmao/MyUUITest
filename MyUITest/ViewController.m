//
//  ViewController.m
//  MyUITest
//
//  Created by BlackCoffee on 2018/4/3.
//  Copyright © 2018年 BaiMao. All rights reserved.
//

#import "ViewController.h"
#import "HYPictureCollectionViewCell.h"


#define SendCountEveryTime 30
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define ItemSpace 20

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic,strong) UISlider *slider;

@property (nonatomic,strong) NSMutableArray *cells;

@property (nonatomic,strong) UIButton *button;

@property (nonatomic,weak) CAEmitterLayer *layer;


@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,assign)CGPoint startPoint;

@property (nonatomic,assign)CGFloat zoomScale;

@property (nonatomic,assign)CGPoint startCenter;

@end

@implementation ViewController

- (UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        //只能设置中心，不能设置大小
        _activityIndicator.center = CGPointMake(50.0f, 50.0f);
        // 改变圈圈的颜色为红色； iOS5引入
        _activityIndicator.color = [UIColor lightGrayColor];
        [_activityIndicator setHidesWhenStopped:YES];
    }
    return _activityIndicator;
}

- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc]initWithFrame:CGRectMake(20, 100, 335, 50)];
//        //07.minimumTrackTintColor : 小于滑块当前值滑块条的颜色，默认为蓝色
//        _slider.minimumTrackTintColor = [UIColor redColor];
//
//        //08.maximumTrackTintColor: 大于滑块当前值滑块条的颜色，默认为白色
//        _slider.maximumTrackTintColor = [UIColor blueColor];
//
//        //09.thumbTintColor : 当前滑块的颜色，默认为白色
//        _slider.thumbTintColor = [UIColor grayColor];
    }
    return _slider;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIScrollView *scrollView = [[UIScrollView alloc]init];
//    [scrollView setBackgroundColor:[UIColor clearColor]];
//    [self.view addSubview:scrollView];
//
//    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
//    }];
//
//
//    UIView *contentView = [[UIView alloc]init];
//    [contentView setBackgroundColor:[UIColor lightGrayColor]];
//    [scrollView addSubview:contentView];
//
//    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(scrollView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
//        make.width.equalTo(@355);
//        make.height.equalTo(@800);
//    }];
//
//    [self.view layoutIfNeeded];
//
//    NSLog(@"%@",scrollView);
    
    
//    [self.view addSubview:self.activityIndicator];
//
//    [self.activityIndicator startAnimating];
//
//
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 2.0秒后异步追加任务代码到主队列，并开始执行
//        // 打印当前线程
//        NSLog(@"after---%@",[NSThread currentThread]);
//
//        [self.activityIndicator stopAnimating];
//
//        NSLog(@"after---%@",self.view.subviews);
//
//    });
    
//    [self.view addSubview:self.slider];
    
    
//    self.button.center = self.view.center;
//
//    [self.view addSubview:self.button];
    
    
//    dispatch_semaphore_t t = dispatch_semaphore_create(1);
//
//    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
//    [queue setMaxConcurrentOperationCount:1];
//
//    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//
//    dispatch_async(globalQueue, ^{
//
//        sleep(1);
//        NSLog(@"waiting -- 111111");
//        long i1 = dispatch_semaphore_signal(t);
//        NSLog(@"信号量1：%ld",i1);
//        NSLog(@"111111");
//
//        sleep(2);
//        NSLog(@"waiting -- 222222");
//        long i2 = dispatch_semaphore_signal(t);
//        NSLog(@"信号量2：%ld",i2);
//        NSLog(@"222222");
//
//    });
//
//    long i3 = dispatch_semaphore_wait(t, DISPATCH_TIME_FOREVER);
//    NSLog(@"信号量3：%ld",i3);
//    NSLog(@"333333");
//    long i4 = dispatch_semaphore_wait(t, DISPATCH_TIME_FOREVER);
//    NSLog(@"信号量4：%ld",i4);
//    NSLog(@"444444");
    
    
    [self.view addSubview:self.collectionView];
    
    [self.view setBackgroundColor:[UIColor blackColor]];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [self.view addGestureRecognizer:pan];
    
}

- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        [_button setBackgroundColor:[UIColor lightGrayColor]];
        [_button addTarget:self action:@selector(startAnima:) forControlEvents:UIControlEventTouchUpInside];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
        longPress.minimumPressDuration = 0.8; //定义按的时间
        [_button addGestureRecognizer:longPress];
    }
    return _button;
}

- (void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CAEmitterLayer *layer               = [CAEmitterLayer layer];
        layer.name          = @"emitterLayer";
        layer.position  = CGPointMake(gestureRecognizer.view.frame.size.width/2.0, gestureRecognizer.view.frame.size.height/2.0);
        
        NSMutableArray *images = [[NSMutableArray alloc]init];
        for (int i = 0; i < SendCountEveryTime; i++) {
            int x = arc4random() % 100 + 1;
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%03d",x]];
            [images addObject:image];
        }
        
        for (int i = 0; i<images.count; i++) {
            CAEmitterCell *cell = self.cells[i];
            cell.contents = (__bridge id _Nullable)(([images[i] CGImage]));
        }
        
        for (int i = 0; i < SendCountEveryTime; i++) {
            CAEmitterCell *cell = [CAEmitterCell emitterCell];
            cell.name           = [NSString stringWithFormat:@"explosion_%d",i];
            cell.alphaRange     = 0.5;
            cell.alphaSpeed     = -0.5;
            cell.lifetime       = 4;
            cell.lifetimeRange  = 2;
            cell.velocity       = 600;
            cell.velocityRange  = 200.00;
            cell.scale          = 0.5;
            cell.yAcceleration  = 600;
            cell.emissionLongitude = 2 * M_PI - M_PI_4;
            cell.emissionRange = M_PI;
            [self.cells addObject:cell];
        }
        
        layer.emitterCells = self.cells;
        [gestureRecognizer.view.layer addSublayer:layer];
        layer.beginTime = CACurrentMediaTime();
        for (int i = 0; i < SendCountEveryTime; i++) {
            [layer setValue:@(SendCountEveryTime) forKeyPath:[NSString stringWithFormat:@"emitterCells.explosion_%d.birthRate",i]];
        }
        _layer = layer;
        
    }else if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled){
        [self stopAnimationWithObj:_layer];
    }
    
    
}


- (NSMutableArray *)cells {
    if (!_cells) {
        _cells = [[NSMutableArray alloc]init];
    }
    return _cells;
}


- (void)startAnima:(UIButton *)button {
    
    
    NSMutableArray *images = [[NSMutableArray alloc]init];
    for (int i = 0; i < SendCountEveryTime; i++) {
        int x = arc4random() % 100 + 1;
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%03d",x]];
        [images addObject:image];
    }
    
    for (int i = 0; i < SendCountEveryTime; i++) {
        CAEmitterCell *cell = [CAEmitterCell emitterCell];
        cell.name           = [NSString stringWithFormat:@"explosion_%d",i];
        cell.alphaRange     = 0.5;
        cell.alphaSpeed     = -0.5;
        cell.lifetime       = 4;
        cell.lifetimeRange  = 2;
        cell.velocity       = 600;
        cell.velocityRange  = 200.00;
        cell.scale          = 0.5;
        cell.yAcceleration  = 600;
        cell.emissionLongitude = 2 * M_PI - M_PI_4;
        cell.emissionRange = M_PI;
        [self.cells addObject:cell];
    }
    
    for (int i = 0; i< images.count; i++) {
        CAEmitterCell *cell = self.cells[i];
        cell.contents =  (__bridge id _Nullable)(([images[i] CGImage]));
    }
    CAEmitterLayer *layer = [CAEmitterLayer layer];
    layer.name = @"emitterLayer";
    layer.position = CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0);
    layer.emitterCells = self.cells;
    [self.view.layer addSublayer:layer];
    
    
    layer.beginTime = CACurrentMediaTime();
    for (int i = 0; i < SendCountEveryTime; i++) {
        [layer setValue:@(SendCountEveryTime) forKeyPath:[NSString stringWithFormat:@"emitterCells.explosion_%d.birthRate",i]];
    }
    _button.userInteractionEnabled = NO;
    [self performSelector:@selector(stopAnimationWithObj:) withObject:layer afterDelay:0.1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _button.userInteractionEnabled = YES;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [layer removeFromSuperlayer];
    });
    
}


- (void)stopAnimationWithObj:(id)obj {
    for (int i = 0; i < SendCountEveryTime; i++) {
        [obj setValue:@0 forKeyPath:[NSString stringWithFormat:@"emitterCells.explosion_%d.birthRate",i]];
    }
}



- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [layout setMinimumInteritemSpacing:0];
        [layout setMinimumLineSpacing:0];
        
        // there page sapce is equal to 20
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(-ItemSpace / 2.0, 0, SCREEN_WIDTH + ItemSpace, SCREEN_HEIGHT) collectionViewLayout:layout];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView setPagingEnabled:YES];
        [_collectionView setAlwaysBounceVertical:NO];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setShowsVerticalScrollIndicator:NO];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        
        
        NSString *identifier = NSStringFromClass([HYPictureCollectionViewCell class]);
        [_collectionView registerClass:[HYPictureCollectionViewCell class] forCellWithReuseIdentifier:identifier];
        
    }
    return _collectionView;
}


#pragma mark - collectionView的数据源&代理

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = NSStringFromClass([HYPictureCollectionViewCell class]);
    HYPictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    return cell;
}
#pragma mark - 代理方法

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH + ItemSpace, SCREEN_HEIGHT);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)didPan:(UIPanGestureRecognizer *)pan {
    CGPoint location = [pan locationInView:self.view];
    CGPoint point = [pan translationInView:self.view];
    HYPictureCollectionViewCell *cell = (HYPictureCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            _startPoint = location;
            _zoomScale = cell.zoomScrollView.zoomScale;
            _startCenter = cell.zoomScrollView.imageView.center;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (location.y - _startPoint.y < 0) {
                return;
            }
            double percent = 1 - fabs(point.y) / self.view.frame.size.height;// 移动距离 / 整个屏幕
            double scalePercent = MAX(percent, 0.3);
            if (location.y - _startPoint.y < 0) {
                scalePercent = 1.0 * _zoomScale;
            }else {
                scalePercent = _zoomScale * scalePercent;
            }
            CGAffineTransform scale = CGAffineTransformMakeScale(scalePercent, scalePercent);
            cell.zoomScrollView.imageView.transform = scale;
            cell.zoomScrollView.imageView.center = CGPointMake(self.startCenter.x + point.x, self.startCenter.y + point.y);
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {

            cell.zoomScrollView.imageView.center = self.startCenter;

            cell.zoomScrollView.imageView.transform = CGAffineTransformIdentity;

        }
            break;

        default:
            break;
    }
}


@end
