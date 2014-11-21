//
//  BubbleView.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 9. 3..
//

#import "BubbleView.h"

@implementation BubbleView

- (id)initWithPosition:(CGPoint)position {
    self = [super init];
    if (self) {
        NSInteger size = arc4random()%100 + 10;
        
        CAShapeLayer *circle = [CAShapeLayer layer];
        circle.lineWidth = 2.0;
        circle.strokeColor = [UIColor colorWithRed:(arc4random()%255)/255.0f green:(arc4random()%255)/255.0f blue:(arc4random()%255)/255.0f alpha:1.0].CGColor;
        [self.layer addSublayer:circle];
        circle.bounds = CGRectMake(0, 0, size, size);
        circle.position = position;
        CGMutablePathRef p = CGPathCreateMutable();
        CGPathAddEllipseInRect(p, NULL, CGRectInset(circle.bounds, 0, 0));
        circle.path = p;
        
        
        motionManager = [[CMMotionManager alloc] init];
        [motionManager startGyroUpdates];
        
//		timer = [NSTimer scheduledTimerWithTimeInterval:1/2
//												 target:self 
//											   selector:@selector(doGyroUpdate)
//											   userInfo:nil 
//												repeats:YES];
    }
    return  self;
}


-(void)doGyroUpdate {
	float rate = motionManager.gyroData.rotationRate.x;
	if (fabs(rate) > .2) {
		float direction = rate > 0 ? 1 : -1;
        rotationX += direction * M_PI/90.0;
//        NSLog(@"rotation : %f", rotation);

        
//        CABasicAnimation *dropAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
//        dropAnimation.toValue = [NSNumber numberWithFloat:self.frame.size.height - position.y - size];
//        dropAnimation.duration = arc4random()%5 + 1;
//        dropAnimation.removedOnCompletion = NO;
//        dropAnimation.fillMode = kCAFillModeForwards;
//        dropAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//        [self.layer addAnimation:dropAnimation forKey:@"dropAnimation"];
	}
    rate = motionManager.gyroData.rotationRate.y;
    if (fabs(rate) > .2) {
		float direction = rate > 0 ? 1 : -1;
        rotationY += direction * M_PI/90.0;
    }
    rate = motionManager.gyroData.rotationRate.z;
    if (fabs(rate) > .2) {
		float direction = rate > 0 ? 1 : -1;
        rotationZ += direction * M_PI/90.0;
    }
    NSLog(@"x : %f y : %f z : %f", rotationX , rotationY , rotationZ);
}

- (void) dealloc {
    [motionManager stopGyroUpdates];
    [timer invalidate];
    [motionManager release];
    [super dealloc];
}


@end
