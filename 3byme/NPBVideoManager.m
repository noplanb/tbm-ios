//
//  NPBVideoManager.m
//  3byme
//
//  Created by Farhad on 3/10/14.
//  Copyright (c) 2014 No Plan B. All rights reserved.
//

#import "NPBVideoManager.h"
#import <AssetsLibrary/AssetsLibrary.h>


@implementation NPBVideoManager


//Probably should remove the preview and set this up so previewView is fixed
- (void) startPreview:(UIView *)view
{
    self.previewView = view;
    [self setupVision];
}

-(void) toggleCamera
{
    if ( _vision.cameraDevice == PBJCameraDeviceBack )
        [_vision setCameraDevice: PBJCameraDeviceFront];
    else
        [_vision setCameraDevice: PBJCameraDeviceBack];
}

-(void) startRecording
{
    NSLog(@"Starting to record");
    [_vision startVideoCapture];
}

-(void) stopRecording
{
    NSLog(@"Stopping recording");
    [_vision endVideoCapture];
}

-(BOOL) isRecording
{
    return _vision && _vision.isRecording;
}

#pragma mark PBJVision

- (void) setupVision
{
    //    _longPressGestureRecognizer.enabled = YES;
    
    _vision = [PBJVision sharedInstance];
    _vision.delegate = self;
    _vision.previewLayer.frame = self.previewView.bounds;
    [_vision setCameraMode:PBJCameraModeVideo];
    [_vision setCameraDevice:PBJCameraDeviceBack];
    [_vision setCameraOrientation:PBJCameraOrientationPortrait];
    [_vision setFocusMode:PBJFocusModeAutoFocus];
    
    [self.previewView.layer addSublayer:_vision.previewLayer];
    [_vision startPreview];
}

#pragma mark PBJVisionDelegate

- (void)visionSessionDidStartPreview:(PBJVision *)vision
{
    NSLog(@"Started video preview");
}

- (void)visionSessionDidStopPreview:(PBJVision *)vision
{
    NSLog(@"Stopped video preview");
}

- (void)visionDidStartVideoCapture:(PBJVision *)vision
{
    NSLog(@"Starting to record video");
}

- (void)visionDidPauseVideoCapture:(PBJVision *)vision
{
    NSLog(@"Stopping video recording");
}

- (void)visionDidResumeVideoCapture:(PBJVision *)vision
{
    
}

- (void)vision:(PBJVision *)vision capturedVideo:(NSDictionary *)videoDict error:(NSError *)error
{
    NSString *videoPath = [videoDict  objectForKey:PBJVisionVideoPathKey];
    ALAssetsLibrary* assetLibrary = [[ALAssetsLibrary alloc] init];

    if ( YES ) {
        if ( _delegate && [_delegate respondsToSelector:@selector(capturedVideo:)])
            [_delegate capturedVideo:videoPath];
    } else {
        [assetLibrary writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:videoPath] completionBlock:^(NSURL *assetURL, NSError *error1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Saved!" message: @"Saved to the camera roll."
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
        }];
    }
    
}

@end
