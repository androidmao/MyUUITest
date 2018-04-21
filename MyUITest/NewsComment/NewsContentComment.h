//
//  NewsContentComment.h
//  AnXinClient
//
//  Created by GOKIT on 2018/2/6.
//  Copyright © 2018年 AnXin. All rights reserved.
//

#import "HYObject.h"

@interface NewsContentComment : HYObject

///新闻内容评论Id
@property (nonatomic,assign) NSInteger news_content_comment_id;
///父级评论Id
@property (nonatomic,assign) NSInteger parent_comment_id;
///新闻内容Id
@property (nonatomic,strong) NSString *comment;
///匿名回复
@property (nonatomic,assign) BOOL is_anonymous;
///用户Id
@property (nonatomic,assign) NSInteger user_id;
///用户名
@property (nonatomic,strong) NSString *user_name;
///新闻内容ID
@property (nonatomic,assign) NSInteger news_content_id;
///创建时间
@property (nonatomic,strong) NSString *create_time;
///树形码
@property (nonatomic,strong) NSString *tree_code;
///被评论回复次数
@property (nonatomic,assign) NSInteger comment_count;



@end
