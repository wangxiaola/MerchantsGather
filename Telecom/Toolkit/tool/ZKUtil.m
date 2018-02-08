//
//  ZKUtil.m
//  Emergency
//
//  Created by 王小腊 on 2016/11/23.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "ZKUtil.h"
#import "UIImageView+WebCache.h"
#import <sys/sysctl.h>

@implementation ZKUtil

+ (void)downloadImage:(UIImageView *)imageView imageUrl:(NSString*)url;
{
    if (![url containsString:IMAGE_URL]) {
        url = [NSString stringWithFormat:@"%@%@",IMAGE_URL,url];
    }
    [imageView sd_setImageWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

+ (void)downloadImage:(UIImageView *)imageView imageUrl:(NSString *)url  duImageName:(NSString*)duImage;
{
    if (![url containsString:IMAGE_URL]) {
        url = [NSString stringWithFormat:@"%@%@",IMAGE_URL,url];
    }
    [imageView sd_setImageWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:duImage]];
}

+ (void)cacheUserValue:(NSString *)value key:(NSString *)key;
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}
+ (NSString *)getUserDataForKey:(NSString *)key;
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if (key)
    {
        
        NSString *phone=[defaults objectForKey:key];
        return phone;
    }else{
        
        return @"";
    }
    
}
+ (void)cacheForData:(NSData *)data fileName:(NSString *)fileName
{
    NSString *path = [kCachePath stringByAppendingPathComponent:fileName];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [data writeToFile:path atomically:YES];
    });
}

+ (NSData *)getCacheFileName:(NSString *)fileName
{
    NSString *path = [kCachePath stringByAppendingPathComponent:fileName];
    return [[NSData alloc] initWithContentsOfFile:path];
}



+ (BOOL)isExpire:(NSString *)fileName
{
    NSString *path = [kCachePath stringByAppendingPathComponent:fileName];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *attributesDict = [fm attributesOfItemAtPath:path error:nil];
    NSDate *fileModificationDate = attributesDict[NSFileModificationDate];
    NSTimeInterval fileModificationTimestamp = [fileModificationDate timeIntervalSince1970];
    //现在的时间戳
    NSTimeInterval nowTimestamp = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    return ((nowTimestamp-fileModificationTimestamp)>kYBCache_Expire_Time);
}


+ (BOOL)obtainBoolForKey:(NSString *)key;
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
    
}
+ (void)saveBoolForKey:(NSString *)key valueBool:(BOOL)value;
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (BOOL)isMobileNumber:(NSString *)mobileNum;
{
    /**
     * 手机号码
     */
    NSString * MOBIL = @"^1(3[0-9]|4[0-9]|5[0-9]|7[0-9]|8[0-9])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    
    if ([regextestmobile evaluateWithObject:mobileNum]) {
        return YES;
    }
    return NO;
    
}
+ (BOOL)character:(NSString*)str;
{
    NSString *regex = @"[A-Za-z]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    NSString *k =[str substringToIndex:1];
    return [predicate evaluateWithObject:k];
    
}

//是否是纯数字

