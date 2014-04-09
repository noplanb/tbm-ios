//
//  NPBViewController.m
//  3byme
//
//  Created by Farhad on 3/10/14.
//  Copyright (c) 2014 No Plan B. All rights reserved.
//

#import "NPBViewController.h"
#import "AFNetworking.h"

@interface NPBViewController ()

typedef NS_ENUM(NSInteger,  NPBRecordingState) {
    NPBRecordingStateInactive,
    NPBRecordingStatePreview,
    NPBRecordingStateRecording,
    NPBRecordingStateSending
};

@property (nonatomic,strong) NPBVideoManager* videoManager;
@property (nonatomic,strong) UIView *activeView;
@property (nonatomic) NPBRecordingState recordingState;
@property (nonatomic,strong) UIView *previewView;
@end

NSString *NPBBaseURL = @"http://192.168.1.2:3000/";

@implementation NPBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupVideoManager];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self startPreview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NBPVideoManagerProtocol

-(void) setupVideoManager
{
    _videoManager = [[NPBVideoManager alloc] init];
    _videoManager.delegate = self;
    _videoManager.previewView = ((NPBMainPanelView *)self.view).previewView;
//    [self.videoManager startPreview:self.videoPreview];
}

-(void) capturedVideo:(NSString *)videoPath
{
    NSLog(@"Captured the video at path %@",videoPath);
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager manager] initWithBaseURL:[NSURL URLWithString:NPBBaseURL]];
    NSDictionary *parameters = @{@"user_id": @"2", @"receiver_id": @"3"};
    NSURL *filePathURL = [NSURL fileURLWithPath:videoPath];
    NSLog(@"Sending file to server");
    [manager POST:@"videos" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:filePathURL name:@"file" fileName:@"video.mp4" mimeType:@"video/mp4" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}

#pragma mark NPBVideoActionProtocol
-(void) toggleCamera:(UIView *)view
{
    [_videoManager toggleCamera];
}

-(void) cancelRecording: (UIView *)view
{
    if ( _recordingState == NPBRecordingStatePreview )
        [_videoManager cancelPreview];
    else if (  _recordingState == NPBRecordingStateRecording )
        [_videoManager cancelRecording];
    _activeView = nil;
    _recordingState = NPBRecordingStateInactive;
    NSLog(@"Canceled Recording");
}

-(void) startPreview
{
    [self.videoManager startPreview:((NPBMainPanelView *)self.view).previewView];
    _recordingState = NPBRecordingStatePreview;
}

// Implemented if we want to have an explicit startRecording event
-(void) startRecording:(UIView *)view
{
    [self.videoManager startRecording];
    _recordingState = NPBRecordingStateRecording;
    [((NPBMainPanelView *)self.view) addRecordingAnnotation];
    NSLog(@"Started Recording");

}

// Implemented if we want to have an explicit stopRecording event
-(void) stopRecording:(UIView *)view
{
    //        I'll wait for the callback from the view manager to change the state to sending
    [self.videoManager stopRecording];
    [((NPBMainPanelView *)self.view) removeRecordingAnnotation];
    NSLog(@"Stopped Recording");
}

// This was used when I was doing a tap-based toggling of the recording state, going from
// inactive to preview to start
-(void) toggleRecording: (UIView *)view
{
    if ( _recordingState == NPBRecordingStateInactive ) {
        _activeView = view;
        _recordingState = NPBRecordingStatePreview;
        return;
    } else if ( _activeView != view ) {
        NSLog(@"OH OH - got an action on a view that is not in active state, so ignoring");
        return;
    }
    
    if ( _recordingState == NPBRecordingStatePreview ) {
        [self startRecording:view];
    } else if ( _recordingState == NPBRecordingStateRecording ) {
        [self stopRecording:view];
    }
    
}

@end
