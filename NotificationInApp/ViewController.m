//
//  ViewController.m
//  NotificationInApp
//
//  Created by Snake on 17/3/20.
//  Copyright © 2017年 IAsk. All rights reserved.
//

#import "ViewController.h"
#import "PY_NotificationInAppView.h"

@interface ViewController ()
@property (nonatomic, strong) PY_NotificationInAppView *notificationView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.notificationView = [[PY_NotificationInAppView alloc] init];
//    [[UIApplication sharedApplication].keyWindow addSubview:self.notificationView];
    [self.view addSubview:self.notificationView];
    
    [self.notificationView reassignSure:^{
        
    } cancel:^{
        
    }];
}

- (IBAction)show:(id)sender {
    [self.notificationView updateMessages:@"请查看详情！ 这里有一座山，山上有一座庙，庙里有一个和尚，和尚有一口缸"];
    [self.notificationView show];
}
- (IBAction)hide:(id)sender {
    [self.notificationView hideRightNow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
