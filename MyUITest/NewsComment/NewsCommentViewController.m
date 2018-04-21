//
//  NewsCommentViewController.m
//  AnXinClient
//
//  Created by GOKIT on 2018/3/5.
//  Copyright © 2018年 AnXin. All rights reserved.
//

#import "NewsCommentViewController.h"
#import "GeneralUtil.h"
#import "Masonry.h"
#import <MJRefresh/MJRefresh.h>
#import "NewsCommentTableViewCell.h"
//#import "NewsContentCommentPresenter.h"
//#import "CommentView.h"
#import "NSDate+YYAdd.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

#define SafeAreaTopHeight (SCREEN_H == 812.0 ? 88 : 64)

#define SafeAreaBottomHeight (SCREEN_H == 812.0 ? 34 : 0)

//每页加载多少条数据
#define PAGE_SIZE 10

typedef NS_ENUM(NSInteger , TableViewOperationType) {
    ///刷新
    TableViewOperationType_Refresh,
    ///加载更多
    TableViewOperationType_LoadMore
};

@interface NewsCommentViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NewsContentComment *newsContentComment;

//@property (nonatomic,strong) NewsContentCommentPresenter *newsContentCommentPresenter;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIButton *closeButton;

@property (nonatomic,strong) UIImageView *avatarImageView;

@property (nonatomic,strong) UILabel *usernameLabel;

@property (nonatomic,strong) UILabel *commentLabel;

@property (nonatomic,strong) UILabel *createTimeLabel;

@property (nonatomic,strong) UIView *tableHeaderContainerView;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) NSInteger page_index;

@property (nonatomic,assign) TableViewOperationType type;

@property (nonatomic,strong) NSMutableArray<NewsContentComment *> *newsContentComments;

//@property (nonatomic,strong) CommentView *commentView;

@end

@implementation NewsCommentViewController

- (instancetype)initWithNewsContentComment:(NewsContentComment *)newsContentComment {
    self = [super init];
    if (self) {

        _newsContentComment = newsContentComment;

        [self.view addSubview:self.titleLabel];
        [self.view addSubview:self.tableView];
//        [self.view addSubview:self.commentView];

        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view);
            make.right.mas_equalTo(self.view);
            make.top.mas_equalTo(self.view).mas_offset(SafeAreaTopHeight - 44);
            make.height.mas_equalTo(44);
        }];

        [self.view layoutIfNeeded];

        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.titleLabel.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = self.titleLabel.bounds;
        maskLayer.path = maskPath.CGPath;
        self.titleLabel.layer.mask = maskLayer;

        UIView *lineView = [[UIView alloc]init];
        [lineView setBackgroundColor:[GeneralUtil colorWithHexString:@"#ECF0F2"]];
        [self.titleLabel addSubview:lineView];

        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel);
            make.right.mas_equalTo(_titleLabel);
            make.bottom.mas_equalTo(_titleLabel);
            make.height.mas_equalTo(0.5);
        }];

        [self.titleLabel addSubview:self.closeButton];
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel);
            make.top.mas_equalTo(self.titleLabel);
            make.bottom.mas_equalTo(self.titleLabel);
            make.width.mas_equalTo(44);
        }];


        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view);
            make.right.mas_equalTo(self.view);
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
            make.bottom.mas_equalTo(self.view).mas_offset(-(SafeAreaBottomHeight + 44));
        }];

