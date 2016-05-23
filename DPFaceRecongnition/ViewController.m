//
//  ViewController.m
//  DPFaceRecongnition
//
//  Created by dapiao on 16/5/23.
//  Copyright © 2016年 dapiao. All rights reserved.
//

#import "ViewController.h"
#import "DPCamera.h"
#import "DPCameraPreview.h"
@interface ViewController ()

@property (nonatomic, strong) DPCamera *camera;
@property (nonatomic, strong) DPCameraPreview *previewView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.camera = [[DPCamera alloc] initCamera];
    self.previewView = [[DPCameraPreview alloc]initWithFrame:self.view.bounds];
    [self.previewView setSession:self.camera.captureSession];
    self.camera.faceDetectionDelegate = self.previewView;
    [self.view addSubview:self.previewView];
    [self.camera startSession];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 65, 50);
    btn.center = CGPointMake(self.view.center.x, self.view.bounds.size.height-50);
    [btn setImage:[UIImage imageNamed:@"big_camera_icon"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(switchCameras) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)switchCameras
{
    [self.camera switchCameras];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
