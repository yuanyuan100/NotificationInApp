//
//  PYOperationManager.h
//  PYOperationManager
//
//  Created by Snake on 16/12/15.
//  Copyright © 2016年 IAsk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DoOneTaskState) {
    DoOneTask_Waiting = 0,      // !< 默认状态，等待接受工作状态
    DoOneTask_Working = 1,      // !< 工作接受中，等待执行状态
};

@interface PYOperationManager : NSObject
/**
 一个管理对象，管理一组工作状态 --pyy
 */
+ (instancetype)manager;

/**
 添加一个任务，等待waitTime后执行

 @param callBack 任务内容
 @param waitTime 等待时间
 */
- (void)addTask:(void(^)(void))callBack waitUitl:(NSTimeInterval)waitTime;
/**
 添加一个任务，等待waitTime后执行，若在等待时间内有新的任务，则放弃之前任务，重新等待waitTime
 
 @param callBack 任务内容
 @param waitTime 等待时间
 */
- (void)addReplacePreviousTask:(void(^)(void))callBack waitUitl:(NSTimeInterval)waitTime;
/**
 添加一个任务，等待waitTime后执行，在等待时间内若有其它任务则不执行（这些任务被抛弃），等待waitTime后可重新添加任务
 
 @param callBack 任务内容
 @param waitTime 等待时间
 */
- (void)addDoOneTask:(void(^)(void))callBack waitUitl:(NSTimeInterval)waitTime;
/** 获取当前工作状态 */
@property (nonatomic, assign, readonly) DoOneTaskState doOneTaskState;
/**
 取消当前任务 --pyy
 */
- (void)cancel;
@end
