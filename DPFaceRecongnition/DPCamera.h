//
//  DPCamera.h
//  DPFaceRecongnition
//
//  Created by dapiao on 16/5/23.
//  Copyright © 2016年 dapiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol DPFaceDetectionDelegate <NSObject>

- (void)didDetectFaces:(NSArray *)faces;

@end

@interface DPCamera : NSObject
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (weak, nonatomic) id <DPFaceDetectionDelegate> faceDetectionDelegate;

- (id)initCamera;
- (void)startSession;
- (BOOL)switchCameras;
@end
