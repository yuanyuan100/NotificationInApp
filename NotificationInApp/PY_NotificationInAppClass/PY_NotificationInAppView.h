//
//  PY_NotificationInAppView.h
//  NotificationInApp
//
//  Created by Snake on 17/3/20.
//  Copyright © 2017年 IAsk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PY_NotificationInAppView : UIView
/** 展示时间 */
@property (nonatomic, assign) NSTimeInterval duration;
// 展示
- (void)show;
@property (nonatomic, readonly, getter = isShow, assign) BOOL show;
- (void)hideRightNow;

/**
 重新指定回调Block

 @param sure 确认后的回调
 @param cancel 向上滑动取消 或 指定时间 后取消
 */
- (void)reassignSure:(void(^)())sure cancel:(void(^)())cancel;

/**
 更新内容

 @param messages 消息内容
 */
- (void)updateMessages:(NSString *)messages;

/**
 更新标题

 @param title 消息标题
 */
- (void)updateTitle:(NSString *)title;
@end
