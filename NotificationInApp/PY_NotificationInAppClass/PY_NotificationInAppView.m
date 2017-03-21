//
//  PY_NotificationInAppView.m
//  NotificationInApp
//
//  Created by Snake on 17/3/20.
//  Copyright © 2017年 IAsk. All rights reserved.
//

#import "PY_NotificationInAppView.h"
#import "PYOperationManager/PYOperationManager.h"

#ifndef UI_SCREEN_WIDTH
#define UI_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#endif
#ifndef UI_SCREEN_HEIGHT
#define UI_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#endif

#ifndef UI_DEVICE_SYSTEM
#define UI_DEVICE_SYSTEM [UIDevice currentDevice].systemName.integerValue
#endif


@interface PY_NotificationInAppView ()
@property (nonatomic, readonly, assign) CGSize size;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, getter = isShowing, assign) BOOL showing;
@property (nonatomic, getter = isHiding, assign) BOOL hiding;

@property (nonatomic, strong) PYOperationManager *operationManager;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipGesture;

@property (nonatomic, strong) void(^SureBlock)();
@property (nonatomic, strong) void(^CancelBlock)();

@end

@implementation PY_NotificationInAppView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self creatUI];
        self.operationManager = [PYOperationManager manager];
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerGesture:)];
        self.swipGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handlerGesture:)];
        self.swipGesture.direction = UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:self.tapGesture];
        [self addGestureRecognizer:self.swipGesture];
    }
    return self;
}

- (void)handlerGesture:(UIGestureRecognizer *)gesture {
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
        [self hideRightNow];
        if (self.SureBlock) {
            self.SureBlock();
        }
    } else if ([gesture isKindOfClass:[UISwipeGestureRecognizer class]]) {
        
        [self hide];
        
        if (self.CancelBlock) {
            self.CancelBlock();
        }
    }
}

- (void)creatUI {
    // 基本属性
    self.frame = CGRectMake(0, -self.size.height, self.size.width, self.size.height);
    self.backgroundColor = [UIColor colorWithRed:208.0f/255.0 green:0.0f blue:24.0f/255.0 alpha:0.9f];
    self.layer.shadowColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1].CGColor;
    self.layer.shadowOffset = CGSizeMake(6, 6);
    self.layer.shadowOpacity = 0.3;
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithRed:255.0f/255.0 green:255.0f/255.0 blue:255.0f/255.0 alpha:1.0f];
    self.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    self.titleLabel.text = @"新消息";
    CGSize maxTitleSize = CGSizeMake(100.0f, 36.0f);
    CGSize fitTitleSize = [self.titleLabel sizeThatFits:maxTitleSize];
    self.titleLabel.frame = CGRectMake(9, (maxTitleSize.height - fitTitleSize.height) / 2.0f, fitTitleSize.width, fitTitleSize.height);
    [self addSubview:self.titleLabel];
    
    // 时间
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = [UIColor colorWithRed:255.0f/255.0 green:255.0f/255.0 blue:255.0f/255.0 alpha:1.0f];
    self.timeLabel.font = [UIFont systemFontOfSize:13.0f];
    self.timeLabel.text = @"现在";
    CGSize maxTimeSize = CGSizeMake(100.0f, 36.0f);
    CGSize fitTimeSize = [self.timeLabel sizeThatFits:maxTimeSize];
    self.timeLabel.frame = CGRectMake(self.size.width - 18.0f - fitTimeSize.width, (maxTimeSize.height - fitTimeSize.height) / 2.0f, fitTimeSize.width, fitTimeSize.height);
    [self addSubview:self.timeLabel];
    
    // 内容
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.textColor = [UIColor colorWithRed:255.0f/255.0 green:255.0f/255.0 blue:255.0f/255.0 alpha:1.0f];
    self.messageLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maxMessageSize = CGSizeMake(self.size.width - 2 * 15.0f, 38.0f);
    CGSize fitMessageSize = [self.titleLabel sizeThatFits:maxMessageSize];
    self.messageLabel.frame = CGRectMake(9, 36.0f + (maxMessageSize.height - fitMessageSize.height) / 2.0f, self.size.width - 30.0f, fitMessageSize.height);
    [self addSubview:self.messageLabel];
    
    // 中间线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 35.0f, UI_SCREEN_WIDTH, 0.5f)];
    lineView.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.2f];
    [self addSubview:lineView];
}

- (void)show {
    if (!self.isShowing) {
        self.showing = YES;
        self.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.3f animations:^{
            self.frame = CGRectMake(0, 20.0f, self.size.width, self.size.height);
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = YES;
            __weak typeof(self) weakSelf = self;
            [self.operationManager addReplacePreviousTask:^{
                [weakSelf hide];
            } waitUitl:4.0f];
        }];
    }
}

- (void)hide {
    if (!self.isHiding) {
        self.showing = NO;
        self.hiding = YES;
        self.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.3f animations:^{
            self.frame = CGRectMake(0, -self.size.height, self.size.width, self.size.height);
        } completion:^(BOOL finished) {
            self.hiding = NO;
        }];
    }
}

- (void)hideRightNow {
    if (self.isShow) {
        self.showing = NO;
        self.frame = CGRectMake(0, -self.size.height, self.size.width, self.size.height);
    }
}

- (void)reassignSure:(void (^)())sure cancel:(void (^)())cancel {
    self.SureBlock = sure;
    self.CancelBlock = cancel;
}

- (void)updateMessages:(NSString *)messages {
    self.messageLabel.text = messages ? messages : @"点击查看详情";
}

- (void)updateTitle:(NSString *)title {
    self.titleLabel.text = title ? title : @"新消息";
}

#pragma mark -------- getter or setter
- (CGSize)size {
    return CGSizeMake(UI_SCREEN_WIDTH, 74.0f);
}

- (NSTimeInterval)duration {
    if (_duration <= 0) {
        _duration = 4.0f;
    }
    return _duration;
}

- (BOOL)isShow {
    if (self.frame.origin.y > -self.size.height) {
        return YES;
    }
    return NO;
}
@end
