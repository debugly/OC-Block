//
//  Blocker.h
//  OC-Block
//
//  Created by xuqianlong on 2017/2/25.
//  Copyright © 2017年 xuqianlong. All rights reserved.
//

#import <Foundation/Foundation.h>

//4. typedef 出"新类型"
typedef void (^NetworkCompletion)(NSError *err,id result);

typedef void (^AuthorizeCallBack)(BOOL ok);
typedef void (^DownloadHandler)(NSError *err,AuthorizeCallBack);


@interface Blocker : NSObject

///1.描述为属性
@property (nonatomic, copy) int (^PropertyBlock)(NSArray *colors);
///2.a 作为形参
- (void)doSomeThingWithCompletion:(void (^)(NSDictionary *ps))blockName;
///2.b 作为形参
- (void)registerXXXHandler:(void (^)(float money))handler;

///使用 typedef 出来的 “新”类型
@property (nonatomic, copy) NetworkCompletion networkCompletion;

///5.方法内部当局部变量使用
- (void)lookSomeCode;

@property (nonatomic, copy) NSString *name;

///6.方法返回值
- (Blocker *(^)(NSString *name))c_name;

///7.高阶block，实现双向通信

/**
 模拟3G网络下载视频，弹框提示需求

 @param Vid 视频的id
 @param handler 处理逻辑,不能为空！
 */
- (void)downloadVideo:(long long) Vid completion:(DownloadHandler)handler;

- (void)say;

@end
