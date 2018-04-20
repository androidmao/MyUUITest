//
//  NewsCommentTableViewCell.m
//  AnXinClient
//
//  Created by GOKIT on 2018/2/6.
//  Copyright © 2018年 AnXin. All rights reserved.
//

#import "NewsCommentTableViewCell.h"
#import "NSDate+YYAdd.h"

@interface NewsCommentTableViewCell ()

@property (nonatomic,strong) UIImageView *avatarImageView;

@property (nonatomic,strong) UILabel *usernameLabel;

@property (nonatomic,strong) UILabel *commentLabel;

@property (nonatomic,strong) UILabel *createTimeLabel;

@property (nonatomic,strong) UIImageView *likeImageView;

@end

@implementation NewsCommentTableViewCell


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

- (UIImageView *)likeImageView {
    if (!_likeImageView) {
        _likeImageView = [[UIImageView alloc]init];
        [_likeImageView setImage:[UIImage imageNamed:@""]];
    }
    return _likeImageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self initSubView];
    }
    return self;
}


- (void)initSubView {

    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.usernameLabel];
    [self.contentView addSubview:self.commentLabel];
    [self.contentView addSubview:self.createTimeLabel];

    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(15);
        make.top.mas_equalTo(self.contentView).mas_offset(15);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];

    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(15);
        make.top.mas_equalTo(self.contentView).mas_offset(15);
        make.size.mas_equalTo(CGSizeMake(120, 20));
    }];

    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(15);
        make.right.mas_equalTo(self.contentView).mas_offset(-15);
        make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_offset(15);
        make.bottom.mas_equalTo(self.createTimeLabel.mas_top).mas_offset(-15);
    }];

    [self.createTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(15);
        make.right.mas_equalTo(self.contentView).mas_offset(-15);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-10);
        make.height.mas_equalTo(20);
    }];

}

- (void)setNewsContentComment:(NewsContentComment *)newsContentComment {

    if (newsContentComment) {
        [self.usernameLabel setText:newsContentComment.user_name];
        [self.commentLabel setText:newsContentComment.comment];
        NSDate *timedate = [NSDate dateWithString:newsContentComment.create_time format:@"yyyy-MM-dd HH:mm:ss"];
        NSString *timeStr = [NSDate detailTimeAgoString:timedate];
        [self.createTimeLabel setText:[NSString stringWithFormat:@"%@ · %ld回复",timeStr,(long)newsContentComment.comment_count]];
    }

}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
