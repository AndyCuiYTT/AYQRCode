//
//  ViewController.m
//  AYQRCode
//
//  Created by Andy on 2017/5/28.
//  Copyright © 2017年 Andy. All rights reserved.
//

#import "ViewController.h"
#import "AYGenerateQRCode.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _imageView.contentMode = UIViewContentModeCenter;
    _imageView.image = [AYGenerateQRCode ay_generateQRCodeWithContent:@"Hello World" codeImageSize:300];

}

- (IBAction)qrcodeNormal:(UIButton *)sender {
    
    
    _imageView.image = [AYGenerateQRCode ay_generateQRCodeWithContent:@"Hello World" codeImageSize:300];
    
    
    
}


- (IBAction)qrcodeColor:(UIButton *)sender {
    
    _imageView.image = [AYGenerateQRCode ay_generateQRCodeWithContent:@"Hello World" codeImageSize:300 logo:[UIImage imageNamed:@"icon.jpeg"] logoFrame:CGRectMake(125, 125, 50, 50) red:0.8 green:0.5 blue:0.3];
    
}

- (IBAction)generateNormal:(UIButton *)sender {
    
    _imageView.image = [AYGenerateQRCode ay_generateBarCodeImageWithContent:@"Hello World" codeImageSize:CGSizeMake(300, 100)];
    
}
- (IBAction)generateColor:(UIButton *)sender {
    
    _imageView.image = [AYGenerateQRCode ay_generateBarCodeImageWithContent:@"Hello World" codeImageSize:CGSizeMake(300, 100) red:0.7 green:0.5 blue:0.2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