//        [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.view);
//            make.right.equalTo(self.view);
//            self.commentView.heightConstraint = make.height.mas_equalTo(44);
//            self.commentView.bottomConstraint = make.bottom.equalTo(self.view);
//        }];

        if (_newsContentComment) {
            
            if (_newsContentComment.comment_count > 0) {
                [self.titleLabel setText:[NSString stringWithFormat:@"%ld条回复",(long)_newsContentComment.comment_count]];
            } else {
                [self.titleLabel setText:@"暂无回复"];
            }


            [self.usernameLabel setText:newsContentComment.user_name];
            [self.commentLabel setText:newsContentComment.comment];
            NSDate *timedate = [NSDate dateWithString:newsContentComment.create_time format:@"yyyy-MM-dd HH:mm:ss"];
            NSString *timeStr = [NSDate detailTimeAgoString:timedate];
            [self.createTimeLabel setText:timeStr];

        }

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

        UIView *lineView1 = [[UIView alloc]init];
        [lineView1 setBackgroundColor:[GeneralUtil colorWithHexString:@"#ECF0F2"]];
        [self.tableHeaderContainerView addSubview:lineView1];

        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.tableHeaderContainerView);
            make.right.mas_equalTo(self.tableHeaderContainerView);
            make.bottom.mas_equalTo(self.tableHeaderContainerView);
            make.height.mas_equalTo(0.5);
        }];

        float height = [GeneralUtil heightForText:newsContentComment.comment andWidth:SCREEN_W - 80 withFont:15];

        [self.tableHeaderContainerView setFrame:CGRectMake(0, 0, SCREEN_W, height + 95)];

        [self.tableView setTableHeaderView:self.tableHeaderContainerView];


    }
    return self;
}

