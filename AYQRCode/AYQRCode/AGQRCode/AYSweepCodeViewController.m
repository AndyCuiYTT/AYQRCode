//
//  AYSweepCodeViewController.m
//  AYQRCode
//
//  Created by Andy on 2016/12/28.
//  Copyright © 2016年 Andy. All rights reserved.
//

#import "AYSweepCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface AYSweepCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate,CAAnimationDelegate>

@property(nonatomic , strong)AVCaptureSession *captureSession;
@property(nonatomic , strong)AVCaptureMetadataOutput *captureMetadataOutput;

@end

@implementation AYSweepCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted|| status == AVAuthorizationStatusDenied) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"摄像头访问受限" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertC addAction:action];
        [self presentViewController:alertC animated:YES completion:nil];
    }else{
        [self ay_setupCaputureDevice];
        [self ay_setupView];
        [self ay_startRuning];
    }
}

//初始化扫描对象
- (void)ay_setupCaputureDevice{
    //初始化链接对象
    _captureSession = [[AVCaptureSession alloc] init];
    //高质量采集
    [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];

    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    _captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    
    
    if ([_captureSession canAddInput:captureDeviceInput]) {
        [_captureSession addInput:captureDeviceInput];
    }
    
    if ([_captureSession canAddOutput:_captureMetadataOutput]) {
        [_captureSession addOutput:_captureMetadataOutput];
    }
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    _captureMetadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
}

- (void)ay_setupView{
    CGPoint center = self.view.center;
    CGRect rect = [UIScreen mainScreen].bounds;
    AVCaptureVideoPreviewLayer *capturePreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanscanBg"]];
    imageView.frame = CGRectMake(0, 0, rect.size.width / 3 * 2, rect.size.width / 3 * 2);
    imageView.center = center;
    [self.view addSubview:imageView];
    
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, CGRectGetMinY(imageView.frame))];
    v1.backgroundColor = [UIColor colorWithRed:0.1 green:0.5 blue:1 alpha:0.5];
    [self.view addSubview:v1];
    
    UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(imageView.frame), CGRectGetMinX(imageView.frame), CGRectGetHeight(imageView.frame))];
    v2.backgroundColor = [UIColor colorWithRed:0.1 green:0.5 blue:1 alpha:0.5];
    [self.view addSubview:v2];
    
    UIView *v3 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame), CGRectGetMinY(imageView.frame),rect.size.width - CGRectGetMaxX(imageView.frame), CGRectGetHeight(imageView.frame))];
    v3.backgroundColor = [UIColor colorWithRed:0.1 green:0.5 blue:1 alpha:0.5];
    [self.view addSubview:v3];
    
    UIView *v4 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), rect.size.width,rect.size.height - CGRectGetMaxY(imageView.frame))];
    v4.backgroundColor = [UIColor colorWithRed:0.1 green:0.5 blue:1 alpha:0.5];
    [self.view addSubview:v4];
    
    
    //y x width height 扫描范围
    [_captureMetadataOutput setRectOfInterest:CGRectMake(imageView.frame.origin.y / rect.size.height, imageView.frame.origin.x / rect.size.width, imageView.frame.size.height / rect.size.height, imageView.frame.size.width / rect.size.width)];
    capturePreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    capturePreviewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:capturePreviewLayer atIndex:0];
    
    //扫描线
    UIImageView * line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, 8)];
    [imageView addSubview:line];
    line.backgroundColor = [UIColor clearColor];
    line.image = [UIImage imageNamed:@"scanLine"];
        CABasicAnimation *animationMove = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [animationMove setFromValue:@(0)];
    [animationMove setToValue:@(imageView.frame.size.height - 8)];
    animationMove.duration = 5.0f;
    animationMove.delegate = self;
    animationMove.repeatCount  = OPEN_MAX;
    animationMove.removedOnCompletion = NO;
    animationMove.fillMode = kCAFillModeForwards;
    animationMove.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [line.layer addAnimation:animationMove forKey:@"animationKey"];
    
    
    
    
    
    
    
    
}

- (void)ay_startRuning{
    [_captureSession startRunning];
}

- (void)ay_stopRuning{
    [_captureSession stopRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        [_captureSession stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        if (_block) {
            _block(metadataObject.stringValue);
        }
    }
}

- (void)ay_setBlock:(ay_finishScandBlock)block{
    _block = block;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
