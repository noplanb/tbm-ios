//
//  NPBVideoFrameView.h
//  3byme
//
//  Created by Farhad on 3/12/14.
//  Copyright (c) 2014 No Plan B. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "NPBVideoActionProtocol.h"

@interface NPBVideoFrameView : UIView
@property (nonatomic,strong) NSString *identifier;
@property (nonatomic,strong) id<NPBVideoActionProtocol> recordingDelegate;

@end
