//
//  HYGestureScrollView.m
//  MyUITest
//
//  Created by BlackCoffee on 2018/4/19.
//  Copyright © 2018年 BaiMao. All rights reserved.
//

#import "HYGestureScrollView.h"

#import "GeneralUtil.h"

#import "NewsCommentTableViewCell.h"

@interface HYGestureScrollView ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>


@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIButton *closeButton;

@property (nonatomic,strong) UIImageView *avatarImageView;

@property (nonatomic,strong) UILabel *usernameLabel;

@property (nonatomic,strong) UILabel *commentLabel;

@property (nonatomic,strong) UILabel *createTimeLabel;

@property (nonatomic,strong) UIView *tableHeaderContainerView;

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation HYGestureScrollView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDelegate:self];
        [self setBackgroundColor:[UIColor clearColor]];
//        [self setAlwaysBounceVertical:YES];
//        [self setAlwaysBounceHorizontal:YES];
        
//        [self setUserInteractionEnabled:NO];
        [self setShowsVerticalScrollIndicator:NO];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setDecelerationRate:UIScrollViewDecelerationRateFast];
//        [self setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [self addSubview:self.moveView];
        
        
        
        [self.moveView addSubview:self.titleLabel];
        [self.moveView addSubview:self.tableView];
        //        [self.view addSubview:self.commentView];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.moveView);
            make.right.mas_equalTo(self.moveView);
            make.top.mas_equalTo(self.moveView);
            make.height.mas_equalTo(50);
        }];
        
        [self.titleLabel layoutIfNeeded];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.titleLabel.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = self.titleLabel.bounds;
        maskLayer.path = maskPath.CGPath;
        self.titleLabel.layer.mask = maskLayer;
        
        
        CALayer *bottomBorder = [CALayer layer];
        
        bottomBorder.frame = CGRectMake(0.0f, self.titleLabel.frame.size.height - 0.5, self.titleLabel.frame.size.width, 0.5);
        
        bottomBorder.backgroundColor = [GeneralUtil colorWithHexString:@"#ECF0F2"].CGColor;

        [self.titleLabel.layer addSublayer:bottomBorder];
        
        
        
        [self.titleLabel addSubview:self.closeButton];
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel);
            make.top.mas_equalTo(self.titleLabel);
            make.bottom.mas_equalTo(self.titleLabel);
            make.width.mas_equalTo(44);
        }];
        
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.moveView);
            make.right.mas_equalTo(self.moveView);
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
            make.bottom.mas_equalTo(self.moveView);
        }];
        
       
        
        [self.tableHeaderContainerView addSubview:self.avatarImageView];
        [self.tableHeaderContainerView addSubview:self.usernameLabel];
        [self.tableHeaderContainerView addSubview:self.commentLabel];
        [self.tableHeaderContainerView addSubview:self.createTimeLabel];
        

        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.tableHeaderContainerView).mas_offset(15);
            make.top.mas_equalTo(self.tableHeaderContainerView).mas_offset(15);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];

        [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(15);
            make.top.mas_equalTo(self.tableHeaderContainerView).mas_offset(15);
            make.size.mas_equalTo(CGSizeMake(120, 20));
        }];
        
        

        [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(15);
            make.right.mas_equalTo(self.tableHeaderContainerView).mas_offset(-15);
            make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_offset(15);
            make.bottom.mas_equalTo(self.createTimeLabel.mas_top).mas_offset(-15);
        }];
        
        [self.createTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(15);
            make.right.mas_equalTo(self.tableHeaderContainerView).mas_offset(-15);
            make.bottom.mas_equalTo(self.tableHeaderContainerView).mas_offset(-10);
            make.height.mas_equalTo(20);
        }];


        [self.tableHeaderContainerView setFrame:CGRectMake(0, 0, SCREEN_W, 150)];
        CALayer *bottomBorder1 = [CALayer layer];
        
        bottomBorder1.frame = CGRectMake(0.0f, self.tableHeaderContainerView.frame.size.height - 0.5, self.tableHeaderContainerView.frame.size.width, 0.5);
        
        bottomBorder1.backgroundColor = [GeneralUtil colorWithHexString:@"#ECF0F2"].CGColor;
        
        [self.tableHeaderContainerView.layer addSublayer:bottomBorder1];

        [self.tableView layoutIfNeeded];
        
        [self.tableView setTableHeaderView:self.tableHeaderContainerView];
        
    }
    return self;
}

- (UIView *)moveView {
    if (!_moveView) {
        _moveView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 20)];
        [_moveView setBackgroundColor:[UIColor clearColor]];
    }
    return _moveView;
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

    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        [_titleLabel setBackgroundColor:[UIColor whiteColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setUserInteractionEnabled:YES];
    }
    return _titleLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc]init];
        [_closeButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (void)closeAction:(UIButton *)button {
    
}


- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc]init];
        [_avatarImageView setImage:[UIImage imageNamed:@"icon_login_avatar_normal"]];
    }
    return _avatarImageView;
}

- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [[UILabel alloc]init];
        [_usernameLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
        [_usernameLabel setTextColor:[GeneralUtil colorWithHexString:@"#0194dd"]];
    }
    return _usernameLabel;
}

- (UILabel *)commentLabel {
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc]init];
        [_commentLabel setNumberOfLines:0];
        [_commentLabel setFont:[UIFont systemFontOfSize:15.0]];
    }
    return _commentLabel;
}

- (UILabel *)createTimeLabel {
    if (!_createTimeLabel) {
        _createTimeLabel = [[UILabel alloc]init];
        [_createTimeLabel setFont:[UIFont systemFontOfSize:12.0]];
    }
    return _createTimeLabel;
}

- (UIView *)tableHeaderContainerView {
    if(!_tableHeaderContainerView) {
        _tableHeaderContainerView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tableHeaderContainerView;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        //        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //            [self loadMoreData];
        //        }];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"table_cell";
    NewsCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[NewsCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


@end
