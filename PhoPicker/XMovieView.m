//
//  XMovieView.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 9. 13..
//

#import "XMovieView.h"
#define centerIndex 4
#define centerPosition 100
#define centerGap 80
@interface XMovieView()
- (void) moveLayer:(NSInteger) index duration:(CGFloat) duration;
- (void) startAnimation;
- (void) selectLayer:(NSInteger) index;
- (void) initLayer;
@end

@implementation XMovieView


- (CATransform3D) getTransForm3DIdentity {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = - 1.0f/ 500.0f;
    return transform;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        index = 5;

        self.layer.sublayerTransform = [self getTransForm3DIdentity];
        _layerList = [[NSMutableArray alloc] init];
        UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panRecognizer.minimumNumberOfTouches = 1;
        [self addGestureRecognizer:panRecognizer];
        [panRecognizer release];
        
        UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tapRecognizer];
        [tapRecognizer release];
        
        for (int i =0 ; i < 14 ; i ++) {
            CALayer *layer = [CALayer layer];
            layer.frame = CGRectMake(-self.frame.size.width/2, 0, self.frame.size.width, self.frame.size.height);
            
            layer.contents = (id) [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i]].CGImage;
            layer.transform = [self getTransForm3DIdentity];
            layer.name = [NSString stringWithFormat:@"%d", i];
            layer.borderWidth = 1.0f;
            layer.borderColor = [UIColor grayColor].CGColor;
            [self.layer addSublayer:layer];
            [_layerList addObject:layer];
        }        
        
        [self initLayer];
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor blackColor]];
        [btn setTitle:@"시작" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(150, 10, 60, 30)];
        [btn addTarget:self action:@selector(startAnimation) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    return self;
}

- (void) dealloc {
    [_layerList release];
    [super dealloc];
}

- (void) initLayer {
    for (int i =0 ; i < [_layerList count]; i ++) {
        CALayer *layer = [_layerList objectAtIndex:i];
        layer.transform = [self getTransForm3DIdentity];
        layer.anchorPoint = CGPointMake(0, 0.5);
        if (i == index) {
            continue;
        }
        
        layer.name = [NSString stringWithFormat:@"%d", i];
        layer.transform = CATransform3DScale(layer.transform, 0.6, 0.6, 0.6);
        
        layer.opacity = 0.0f;
        layer.transform = CATransform3DRotate(layer.transform, DEGREES_TO_RADIANS(30), 0, 1, 0); 
        if (i > index) {
            layer.position = CGPointMake( [[UIScreen mainScreen] applicationFrame].size.width + centerPosition + (i - index) * 30 + centerGap, self.center.y);
        } else if ( i < index) {
            layer.position = CGPointMake(- [[UIScreen mainScreen] applicationFrame].size.width + centerPosition - (index - i) * 30 - centerGap, self.center.y);           
        } else {
            layer.position = CGPointMake(centerPosition, self.center.y);
        }

        [layer removeAllAnimations];   
    }
}

- (void) handlePan:(UIPanGestureRecognizer *) recognizer {
    if (!isGestureMode) {
        return;
    }
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *) recognizer;
    CGPoint delta = [pan translationInView:pan.view];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        forePoint = CGPointZero;
    }
    
    if (forePoint.x - delta.x > 15 && index != [_layerList count] -1) {
        index = ++index % [_layerList count];;
    } else if ( forePoint.x - delta.x < - 15 && index != 0) {
        index = --index % [_layerList count];
    } else {
        return;
    }
    
//    [self moveLayer:index duration:0.6];
    int i =0;
    for (CALayer *layer in _layerList) {  
        CABasicAnimation *moveBackXAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        if (i > index) {
            moveBackXAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(centerPosition + (i - index) * 30 + centerGap, layer.position.y)];
        } else if ( i < index) {         
            moveBackXAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(centerPosition - (index - i) * 30 - centerGap, layer.position.y)];
        } else {
            moveBackXAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(centerPosition, layer.position.y)];
        }
        moveBackXAnimation.duration = 0.5f;
        moveBackXAnimation.removedOnCompletion = NO;
        moveBackXAnimation.fillMode = kCAFillModeForwards;
        moveBackXAnimation.delegate = self;
        moveBackXAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [layer addAnimation:moveBackXAnimation forKey:[NSString stringWithFormat:@"moveBackAnimation%d",index]];
        
        i++;
    }
    forePoint = delta;
}

