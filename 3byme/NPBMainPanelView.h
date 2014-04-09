//
//  NPBMainPanelView.h
//  3byme
//
//  Created by Farhad on 3/12/14.
//  Copyright (c) 2014 No Plan B. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPBVideoActionProtocol.h"

@interface NPBMainPanelView : UIView

-(void) addRecordingAnnotation;
-(void) removeRecordingAnnotation;

@property (nonatomic,strong) IBOutlet id<NPBVideoActionProtocol> delegate;
@property (nonatomic,strong) UIView *previewView;

@end

