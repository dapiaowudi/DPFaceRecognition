//
//  DPCamera.m
//  DPFaceRecongnition
//
//  Created by dapiao on 16/5/23.
//  Copyright © 2016年 dapiao. All rights reserved.
//

#import "DPCamera.h"

@interface DPCamera () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureDevice               *videoDevice;
@property (nonatomic, weak  ) AVCaptureDeviceInput          *activeVideoInput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer    *previewLayer;
@property (strong, nonatomic) AVCaptureMetadataOutput       *metadataOutput;
@end

@implementation DPCamera
- (id)initCamera {
    
    self = [super init];
    
    if (self) {
        
        NSError *error;
        self.captureSession = [[AVCaptureSession alloc] init];
        self.captureSession.sessionPreset = AVCaptureSessionPresetiFrame960x540;
        self.videoDevice =  [self inactiveCamera];//[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *videoIn = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:&error];
        if ([self.captureSession canAddInput:videoIn]) {
            [self.captureSession addInput:videoIn];
            self.activeVideoInput = videoIn;
        } else {
            return nil;
        }
        self.metadataOutput = [[AVCaptureMetadataOutput alloc] init];
        
        if ([self.captureSession canAddOutput:self.metadataOutput]) {
            [self.captureSession addOutput:self.metadataOutput];
            
            NSArray *metadataObjectTypes = @[AVMetadataObjectTypeFace];
            self.metadataOutput.metadataObjectTypes = metadataObjectTypes;
            
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            [self.metadataOutput setMetadataObjectsDelegate:self
                                                      queue:mainQueue];
            
            
        }
    }
    return self;
}
- (void)startSession {
    if (![self.captureSession isRunning]) {

        [self.captureSession startRunning];
    }
}
#pragma mark - Device Configuration

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *)activeCamera {
    return self.activeVideoInput.device;
}

- (AVCaptureDevice *)inactiveCamera {
    AVCaptureDevice *device = nil;
    if (self.cameraCount > 1) {
        if ([self activeCamera].position == AVCaptureDevicePositionBack) {
            device = [self cameraWithPosition:AVCaptureDevicePositionFront];
        } else {
            device = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }
    }
    return device;
}

- (BOOL)canSwitchCameras {
    return self.cameraCount > 1;
}

- (NSUInteger)cameraCount {
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
}

- (BOOL)switchCameras {
    
    if (![self canSwitchCameras]) {
        return NO;
    }
    
    NSError *error;
    AVCaptureDevice *videoDevice = [self inactiveCamera];
    
    AVCaptureDeviceInput *videoInput =
    [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    
    if (videoInput) {
        [self.captureSession beginConfiguration];
        
        [self.captureSession removeInput:self.activeVideoInput];
        
        if ([self.captureSession canAddInput:videoInput]) {
            [self.captureSession addInput:videoInput];
            self.activeVideoInput = videoInput;
        } else {
            [self.captureSession addInput:self.activeVideoInput];
        }
        
        [self.captureSession commitConfiguration];
        
    }
    
    return YES;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection {
    
    for (AVMetadataFaceObject *face in metadataObjects) {
        NSLog(@"Face detected with ID: %li", (long)face.faceID);
        NSLog(@"Face bounds: %@", NSStringFromCGRect(face.bounds));
    }
    
    [self.faceDetectionDelegate didDetectFaces:metadataObjects];            
    
}
@end
