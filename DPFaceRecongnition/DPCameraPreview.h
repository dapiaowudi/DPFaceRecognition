//
//  DPCameraPreview.h
//  DPFaceRecongnition
//
//  Created by dapiao on 16/5/23.
//  Copyright © 2016年 dapiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DPCamera.h"
@interface DPCameraPreview : UIView <DPFaceDetectionDelegate>

@property (strong, nonatomic) AVCaptureSession *session;

@end
