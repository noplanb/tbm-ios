//
//  NPBVideoManager.h
//  3byme
//
//  Created by Farhad on 3/10/14.
//  Copyright (c) 2014 No Plan B. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBJVision.h"

@protocol NPBVideoManagerProtocol <NSObject>

-(void) capturedVideo: (NSString *)videoPath;

@end

@interface NPBVideoManager : NSObject <PBJVisionDelegate>

@property (nonatomic,strong) PBJVision *vision;
@property (nonatomic,strong)  UIView  *previewView;
@property (nonatomic,strong) id<NPBVideoManagerProtocol> delegate;

-(void) startPreview: (UIView *)view;
-(void) cancelPreview;
-(void) toggleCamera;
-(void) startRecording;
-(void) stopRecording;
-(void) cancelRecording;
-(BOOL)isRecording;

@end

