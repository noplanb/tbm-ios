//
//  NPBMainPanelView.m
//  3byme
//
//  Created by Farhad on 3/12/14.
//  Copyright (c) 2014 No Plan B. All rights reserved.
//

#import "NPBMainPanelView.h"
#import "NPBVideoFrameView.h"

@interface NPBMainPanelView()
@property (nonatomic,strong) UILabel * recordingLabel;
@end

@implementation NPBMainPanelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

NSDictionary *VideoPanelsConfig = nil;


-(void) setupConfig
{
    VideoPanelsConfig = @{
                          @"rows": @3, @"cols": @3,
                          @"viewPadding": @{@"top": @30, @"bottom": @10, @"sides": @2},
                          @"padding": @{ @"x": @5, @"y": @5},
                          @"border": @{@"colorRGB": @[@0,@0,@0], @"thickness": @2},
                          };
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self setupConfig];
    [self setupVideoPanels];
    [self addRecordingLabel];
}

-(void) setupVideoPanels
{
    CGRect bounds = self.bounds;
    float xPadding =[VideoPanelsConfig[@"padding"][@"x"] floatValue];
    float yPadding =[VideoPanelsConfig[@"padding"][@"y"] floatValue];
    float topPadding = [VideoPanelsConfig[@"viewPadding"][@"top"] floatValue];
    float bottomPadding = [VideoPanelsConfig[@"viewPadding"][@"bottom"] floatValue];
    float sidePadding = [VideoPanelsConfig[@"viewPadding"][@"sides"] floatValue];
    
    int panelWidth = (bounds.size.width - sidePadding)/ [VideoPanelsConfig[@"cols"] floatValue];
    int panelHeight = (bounds.size.height - topPadding - bottomPadding)/ [VideoPanelsConfig[@"rows"] floatValue];
    
    int videoFrameWidth = panelWidth - 2 * xPadding;
    int videoFrameHeight = panelHeight - 2 * yPadding;
    //    Now add the views to the main view, and attach the gestures to each
    
    for (int row = 0; row < [VideoPanelsConfig[@"rows"] floatValue]; row++) {
        for (int col = 0; col < [VideoPanelsConfig[@"cols"] floatValue]; col++) {
            NPBVideoFrameView *view = [[NPBVideoFrameView alloc] initWithFrame:CGRectMake(col*panelWidth + xPadding + sidePadding, row*panelHeight + yPadding + topPadding, videoFrameWidth, videoFrameHeight)];
            view.identifier = [NSString stringWithFormat:@"%d.%d",row,col];
            if ( row == 1 && col == 1 ) {
                _previewView = view;
            } else {
                [self addGestureRecognizers:view];
            }
            [self addSubview:view];
            [self drawBorder:view];
        }
    }
}


#pragma mark drawing

-(void) drawViewBorderWithLayer: (UIView *)view withColor: (NSArray *)rgbValues
{
    CALayer *borderLayer = [CALayer layer];
    borderLayer.backgroundColor = [UIColor clearColor].CGColor;
    borderLayer.borderColor = [UIColor colorWithRed: [rgbValues[0] floatValue] green:[rgbValues[1] floatValue] blue:[rgbValues[2] floatValue] alpha:1.0].CGColor;
    borderLayer.borderWidth = [VideoPanelsConfig[@"border"][@"thickness"] floatValue];
    borderLayer.frame = view.bounds;
    [view.layer addSublayer:borderLayer];
}

-(void) drawViewBorderOld: (UIView *)view withColor: (NSArray *)rgbValues
{
    if ( UIGraphicsGetCurrentContext() == nil )
        UIGraphicsBeginImageContext(view.superview.frame.size);
    
    CGContextRef context =  UIGraphicsGetCurrentContext() ;
    UIGraphicsPushContext(context);
    //    CGContextSetRGBFillColor(context, 0.9, 0.9, 0.9, 1.0);
    CGContextSetRGBStrokeColor(context, [rgbValues[0] floatValue],[rgbValues[1] floatValue], [rgbValues[2] floatValue], 1.0);
    float lineThickness = [VideoPanelsConfig[@"border"][@"thickness"] floatValue];
    CGContextSetLineWidth(context, lineThickness);
    //    CGContextFillRect(context, view.frame);
    CGContextStrokeRect(context, CGRectMake(view.frame.origin.x - lineThickness, view.frame.origin.y - lineThickness, view.frame.size.width + 2*lineThickness, view.frame.size.height + 2*lineThickness));
    UIGraphicsPopContext();
}

