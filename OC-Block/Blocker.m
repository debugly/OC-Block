//
//  Blocker.m
//  OC-Block
//
//  Created by xuqianlong on 2017/2/25.
//  Copyright © 2017年 xuqianlong. All rights reserved.
//

#import "Blocker.h"

@interface Blocker ()

@property (nonatomic,copy) void (^xxxHandler)(float);

@end

@implementation Blocker

- (void)doSomeThingWithCompletion:(void (^)(NSDictionary *))blockName
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (blockName) {
            blockName(@{@"code":@"200"});
        }
    });
}

- (void)registerXXXHandler:(void (^)(float))handler
{
    self.xxxHandler = handler;
}

- (void)lookSomeCode
{
    BOOL xx;
    BOOL yy;
    //....
    
    //将某些逻辑封装到 SomeCode 块里面；可以省去写相同代码的麻烦，也不必开辟一个新的方法
    void(^SomeCode)(void) = ^{
        NSLog(@"这部分逻辑相同");
    };
    
    if(xx){
        if (yy) {
            SomeCode();
        }else{
            NSLog(@"逻辑1");
        }
    }else{
        if(yy){
            NSLog(@"逻辑2");
        }else{
            SomeCode();
        }
    }
}

- (Blocker *(^)(NSString *name))c_name
{
    Blocker *(^nameBlock)(NSString *name) = ^ Blocker *(NSString *name) {
        self.name = name;
        return self;
    };
    
    return nameBlock;
}

- (void)say
{
    NSLog(@"I'm %@",self.name);
}

- (void)downloadVideo:(long long)Vid completion:(DownloadHandler)handler
{
    NSParameterAssert(handler);
    
    BOOL netIs3G = YES; ///模拟3G网络
    
    AuthorizeCallBack callBack = ^(BOOL ok){
        if (ok) {
            NSLog(@"允许下载，启动下载逻辑");
        }else{
            NSLog(@"不允许下载，什么也不做");
        }
    };
    
    if (netIs3G) {
        handler([NSError errorWithDomain:@"yourdomain" code:30000 userInfo:nil],callBack);
    }else{
        handler(nil,callBack);
    }
}
@end
