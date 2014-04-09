//
//  NPBVideoActionProtocol.h
//  3byme
//
//  Created by Farhad on 3/12/14.
//  Copyright (c) 2014 No Plan B. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NPBVideoActionProtocol <NSObject>

-(void) startRecording: (UIView *)view;
-(void) stopRecording: (UIView *)view;
-(void) cancelRecording: (UIView *)view;
-(void) sendRecording: (UIView *)view;
-(void) toggleRecording: (UIView *)view;
-(void) toggleCamera: (UIView *)view;

@end
