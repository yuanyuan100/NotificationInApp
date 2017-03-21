//
//  PYOperationManager.m
//  PYOperationManager
//
//  Created by Snake on 16/12/15.
//  Copyright © 2016年 IAsk. All rights reserved.
//

#import "PYOperationManager.h"

@interface PYOperationManager ()
@property (nonatomic, assign, readwrite) DoOneTaskState doOneTaskState;
@end

@implementation PYOperationManager
{
    NSOperationQueue *_queue;
    NSBlockOperation *_TempblockOperation;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _queue = [NSOperationQueue mainQueue]; // <! 运行在主线程上
    }
    return self;
}

+ (instancetype)manager {
    return [PYOperationManager new];
}

- (void)addTask:(void (^)(void))callBack waitUitl:(NSTimeInterval)waitTime {
    NSParameterAssert(callBack);
    // 队列挂起
    [_queue setSuspended:YES];
    // 准备任务
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:callBack];
    _TempblockOperation = blockOperation;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(waitTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 队列中添加任务
        [_queue addOperation:blockOperation];
        // 队列执行
        _queue.suspended = NO;
        //等待工作状态
        self.doOneTaskState = DoOneTask_Waiting;
    });
}

- (void)addReplacePreviousTask:(void (^)(void))callBack waitUitl:(NSTimeInterval)waitTime {
    NSParameterAssert(callBack);
    [self cancel];
    [self addTask:callBack waitUitl:waitTime];
}

- (void)addDoOneTask:(void (^)(void))callBack waitUitl:(NSTimeInterval)waitTime {
    NSParameterAssert(callBack);
    if (self.doOneTaskState == DoOneTask_Working) {
        return;
    }
    self.doOneTaskState = DoOneTask_Working;
    [self addTask:callBack waitUitl:waitTime];
}

- (void)cancel {
    // 取消之前挂起的任务（放弃执行）
    [_TempblockOperation cancel];
}
@end
