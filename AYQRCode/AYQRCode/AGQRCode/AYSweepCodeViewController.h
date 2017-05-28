//
//  AYSweepCodeViewController.h
//  AYQRCode
//
//  Created by Angelo on 2016/12/28.
//  Copyright © 2016年 Angelo. All rights reserved.
//


/*
 扫描需要访问手机摄像头，需要在 info.plist 添加如下字段
 <key>NSCameraUsageDescription</key>
 <string>App需要您的同意,才能访问相机</string>
 */

#import <UIKit/UIKit.h>

typedef void(^ay_finishScandBlock)(id result);





@interface AYSweepCodeViewController : UIViewController

@property(nonatomic , copy)ay_finishScandBlock block;

- (void)ay_setBlock:(ay_finishScandBlock)block;

@end
