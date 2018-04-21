//
//  GeneralUtil.h
//  Partner
//
//  Created by GOKIT on 2017/7/20.
//  Copyright © 2017年 ADH. All rights reserved.
//

#import <Foundation/Foundation.h>
// 颜色转换：iOS中十六进制的颜色转换为UIColor(RGB)
#import <UIKit/UIKit.h>


@interface GeneralUtil : NSObject


/**
 颜色转换三：iOS中十六进制的颜色（以#开头）转换为UIColor

 @param color color
 @return return value
 */
+ (UIColor *)colorWithHexString: (NSString *)color;

/**
 字典转成json字符串

 @param dictionary dictionary
 @return return value
 */
+ (NSString *)dictionaryToJsonString:(NSDictionary *)dictionary;

/**
 json字符串转成字典

 @param jsonString jsonString
 @return return value
 */
+ (NSMutableDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 改变图片颜色

 @param color color
 @param image image
 @return return value
 */
+ (UIImage *)imageWithColor:(UIColor *)color withImage:(UIImage *)image;

/**
 颜色转换图片

 @param color color
 @return return value
 */
+(UIImage*)createImageByColor:(UIColor *) color;

/**
 将时间戳转换为NSDate类型

 @param miliSeconds miliSeconds
 @return return value
 */
+(NSDate *)getDateTimeFromMilliSeconds:(long long) miliSeconds;

/**
 将NSDate类型的时间转换为时间戳,从1970/1/1开始

 @param datetime datetime
 @return return value
 */
+(long long)getDateTimeTOMilliSeconds:(NSDate *)datetime;

/**
 NSDate格式化为时间字符串（yyyy-MM-dd HH:mm:ss）

 @param date date
 @return 返回时间字符串
 */
+(NSString *)formatToString:(NSDate *)date;

/**
 把时间字符串格式化为NSDate（yyyy-MM-dd HH:mm:ss）

 @param stringDate 时间字符串（yyyy-MM-dd HH:mm:ss）
 @return date
 */
+(NSDate *)formatToDate:(NSString *)stringDate;

/**
 判断时间是否是今天

 @param dateTime 传入的时间值
 @return 是否是今天
 */
+ (BOOL)isToday:(NSDate *)dateTime;

/**
 获取手机类型

 @return 返回手机类型
 */
+(NSString *)iphoneType;

/**
 验证电话号码

 @param mobile 电话号码
 @return 返回验证结果
 */
+ (BOOL)validateMobile:(NSString *)mobile;

/**
 正则匹配用户密码8-16位数字和字母组合

 @param password password
 @return return 是否符合
 */
+ (BOOL)checkPassword:(NSString *)password;


/**
 正则匹配传真号码

 @param FaxNumber FaxNumber
 @return return 是否符合
 */
+ (BOOL)checkFaxNumber:(NSString *)FaxNumber;

/**
 压缩图片

 @param image image
 @param maxLength maxLength
 @return return 返回新的图片
 */
+ (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

/**
 获取设备UUID
 
 @return 返回UUID
 */
+(NSString *)getDeviceUUID;


/**
 获取当前屏幕中present出来的viewcontroller

 @return 返回控制器
 */
+ (UIViewController *)getPresentedViewController;

+ (UIViewController *)getCurrentVC;


/**
 打电话

 @param phone 电话号码
 */
+ (void)callPhone:(NSString *)phone;


/**
 获取指定宽度width,字体大小fontSize,字符串value的高度

 @param text 待计算的字符串
 @param width 字体的大小
 @param fontSize 限制字符串显示区域的宽度
 @return 返回的高度
 */
+ (float)heightForText:(NSString *)text andWidth:(float)width withFont:(float)fontSize;

/**
 @method 获取指定高度height,字体大小fontSize,字符串value的宽度
 @param text 待计算的字符串
 @param fontSize 字体的大小
 @param height 限制字符串显示区域的宽度
 @result float 返回的高度
 */
+ (float)widthForText:(NSString *)text andHeight:(float)height withFont:(float)fontSize;


@end
