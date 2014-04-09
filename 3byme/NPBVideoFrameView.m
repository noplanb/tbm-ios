//
//  NPBVideoFrameView.m
//  3byme
//
//  Created by Farhad on 3/12/14.
//  Copyright (c) 2014 No Plan B. All rights reserved.
//

#import "NPBVideoFrameView.h"

@implementation NPBVideoFrameView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
//    self.backgroundColor = [UIColor redColor];
}


@end
