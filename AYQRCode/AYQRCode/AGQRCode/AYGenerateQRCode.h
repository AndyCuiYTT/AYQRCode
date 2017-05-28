//
//  AYGenerateQRCode.h
//  AYQRCode
//
//  Created by Angelo on 2016/12/28.
//  Copyright © 2016年 Angelo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface AYGenerateQRCode : NSObject

#pragma mark ---- 二维码 ----

/**
 生成带颜色二维码

 @param content 二维码内容
 @param width 二维码宽
 @param logo logo
 @param logoFrame logo 位置
 @param red 颜色 (0~1)
 @param green 颜色 (0~1)
 @param blue 颜色 (0~1)
 */
+ (UIImage*)ay_generateQRCodeWithContent:(NSString*)content
                       codeImageSize:(CGFloat)width
                                logo:(UIImage*)logo
                           logoFrame:(CGRect)logoFrame
                                 red:(CGFloat)red
                               green:(CGFloat)green
                                blue:(CGFloat)blue;

/**
 修改二维码尺寸
 
 @param content 二维码内容
 @param width 二维码尺寸
 @return 二维码图片
 */
+ (UIImage *)ay_generateQRCodeWithContent:(NSString *)content codeImageSize:(CGFloat)width;

#pragma mark ---- 条形码 ----

/**
 生成条形码

 @param content 条形码内容
 @param size 大小
 @param red 颜色 (0~1)
 @param green 颜色 (0~1)
 @param blue 颜色 (0~1)
 @return 条形码
 */
+ (UIImage *)ay_generateBarCodeImageWithContent:(NSString *)content
                       codeImageSize:(CGSize)size
                                 red:(CGFloat)red
                               green:(CGFloat)green
                                blue:(CGFloat)blue;



/**
 原始条形码

 @param content 内容
 @param size 大小
 @return 条形码
 */
+ (UIImage *)ay_generateBarCodeImageWithContent:(NSString *)content codeImageSize:(CGSize)size;



@end