//- (NewsContentCommentPresenter *)newsContentCommentPresenter {
//    if (!_newsContentCommentPresenter) {
//        _newsContentCommentPresenter = [[NewsContentCommentPresenter alloc]init];
//        [_newsContentCommentPresenter setDelegate:self];
//    }
//    return _newsContentCommentPresenter;
//}
//
//- (void)onReturnEntity:(id)entity what:(NSInteger)what {
//
//    switch (what) {
//        case WHAT_NEWSCONTENTCOMMENT_ADD:{
//
//            NSDictionary *parameters = @{@"news_content_id":@(_newsContentComment.news_content_id),@"news_content_comment_id":@(_newsContentComment.news_content_comment_id),@"index":@(_page_index),@"size":@(PAGE_SIZE)};
//            [self.newsContentCommentPresenter requestNewsContentCommentGetChildrenList:parameters];
//
//        }
//            break;
//
//        case WHAT_NEWSCONTENTCOMMENT_GETCHILDRENLIST:{
//
//            NewsContentCommentList *newsContentCommentList = entity;
//
//            switch (_type) {
//                case TableViewOperationType_Refresh:{
//
//                    [_newsContentComments removeAllObjects];
//
//                    if (newsContentCommentList) {
//
//                        _newsContentComments = newsContentCommentList.items;
//
//                        if (_newsContentComments) {
//
//                            if (_newsContentComments.count >= PAGE_SIZE) {
//
//                                [self.tableView.mj_footer resetNoMoreData];
//
//                            } else {
//
//                                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//
//                            }
//
//                        }
//
//                    }
//
//                    [self.tableView.mj_header endRefreshing];
//                    [self.tableView reloadData];
//
//                }
//                    break;
//
//                case TableViewOperationType_LoadMore:{
//
//                    if (newsContentCommentList) {
//
//                        [_newsContentComments addObjectsFromArray:newsContentCommentList.items];
//
//                        if (!newsContentCommentList.items || newsContentCommentList.items.count < PAGE_SIZE) {
//
//                            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//
//                        } else {
//
//                            [self.tableView.mj_footer endRefreshing];
//
//                        }
//
//                        [self.tableView reloadData];
//
//                    } else {
//
//                        [self.tableView.mj_footer endRefreshing];
//
//                    }
//
//                }
//                    break;
//            }
//
//        }
//            break;
//    }
//
//}
//
//
//- (void)onFailed:(NSInteger)what {
//
//    switch (what) {
//        case WHAT_NEWSCONTENTCOMMENT_GETCHILDRENLIST:{
//
//            switch (_type) {
//                case TableViewOperationType_Refresh:{
//                    [_newsContentComments removeAllObjects];
//                    [self.tableView.mj_header endRefreshing];
//                    [self.tableView reloadData];
//                }
//                    break;
//
//                case TableViewOperationType_LoadMore:{
//                    [self.tableView.mj_footer endRefreshing];
//                }
//                    break;
//            }
//
//        }
//            break;
//    }
//
//}

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
        [_closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_closeButton setTitle:@"X" forState:UIControlStateNormal];
        [_closeButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (void)closeAction:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
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

//- (void)loadMoreData {
//
//    _type = TableViewOperationType_LoadMore;
//    _page_index += 1;
//
//    NSDictionary *parameters = @{@"news_content_id":@(_newsContentComment.news_content_id),@"news_content_comment_id":@(_newsContentComment.news_content_comment_id),@"index":@(_page_index),@"size":@(PAGE_SIZE)};
//
//    [self.newsContentCommentPresenter requestNewsContentCommentGetChildrenList:parameters];
//
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _newsContentComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"table_cell";
    NewsCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[NewsCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    [cell setNewsContentComment:[_newsContentComments objectAtIndex:indexPath.row]];

    //    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(likeCommentClick:)];


    return cell;
}

- (void)likeCommentClick:(UITapGestureRecognizer *)tapGesture {

    NSLog(@"tapGesture:%@",tapGesture.view);

    if ([tapGesture.view isKindOfClass:[UIImageView class]]) {
        UIImageView *likeImageView = (UIImageView *)tapGesture.view;
        [likeImageView setImage:[UIImage imageNamed:@"icon_comment_like_highlighted"]];

        [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations: ^{
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations: ^{
                likeImageView.transform = CGAffineTransformMakeScale(1.3f, 1.3f); // 放大
            }];
            [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
                likeImageView.transform = CGAffineTransformMakeScale(0.8f, 0.8f); // 放小
            }];
            [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations: ^{
                likeImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f); //恢复原样
            }];
        } completion:nil];


        //            self.zangPlusImg.alpha=1;
        //            self.zangPlusImg.frame=CGRectMake(66, 0, 15, 15);
        //            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        //            animation.duration = 1.5;
        //            animation.rotationMode = kCAAnimationRotateAuto;
        //            animation.removedOnCompletion = NO;
        //            animation.fillMode = kCAFillModeForwards;
        //            NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(66, 8)];
        //            NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(66, -6)];
        //            animation.delegate = self;
        //            animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        //            animation.values=@[value1,value2];
        //            [self.zangPlusImg.layer addAnimation:animation forKey:nil];






    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NewsContentComment *newsContentComment = [_newsContentComments objectAtIndex:indexPath.row];

    float height = [GeneralUtil heightForText:newsContentComment.comment andWidth:SCREEN_W - 80 withFont:15];

    return height + 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NewsContentComment *newsContentComment = [_newsContentComments objectAtIndex:indexPath.row];

    [self presentViewController:[[NewsCommentViewController alloc]initWithNewsContentComment:newsContentComment] animated:YES completion:nil];

}

//- (CommentView *)commentView {
//    if (!_commentView) {
//        _commentView = [[CommentView alloc]init];
//        [_commentView setDelegate:self];
//    }
//    return _commentView;
//}
//
//- (void)onCommentPosted:(NSString *)comment {
//
//    NSDictionary *parameters = @{@"news_content_id":@(_newsContentComment.news_content_id),@"parent_comment_id":@(_newsContentComment.news_content_comment_id),@"comment":comment};
//
//    [self.newsContentCommentPresenter requestNewsContentCommentAdd:parameters];
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置模式展示风格
    [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    //跳转动画效果
    [self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self.view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]];


//    if (_newsContentComment) {
//
//        _page_index = 1;
//        _type = TableViewOperationType_Refresh;
//
//        NSDictionary *parameters = @{@"news_content_id":@(_newsContentComment.news_content_id),@"news_content_comment_id":@(_newsContentComment.news_content_comment_id),@"index":@(_page_index),@"size":@(PAGE_SIZE)};
//
//        [self.newsContentCommentPresenter requestNewsContentCommentGetChildrenList:parameters];
//
//    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