#pragma mark - GestureReconizer
- (void) handleTap:(UITapGestureRecognizer *) recognizer {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *) recognizer;
    CGPoint location = [tap locationInView:tap.view];
    
    if (CGRectContainsPoint(btn.frame, location) && !isGestureMode) {
        [self startAnimation];
        return;
    }
    
    if (!isGestureMode) {
        return;
    }
    CGRect frame = CGRectZero;
    
    for (int i = index - 1; i < index + 5; i++) {
        if (i == [_layerList count] ) {
            return;
        }

        if (i > index) {
            if (index == [_layerList count] -2) {
                frame = CGRectMake(centerGap * 3.1 *cos(DEGREES_TO_RADIANS(30)) + 30 * (i-index - 1) *cos(DEGREES_TO_RADIANS(30)), self.frame.size.height * 0.5 - self.frame.size.height * 0.6 * 0.5, 120 * cos(DEGREES_TO_RADIANS(30)), self.frame.size.height * 0.6);
            } else {
                frame = CGRectMake(centerGap * 3.1 *cos(DEGREES_TO_RADIANS(30)) + 30 * (i-index - 1) *cos(DEGREES_TO_RADIANS(30)), self.frame.size.height * 0.5 - self.frame.size.height * 0.6 * 0.5, 30 * cos(DEGREES_TO_RADIANS(30)), self.frame.size.height * 0.6);
            }
        } else if ( i < index && i != -1) {         
            frame = CGRectMake(0, self.frame.size.height * 0.5 - self.frame.size.height * 0.6 * 0.5, centerGap * 1.5 * cos(DEGREES_TO_RADIANS(30)), self.frame.size.height * 0.6);
        } else if ( i == index) {
            frame = CGRectMake(centerGap * 1.5 * cos(DEGREES_TO_RADIANS(30)), self.frame.size.height * 0.5 - self.frame.size.height * 0.6 * 0.5, centerGap * 1.6 * cos(DEGREES_TO_RADIANS(30)) , self.frame.size.height * 0.6);
        }
        
        if (CGRectContainsPoint(frame, location)) {
            index = i;
            [self selectLayer:i];
            [self initLayer];
            return;
        }
        
    }
}

- (void) selectLayer:(NSInteger) selectIndex {
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1];
    scaleAnimation.beginTime = 0.0f;
    scaleAnimation.duration = 0.8f;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *rotateBackAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotateBackAnimation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(0)];
    rotateBackAnimation.beginTime = 0.0f;
    rotateBackAnimation.duration = 0.5f;
    rotateBackAnimation.removedOnCompletion = NO;
    rotateBackAnimation.fillMode = kCAFillModeForwards;
    rotateBackAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *moveBackXAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveBackXAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0, self.center.y)];
    moveBackXAnimation.beginTime = 0.0f;
    moveBackXAnimation.duration = 0.3f;
    moveBackXAnimation.removedOnCompletion = NO;
    moveBackXAnimation.fillMode = kCAFillModeForwards;
    moveBackXAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
	animationGroup.duration = 0.8f;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.delegate = self;
    [animationGroup setValue:@"selectAnimation" forKey:@"AnimationGroup"];
	[animationGroup setAnimations:[NSArray arrayWithObjects:scaleAnimation, rotateBackAnimation, moveBackXAnimation, nil]];
    [[_layerList objectAtIndex:selectIndex] addAnimation:animationGroup forKey:@"animationGroup"];
}

