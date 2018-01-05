//
//  TBCountdownSingle.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/5.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBCountdownSingle.h"

static TBCountdownSingle *instance = nil;

@implementation TBCountdownSingle
{
        dispatch_source_t _timer;
}
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];

    });
    return instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (void)startTheDatelength:(int)number timeDate:(void (^)(NSString *numberString))date endTime:(void(^)(void))end;
{
    __block int timeout = number; //倒计时时间
//    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                if (end)
                {
                    end();
                }
                [ZKUtil cacheUserValue:@"" key:Verification_code];
                [ZKUtil cacheUserValue:@"" key:Verification_phone];
                if (self.user == YES) {
                    
                    self.verifyTimeNumber = 0;
                }
                else
                {
                    self.setPasswordTimeNumber = 0;
                }

            });
            
        }else{
            
            int seconds = timeout % (number+1);
            
            NSString *strTime = [NSString stringWithFormat:@"%.2ld", (long)seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (self.user == YES) {
                    
                    self.verifyTimeNumber = seconds;
                }
                else
                {
                    self.setPasswordTimeNumber = seconds;
                }

                

                if (date)
                {
                    date(strTime);
                }
                
            });
            
            timeout--;
            
        }
        
    });
    
    dispatch_resume(_timer);

}
@end