+ (BOOL)isNumText:(NSString *)str
{
    
    NSScanner* scan = [NSScanner scannerWithString:str];
    
    int val;
    
    return [scan scanInt:&val] && [scan isAtEnd];
    
}
+ (BOOL)ismoney:(NSString *)str
{
    if (str.length == 0)
    {
        return NO;
    }
    NSString *stringRegex = @"(\\+|\\-)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,9}(([.]\\d{0,2})?)))?";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
    BOOL flag = [phoneTest evaluateWithObject:str];
    
    return flag;
    
}
+ (BOOL)isInteger:(NSString *)str
{
    if (str.length == 0)
    {
        return NO;
    }
    NSString *first = [str substringToIndex:1];//字符串开始
    if ([first integerValue] == 0)
    {
        return NO;
    }
    return YES;
}
+ (BOOL)checkNumber:(NSString *)mobileNum
{
    NSString *tel = [mobileNum stringByReplacingOccurrencesOfString:@"-" withString:@""];

    if (tel.length>13 || tel.length <6)
    {
        return NO;
    }
    else if (tel.length == 13)
    {
        return [self isMobileNumber:tel];
    }
    else
    {
     return [self isNumText:tel];
    }
}
+ (CGSize)contentLabelSize:(CGSize)size labelFont:(UIFont*)font labelText:(NSString*)str
{
    return [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

+ (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}
//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;}
+ (NSMutableAttributedString *)ls_changeFontAndColor:(UIFont *)font Color:(UIColor *)color TotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray;
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    for (NSString *rangeStr in subArray) {
        
        NSRange range = [totalString rangeOfString:rangeStr options:NSBackwardsSearch];
        if (color) {
            
            [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
        
        [attributedStr addAttribute:NSFontAttributeName value:font range:range];
    }
    
    return attributedStr;
}
+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
+ (NSString *)timeStamp
{
    NSTimeInterval time= [[NSDate date] timeIntervalSince1970] * 1000;
    
    return [NSString stringWithFormat:@"%lld", (long long)time];
}


+ (NSString*)deviceVersion
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space
{
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}
+ (void)shakeAnimationForView:(UIView *)view
{
    if (view == nil)
    {
        return;
    }
    //获取到当前View的layer
    CALayer *viewLayer = view.layer;
    //获取当前View的位置
    CGPoint position = viewLayer.position;
    //移动的两个终点位置
    CGPoint beginPosition = CGPointMake(position.x + 10, position.y);
    CGPoint endPosition = CGPointMake(position.x - 10, position.y);
    //设置动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    //设置运动形式
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    //设置开始位置
    [animation setFromValue:[NSValue valueWithCGPoint:beginPosition]];
    //设置结束位置
    [animation setToValue:[NSValue valueWithCGPoint:endPosition]];
    //设置自动反转
    [animation setAutoreverses:YES];
    //设置时间
    [animation setDuration:.06];
    //设置次数
    [animation setRepeatCount:3];
    //添加上动画
    [viewLayer addAnimation:animation forKey:@"vibrationAnimation"];
}
//身份证号
+ (BOOL)checkIsIdentityCard:(NSString *)identityCard;
{
    //判断是否为空
    if (identityCard==nil||identityCard.length <= 0) {
        return NO;
    }
    //判断是否是18位，末尾是否是x
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if(![identityCardPredicate evaluateWithObject:identityCard]){
        return NO;
    }
    //判断生日是否合法
    NSRange range = NSMakeRange(6,8);
    NSString *datestr = [identityCard substringWithRange:range];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyyMMdd"];
    if([formatter dateFromString:datestr]==nil){
        return NO;
    }
    
//    //判断校验位
//    if(identityCard.length==18)
//    {
//        NSArray *idCardWi= @[ @"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2" ]; //将前17位加权因子保存在数组里
//        NSArray * idCardY=@[ @"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2" ]; //这是除以11后，可能产生的11位余数、验证码，也保存成数组
//        int idCardWiSum=0; //用来保存前17位各自乖以加权因子后的总和
//        for(int i=0;i<17;i++){
//            idCardWiSum+=[[identityCard substringWithRange:NSMakeRange(i,1)] intValue]*[idCardWi[i] intValue];
//        }
//
//        int idCardMod=idCardWiSum%11;//计算出校验码所在数组的位置
//        NSString *idCardLast=[identityCard substringWithRange:NSMakeRange(17,1)];//得到最后一位身份证号码
//
//        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
//        if(idCardMod==2){
//            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]){
//                return YES;
//            }else{
//                return NO;
//            }
//        }else{
//            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
//            if([idCardLast intValue]==[idCardY[idCardMod] intValue]){
//                return YES;
//            }else{
//                return NO;
//            }
//        }
//    }
    if(identityCard.length == 18)
    {
        return YES;
    }
    return NO;
}

/**
 *  计算文字长度
 */
+ (CGFloat )widthForLabel:(NSString *)text fontSize:(CGFloat)font
{
    CGSize size = [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font], NSFontAttributeName, nil]];
    return size.width;
}
//判断是否银行卡

+ (BOOL) checkCardNo:(NSString*) cardNo{
    
    int oddsum = 0;    //奇数求和
    
    int evensum = 0;    //偶数求和
    
    int allsum = 0;
    
    int cardNoLength = (int)[cardNo length];
    
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];

    cardNo = [cardNo substringToIndex:cardNoLength -1];
    
    for (int i = cardNoLength -1 ; i>=1;i--) {
        
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1,1)];
        
        int tmpVal = [tmpString intValue];
        
        if (cardNoLength % 2 ==1 ) {
            
            if((i % 2) == 0){
                
                tmpVal *= 2;
                
                if(tmpVal>=10)
                    
                    tmpVal -= 9;
                
                evensum += tmpVal;
                
            }else{
                
                oddsum += tmpVal;
                
            }
            
        }else{
            
            if((i % 2) == 1){
                
                tmpVal *= 2;
                
                if(tmpVal>=10)
                    
                    tmpVal -= 9;
                
                evensum += tmpVal;
                
            }else{
                
                oddsum += tmpVal;
                
            }
            
        }
        
    }

    allsum = oddsum + evensum;
    
    allsum += lastNum;
    
    if((allsum % 10) ==0)
        
        return YES;
    
    else
        
        return NO;
    
}
/**
 返回一个子文件路径
 
 @param superiorName 上一级文件名
 @param childName 子文件名
 @return 子文件完成路径
 */
+ (NSString *)createRecordingSuperiorName:(NSString *)superiorName childName:(NSString *)childName;
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *createPath = [kDocumentPath stringByAppendingPathComponent:KrecordPath];
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:createPath]) {
        
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    NSString *superiorPath = [createPath stringByAppendingPathComponent:superiorName];
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:superiorPath]) {
        
        [fileManager createDirectoryAtPath:superiorPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *outputURL = [superiorPath stringByAppendingPathComponent:childName];
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:outputURL]) {
        
        [fileManager createDirectoryAtPath:outputURL withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return outputURL;
}
@end
