//
//  ZKUtil.h
//  Emergency
//
//  Created by 王小腊 on 2016/11/23.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZKUtil : NSObject


/**
 *  下载图片
 *
 *  @param imageView self
 *  @param url       url
 */
+ (void)downloadImage:(UIImageView *)imageView imageUrl:(NSString *)url;
/**
 *  下载图片并且自定义传err图片
 *
 *  @param imageView   self
 *  @param url         url
 *  @param duImage 错误图片
 */
+ (void)downloadImage:(UIImageView *)imageView imageUrl:(NSString *)url  duImageName:(NSString*)duImage;

/**
 保存在NSUserDefaults

 @param value 值
 @param key 键
 */
+ (void)cacheUserValue:(NSString *)value key:(NSString *)key;

/**
 取出NSUserDefaults的值

 @param key 键
 @return 值
 */
+ (NSString *)getUserDataForKey:(NSString *)key;

/**
 *  缓存数据
 *
 *  @param fileName 缓存数据的文件名
 *
 *  @param data 需要缓存的二进制
 */
+ (void)cacheForData:(NSData *)data fileName:(NSString *)fileName;

/**
 *  取出缓存数据
 *
 *  @param fileName 缓存数据的文件名
 *
 *  @return 缓存的二进制数据
 */
+ (NSData *)getCacheFileName:(NSString *)fileName;

/**
 *  判断缓存文件是否过期
 */
+ (BOOL)isExpire:(NSString *)fileName;

/**
 *  获取缓存的大小
 *
 *  @return 缓存的大小  单位是B
 */
+ (NSUInteger)getSize;

/**
 *  清除缓存
 */
+ (void)clearCache;

/**
 获取bool值

 @param key 键
 @return 值
 */
+ (BOOL)obtainBoolForKey:(NSString *)key;

/**
 震动动画

 @param view 控件
 */
+ (void)shakeAnimationForView:(UIView *)view;
/**
  判断是否是金钱格式
*/
+ (BOOL)ismoney:(NSString *)str;

/**
 判断是否大于0的整数

 @param str 验证字段
 @return yes
 */
+ (BOOL)isInteger:(NSString *)str;
/**
 存bool值

 @param key 键
 @param value 值
 */
+ (void)saveBoolForKey:(NSString *)key valueBool:(BOOL)value;

/**
 *  正则判断手机号码地址格式
 *
 *  @param mobileNum 号码
 *
 *  @return yes为是
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
/**
 *  判断字符是否以字母开头
 *
 *  @param str 需验证的字符
 *
 *  @return yes为是
 */
+ (BOOL)character:(NSString *)str;

/**
 *  uilabel的状态
 *
 *  @param size 限制的宽高
 *  @param font 字体大小
 *  @param str  内容
 *
 *  @return 返回的 CGSize
 */
+ (CGSize)contentLabelSize:(CGSize)size labelFont:(UIFont*)font labelText:(NSString*)str;

/**
 获取当前屏幕中present出来的viewcontroller

 @return viewcontroller
 */
+ (UIViewController *)getPresentedViewController;

/**
 获取当前屏幕显示的viewcontroller

 @return vc
 */
+ (UIViewController *)getCurrentVC;
/**
 *  改变某些文字的颜色 并单独设置其字体
 *
 *  @param font        设置的字体
 *  @param color       颜色
 *  @param totalString 总的字符串
 *  @param subArray    想要变色的字符数组
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeFontAndColor:(UIFont *)font Color:(UIColor *)color TotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray;


/**
 验证数字

 @param str 字符串
 @return bool
 */
+ (BOOL)isNumText:(NSString *)str;

/**
 验证固话

 @param mobileNum 字符
 @return bool
 */
+ (BOOL)checkNumber:(NSString *)mobileNum;
/**
 * 时间戳
 *
 *  @return 时间戳字符串
 */
+ (NSString *)timeStamp;

/**
 获取当前版本

 @return 版本号
 */
+ (NSString*)deviceVersion;

/**
 改变行间距

 @param label label
 @param space 间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 验证身份证

 @param identityCard 身份证号码
 @return bool
 */
+ (BOOL)checkIsIdentityCard:(NSString *)identityCard;
/**
 *  计算文字长度
 */
+ (CGFloat )widthForLabel:(NSString *)text fontSize:(CGFloat)font;

/**
 判断银行卡号

 @param cardNo 卡号
 @return yes
 */
+ (BOOL)checkCardNo:(NSString*)cardNo; 
@end
