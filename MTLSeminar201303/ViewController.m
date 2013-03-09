//
//  ViewController.m
//  MTLSeminar201303
//
//  Created by Kasajima Yasuo on 2013/03/05.
//  Copyright (c) 2013年 kasajei. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)pressFilterBtn:(id)sender {
    NSLog(@"ボタンを押した！");
    // GUIで設定した画像を取得する
    UIImage *inputImage = self.imageView.image;
    
    // 画像をGPUImageのフォーマットに治す
    GPUImagePicture *imagePicture = [[GPUImagePicture alloc] initWithImage:inputImage];
    
    // セピアフィルターを作る
    GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];
    
    // イメージをセピアフィルターにくっつける
    [imagePicture addTarget:sepiaFilter];
    
    
    // ぼかしフィルターを作る
    GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    [blurFilter setBlurSize:4];
    
    // イメージをブラーフィルターにくっつける
    [imagePicture addTarget:blurFilter];
    
    
    // iPhoneを表示する
    // iPhoneの画像を用意する
    UIImage *iphone = [UIImage imageNamed:@"iphone.png"];
    GPUImagePicture *iphoneImg = [[GPUImagePicture alloc] initWithImage:iphone];
    
    // 画像を合成するためのブレンドモードを作る
    GPUImageNormalBlendFilter *nomalBlend = [[GPUImageNormalBlendFilter alloc] init];
    
    // iPhoneの画像を変形するためのフィルターを作る
    GPUImageTransformFilter *transform = [[GPUImageTransformFilter alloc] init];
    
    // 変形をどうするかを決める
    CGAffineTransform trans;
    trans = CGAffineTransformMakeScale(0.75, 0.75); //　縮小
    trans = CGAffineTransformTranslate(trans, 0, 0.5); // 移動
    [transform setAffineTransform:trans];
    
    // iPhoneの画像を変形する
    [iphoneImg addTarget:transform];
    
    // ブレンドする
    [blurFilter addTarget:nomalBlend]; // こっちがブレンドの下になる画像
    // 変形後のiPhoneのイメージを繋げる
    [transform addTarget:nomalBlend atTextureLocation:1]; // こっちが上になる画像
    
    
    // iPhoneの中に元の画像を入れるためのブレンド
    GPUImageNormalBlendFilter *insideImageBlend = [[GPUImageNormalBlendFilter alloc] init];
    
    // iPhoneの中に画像を入れるための変形
    GPUImageTransformFilter *insideTrans = [[GPUImageTransformFilter alloc] init];
    
    // iPhoneの中に画像を入れるための変形を決める
    CGAffineTransform transImg;
    transImg = CGAffineTransformMakeScale(0.64, 0.64);
    transImg = CGAffineTransformTranslate(transImg, 0.0, 1.05);
    [insideTrans setAffineTransform:transImg];

    // セピアを変形させる
    [sepiaFilter addTarget:insideTrans];
    
    // 変形させたものを合成する
    [nomalBlend addTarget:insideImageBlend];
    [insideTrans addTarget:insideImageBlend atTextureLocation:1];
    
    
    // フィルターを実行
    [imagePicture processImage];
    [iphoneImg processImage];
    // 実行したフィルターから、画像を取得する
    UIImage *outputImage = [insideImageBlend imageFromCurrentlyProcessedOutput];
    
    // 取得した画像をセットする
    self.imageView.image = outputImage;

}

- (IBAction)pressSaveBtn:(id)sender {
    UIImage *image = self.imageView.image;
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:image.CGImage
                                 metadata:nil
                          completionBlock:^(NSURL *assetURL, NSError *error){
                              if (!error) {
                                  NSLog(@"保存成功！");
                              }
                          }
     ];
}
@end