- (void) startAnimation {
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.6];
    scaleAnimation.beginTime = 0.3f;
    scaleAnimation.duration = 0.5f;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *rotateBackAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotateBackAnimation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(30)];
    rotateBackAnimation.beginTime = 0.0f;
    rotateBackAnimation.duration = 0.5f;
    rotateBackAnimation.removedOnCompletion = NO;
    rotateBackAnimation.fillMode = kCAFillModeForwards;
    rotateBackAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    CABasicAnimation *moveBackXAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveBackXAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(centerPosition, self.center.y)];
    moveBackXAnimation.beginTime = 0.3f;
    moveBackXAnimation.duration = 0.5f;
    moveBackXAnimation.removedOnCompletion = NO;
    moveBackXAnimation.fillMode = kCAFillModeForwards;
    moveBackXAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
	animationGroup.duration = 0.8f;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.delegate = self;
    [animationGroup setValue:@"animationFirst" forKey:@"AnimationGroup"];
	[animationGroup setAnimations:[NSArray arrayWithObjects:scaleAnimation, rotateBackAnimation,moveBackXAnimation, nil]];
    [[_layerList objectAtIndex:index] addAnimation:animationGroup forKey:@"animationGroup"];
    
    for (int i = 0 ; i < [_layerList count] ; i ++) {
        CALayer *layer = [_layerList objectAtIndex:i];

        if (i != index) {
              layer.opacity = 1.0;
        } 
    }
    
    [self performSelector:@selector(moveLayerNumber:) withObject:[NSNumber numberWithInt:index] afterDelay:0.3f];

}

- (void) movePositionInTransaction:(CALayer *)layer location:(CGPoint)location duration:(CGFloat) duration {
    [CATransaction setValue:[NSNumber numberWithFloat:duration] forKey:kCATransactionAnimationDuration];
    layer.position = CGPointMake(location.x, location.y);
    [CATransaction setValue:[NSNumber numberWithFloat:0.25] forKey:kCATransactionAnimationDuration];
}

- (void) moveLayerNumber:(NSNumber*) indexNumber {
    [self moveLayer:[indexNumber intValue] duration:0.5];
}

- (void) moveLayer:(NSInteger) moveIndex duration:(CGFloat)duration {
    int i =0;
    for (CALayer *layer in _layerList) {  
        CABasicAnimation *moveBackXAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        if (i > index) {
            moveBackXAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(centerPosition + (i - index) * 30 + centerGap, layer.position.y)];
        } else if ( i < index) {         
            moveBackXAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(centerPosition - (index - i) * 30 - centerGap, layer.position.y)];
        } else {
            moveBackXAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(centerPosition, layer.position.y)];
        }
        moveBackXAnimation.duration = duration;
        moveBackXAnimation.removedOnCompletion = NO;
        moveBackXAnimation.fillMode = kCAFillModeForwards;
        moveBackXAnimation.delegate = self;
        moveBackXAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [layer addAnimation:moveBackXAnimation forKey:@"moveBackAnimation"];
        
        i++;
    }
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *value = [anim valueForKey:@"AnimationGroup"];
    if ([value isEqualToString:@"selectAnimation"]) {
        [CATransaction setDisableActions:YES];
        [[_layerList objectAtIndex:index] setPosition:CGPointMake(0, self.center.y)];
        [CATransaction setDisableActions:NO];
        [[_layerList objectAtIndex:index] removeAllAnimations];
        isGestureMode = NO;
    } else if ([value isEqualToString:@"animationFirst"]) {
        CALayer *layer = [_layerList objectAtIndex:index];
        [CATransaction setDisableActions:YES];
        layer.transform = [self getTransForm3DIdentity];
        layer.transform = CATransform3DScale(layer.transform, 0.6, 0.6, 0.6);
        layer.transform = CATransform3DRotate(layer.transform, DEGREES_TO_RADIANS(30), 0, 1, 0); 
        [layer setPosition:CGPointMake(centerPosition, self.center.y)];
        [CATransaction setDisableActions:NO];
        [layer removeAllAnimations];
        isGestureMode = YES;
        
    }
}

@end
