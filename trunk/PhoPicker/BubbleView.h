//
//  BubbleView.h
//  PhoPicker
//
//  Created by 백 승필 on 12. 9. 3..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
@interface BubbleView : UIView {
    CMMotionManager *motionManager;
    NSTimer *timer;
    CGFloat rotationX;
    CGFloat rotationY;
    CGFloat rotationZ;
}

- (id)initWithPosition:(CGPoint)position;
@end