-(void) drawBorder: (UIView *)view
{
    [self drawViewBorderWithLayer:view withColor: VideoPanelsConfig[@"border"][@"colorRGB"]];
}

-(void) addRecordingLabel
{
    if ( _previewView ) {
        UIView *view = _previewView;
        CGRect labelRect = CGRectMake(0.0, view.frame.size.height-15.0, view.frame.size.width, 15.0);
        UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
        label.text = @"Recording";
        label.textColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14.0];
        label.adjustsFontSizeToFitWidth = YES;
        label.hidden = YES;
        [view addSubview:label];
        _recordingLabel = label;
    }
}

-(void) addRecordingAnnotation
{
    [self drawViewBorderWithLayer:_previewView withColor:@[@1.0,@0.0,@0.0]];
    _recordingLabel.hidden = NO;
}

-(void) removeRecordingAnnotation
{
    [self drawBorder:_previewView];
    _recordingLabel.hidden = YES;

}

#pragma mark - Gestures Support

-(void) addGestureRecognizers: (UIView *)view
{
    //    Long press starts the camera
    //    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(startRecording)];
    //    [self addGestureRecognizer:lpgr];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlePress:)];
    [view addGestureRecognizer:lpgr];
    
//    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//    [view addGestureRecognizer:tgr];
    
    //    Swiping right or left toggles the camera
    UISwipeGestureRecognizer *srgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeSide:)];
    srgr.direction = UISwipeGestureRecognizerDirectionRight;
    [view addGestureRecognizer:srgr];
    
    UISwipeGestureRecognizer *slgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeSide:)];
    slgr.direction = UISwipeGestureRecognizerDirectionLeft;
    [view addGestureRecognizer:slgr];
    
    
    UISwipeGestureRecognizer *sugr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp:)];
    sugr.direction = UISwipeGestureRecognizerDirectionUp;
    [view addGestureRecognizer:sugr];
    
    UISwipeGestureRecognizer *sdgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    sdgr.direction = UISwipeGestureRecognizerDirectionDown;
    [view addGestureRecognizer:sdgr];
    
}

//
-(void) handlePress: (UILongPressGestureRecognizer *)sender
{
    NSLog(@"Recognized long press gesture on %@",((NPBVideoFrameView *)sender.view).identifier);
    if ( sender.state == UIGestureRecognizerStateBegan ){
        if ( [_delegate respondsToSelector:@selector(startRecording:)]) {
            [_delegate startRecording: sender.view];
        }
        
    } else if (sender.state == UIGestureRecognizerStateEnded ) {
        if ( [_delegate respondsToSelector:@selector(startRecording:)]) {
            [_delegate stopRecording: sender.view];
        }
    }
}


-(void) handleTap: (UITapGestureRecognizer *)sender
{
    NSLog(@"Recognized tap gesture on %@",((NPBVideoFrameView *)sender.view).identifier);
    if ( [_delegate respondsToSelector:@selector(toggleRecording:)]) {
        [_delegate toggleRecording: sender.view];
    }
}

-(void) handleSwipeSide: (UISwipeGestureRecognizer *)sender
{
    NSLog(@"Recognized swipe right gesture on %@",((NPBVideoFrameView *)sender.view).identifier);
    if ( [_delegate respondsToSelector:@selector(toggleCamera:)]) {
        [_delegate toggleCamera: sender.view ];
    }
}

-(void) handleSwipeUp: (UISwipeGestureRecognizer *)sender
{
    NSLog(@"Recognized swipe up gesture on %@",((NPBVideoFrameView *)sender.view).identifier);
    if ( [_delegate respondsToSelector:@selector(sendRecording:)]) {
        [_delegate sendRecording: sender.view];
    }
}

-(void) handleSwipeDown: (UISwipeGestureRecognizer *)sender
{
    NSLog(@"Recognized swipe down gesture on %@",((NPBVideoFrameView *)sender.view).identifier);
    if ( [_delegate respondsToSelector:@selector(cancelRecording:)]) {
        [_delegate cancelRecording: sender.view];
    }
}



@end


