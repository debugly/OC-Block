//
//  main.m
//  OC-Block
//
//  Created by xuqianlong on 2017/2/25.
//  Copyright © 2017年 xuqianlong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Blocker.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Blocker *obj = [Blocker new];
        
        ///3.作为实参,不需要手写，IDE帮你写好了
        [obj doSomeThingWithCompletion:^(NSDictionary *ps) {
            NSLog(@"reslut:%@",ps[@"code"]);
        }];
        ///3.作为实参,不需要手写，IDE帮你写好了
        [obj registerXXXHandler:^(float money) {
            
        }];
        
        ///6.作为返回值，支持链式编程
        [obj.c_name(@"NX") say];
        
        ///7.实现双向通信:
        /*
            思路：外部调用下载逻辑，触发内部检查逻辑；
                     内部将检查结果封装为err回调给外部；
                     外部根据 err 类型做出一个决定，然后通过内部传过来的callBack，将结果回传到内部；
                     内部根据外部最终的决定，做出相应的处理；
           
         也可以通过别的方式实现，不过流程上肯定没有这个紧凑，好理解；
         */
        
        [obj downloadVideo:100023 completion:^(NSError *err, AuthorizeCallBack callBack) {
            if(err){
                ///这里你可以弹窗询问，是否允许使用3G网络下载；
                BOOL isAllowUse3G = YES;
                if (isAllowUse3G) {
                    NSLog(@"用户点击了允许使用3G");
                    callBack(YES);
                }else{
                    NSLog(@"用户点击了取消");
                    callBack(NO);
                }
            }else{
                callBack(YES);//当内部逻辑没有检查出错误时，就回调内部逻辑，可开始下载了；
            }
        }];
        
        ///让程序一直存活，不立即退出！
        [[NSRunLoop currentRunLoop]run];
    }
    return 0;
}
