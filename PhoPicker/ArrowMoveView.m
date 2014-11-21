//
//  ArrowMoveView.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 9. 6..
//

#import "ArrowMoveView.h"
@interface ArrowMoveView()
- (void) firstAnimation:(UIView*) view;
- (void) secondAnimation:(UIView*) view;
- (void) thirdAnimation:(UIView*) view;
- (void) fourthAnimation:(UIView*) view;
@end
@implementation ArrowMoveView
static const CGFloat offset = 10.0;
static const CGFloat curve = 5.0;

- (UIBezierPath*)bezierPathWithCurvedShadowForRect:(CGRect)rect {
	
	UIBezierPath *path = [UIBezierPath bezierPath];	
	
	CGPoint topLeft		 = rect.origin;
	CGPoint bottomLeft	 = CGPointMake(0.0, CGRectGetHeight(rect) + offset);
	CGPoint bottomMiddle = CGPointMake(CGRectGetWidth(rect)/2, CGRectGetHeight(rect) - curve);	
	CGPoint bottomRight	 = CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect) + offset);
	CGPoint topRight	 = CGPointMake(CGRectGetWidth(rect), 0.0);
	
	[path moveToPoint:topLeft];	
	[path addLineToPoint:bottomLeft];
	[path addQuadCurveToPoint:bottomRight controlPoint:bottomMiddle];
	[path addLineToPoint:topRight];
	[path addLineToPoint:topLeft];
	[path closePath];
	
	return path;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        startPointX = 320 - 70;
        endPointX = 70;
        
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 50)];
        [self firstAnimation:view1];
        [self addSubview:view1];
        [view1 release];

        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 90, 320, 50)];
        [self secondAnimation:view2];
        [self addSubview:view2];
        [view2 release];

        UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 160, 320, 50)];
        [self thirdAnimation:view3];
        [self addSubview:view3];
        [view3 release];

        UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(0, 230, 320, 50)];
        [self addSubview:view4];
        [view4 release];

    }
    return self;
}

- (void) firstAnimation:(UIView*) view {
    CALayer *layer = [CALayer layer];
    CGSize imageSize = [UIImage imageNamed:@"arrow"].size;
    layer.contents = (id) [UIImage imageNamed:@"arrow"].CGImage;
    layer.position = CGPointMake(startPointX, (view.frame.size.height - imageSize.height) /2);
    layer.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
//    layer.transform = CATransform3DMakeRotation(180, 0, 1, 0);
    [view.layer addSublayer:layer];
    
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    moveAnimation.fromValue = [NSNumber numberWithInt:0];
    moveAnimation.toValue = [NSNumber numberWithInt:-180];
    moveAnimation.beginTime = 0.5f;
    moveAnimation.duration = 1.5f;
    moveAnimation.fillMode = kCAFillModeForwards;
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(0)];
    rotateAnimation.beginTime = 2.0f;
    rotateAnimation.duration = 0.5f;
    rotateAnimation.fillMode = kCAFillModeForwards;
    rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *moveBackAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    moveBackAnimation.fromValue = [NSNumber numberWithFloat:-180];
    moveBackAnimation.toValue = [NSNumber numberWithFloat:0];
    moveBackAnimation.beginTime = 2.5f;
    moveBackAnimation.duration = 1.5f;
    moveBackAnimation.removedOnCompletion = NO;
    moveBackAnimation.fillMode = kCAFillModeForwards;
    moveBackAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    CABasicAnimation *rotateBackAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateBackAnimation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(180)];
    rotateBackAnimation.beginTime = 0.0f;
    rotateBackAnimation.duration = 0.5f;
    rotateBackAnimation.fillMode = kCAFillModeForwards;
    rotateBackAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
	animationGroup.duration = 4.0f;
    animationGroup.fillMode = kCAFillModeRemoved;
    animationGroup.repeatCount = HUGE_VAL;
	[animationGroup setAnimations:[NSArray arrayWithObjects:rotateBackAnimation ,moveAnimation, rotateAnimation,moveBackAnimation, nil]];
    [layer addAnimation:animationGroup forKey:@"animationGroup"];
}

- (void) secondAnimation:(UIView*) view {
    NSMutableArray *layerList = [NSMutableArray array];
    
    for (int i = 0; i < 10; i ++) {
        CALayer *layer = [CALayer layer];
        CGSize imageSize = [UIImage imageNamed:@"arrow"].size;
        layer.contents = (id) [UIImage imageNamed:@"arrow"].CGImage;
        layer.position = CGPointMake(20 + i *30, (view.frame.size.height - imageSize.height) /2);
        layer.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
        layer.opacity = 0.3;
        [view.layer addSublayer:layer];
        [layerList addObject:layer];
    }
    
    for (int i =0 ; i <10; i ++ ) {
        CALayer *layer = [layerList objectAtIndex:i];
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        opacityAnimation.beginTime = i * 0.2f;
        opacityAnimation.duration = 0.4f;
        opacityAnimation.autoreverses = YES;
        opacityAnimation.fillMode = kCAFillModeForwards;
        opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.duration = 2.4f;
        animationGroup.fillMode = kCAFillModeRemoved;
        animationGroup.repeatCount = HUGE_VAL;
        [animationGroup setAnimations:[NSArray arrayWithObjects:opacityAnimation, nil]];
        [layer addAnimation:animationGroup forKey:@"animationGroup"];
    }
}

- (void) thirdAnimation:(UIView*) view {
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(1.0, 0.0);
    
    CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
    CGColorRef innerColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
    
    gradient.colors = [NSArray arrayWithObjects:(id)outerColor, 
                       (id)innerColor, nil];
    gradient.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], 
                          [NSNumber numberWithFloat:0.85], nil];
    
    [view.layer addSublayer:gradient];
    gradient.cornerRadius = 20;
    gradient.borderWidth = 0.5f;
    gradient.borderColor = [UIColor darkGrayColor].CGColor;
    gradient.frame = CGRectMake(startPointX, 10, 40, 40);
    
    

    CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    boundsAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, startPointX, 40)];
    boundsAnimation.duration = 1.5f;
    boundsAnimation.fillMode = kCAFillModeForwards;
    boundsAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width/2, 30)];
    moveAnimation.duration = 1.5f;
    moveAnimation.fillMode = kCAFillModeForwards;
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
	animationGroup.duration = 4.0f;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.repeatCount = HUGE_VAL;
	[animationGroup setAnimations:[NSArray arrayWithObjects:boundsAnimation,moveAnimation, nil]];
    [gradient addAnimation:animationGroup forKey:@"animationGroup"];
}

- (void) fourthAnimation:(UIView *)view {
    
}
@end
