//
//  XMovieUpView.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 9. 19..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import "XMovieUpView.h"
#define zGap 310
#define centerPosition 100
#define centerGap 80
#define layerGap 80
#define initX 10
#define initDegree 40
#define twistedRate 0.5

@interface XMovieUpView()
- (void) initLayer;
- (void) checkSelectedLayer;
- (void) moveAnimation:(NSInteger) moveStep duration:(CGFloat) duration;
@end
@implementation XMovieUpView
@synthesize startIndex = _startIndex;
- (CATransform3D) getTransForm3DIdentity {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = - 1.0f/ 1000.0f;
    return transform;
}


- (CATransform3D) initLayerTransform{
    CATransform3D transform = [self getTransForm3DIdentity];
    transform = CATransform3DScale(transform, 0.4, 0.4, 0.4);
    transform = CATransform3DRotate(transform, DEGREES_TO_RADIANS(-24), 0, 1, 0);
    transform = CATransform3DRotate(transform, DEGREES_TO_RADIANS(-18), 1, 0, 0);
    transform = CATransform3DRotate(transform, DEGREES_TO_RADIANS(5), 0, 0, 1);
    return transform;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _startIndex = 0;
        twistIndex = HUGE_VAL;
        self.layer.sublayerTransform = [self getTransForm3DIdentity];
        self.backgroundColor = [UIColor clearColor];
        _layerList = [[NSMutableArray alloc] init];
        _viewList = [[NSMutableArray alloc] init];
        UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panRecognizer.minimumNumberOfTouches = 1;
        [self addGestureRecognizer:panRecognizer];
        [panRecognizer release];
        
        isAnimating = NO;
        descLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 20, 20)];
        descLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:descLabel];
        [descLabel release];
        initY = self.frame.size.height - 80;
        UIImage *cardImage = [UIImage imageNamed:@"card"];
        for (int i =0 ; i < 14 ; i ++) {
            UIButton *layerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:layerBtn];
//            [self insertSubview:layerBtn atIndex:0];
            [layerBtn addTarget:self action:@selector(btnSelect:) forControlEvents:UIControlEventTouchUpInside];
            CALayer *layer = [layerBtn layer];
            layer.name = [NSString stringWithFormat:@"%d", i];
            layer.frame = CGRectMake(-self.frame.size.width/2, 0, cardImage.size.width, cardImage.size.height);
            layer.transform = [self getTransForm3DIdentity]; 

            
            CGRect imageRect = CGRectMake( 0 , 0 , cardImage.size.width +1 , cardImage.size.height+1 );
            UIGraphicsBeginImageContext( imageRect.size );
            [cardImage drawInRect:CGRectMake( imageRect.origin.x +1 , imageRect.origin.y +1 , imageRect.size.width -2 , imageRect.size.height -2 ) ];
            CGContextSetInterpolationQuality( UIGraphicsGetCurrentContext() , kCGInterpolationHigh );
            cardImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            layer.contents = (id) cardImage.CGImage;
            
            layer.shouldRasterize = YES;
            layer.rasterizationScale = 0.55;
            layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
            layer.masksToBounds = NO;
            
            [self.layer insertSublayer:layer atIndex:0];

            [_layerList addObject:layer];
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] scale] > 1) {
                CALayer *reflectionLayer = [CALayer layer];
                reflectionLayer.contents = layer.contents;
                reflectionLayer.bounds = layer.bounds;
                reflectionLayer.position = CGPointMake(layer.position.x + 160, layer.position.y + 360);
                reflectionLayer.borderColor = layer.borderColor;
                reflectionLayer.borderWidth = layer.borderWidth;
                reflectionLayer.opacity = 0.5;
                // Transform X by 180 degrees
                [reflectionLayer setValue:[NSNumber numberWithFloat:DEGREES_TO_RADIANS(180)] forKeyPath:@"transform.rotation.x"];
                [layer addSublayer:reflectionLayer];
                
                CAGradientLayer *gradientLayer = [CAGradientLayer layer];
                gradientLayer.bounds = reflectionLayer.bounds;
                gradientLayer.position = CGPointMake(reflectionLayer.bounds.size.width / 2, reflectionLayer.bounds.size.height * 0.65);
                gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor],(id)[[UIColor whiteColor] CGColor], nil];
                gradientLayer.startPoint = CGPointMake(0.5, 0.0);
                gradientLayer.endPoint = CGPointMake(0.5, 1.0);
                
                // Add gradient layer as a mask
                reflectionLayer.mask = gradientLayer;
            }
        }        
        [self initLayer];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(0, 0, 50, 50);
        closeBtn.backgroundColor = [UIColor clearColor];
        [closeBtn addTarget:nil action:@selector(actionClose) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        
        
        [self performSelector:@selector(beginingAnimation) withObject:nil afterDelay:0.0f];
    }
    
    return self;
}




- (void) dealloc {
    [_layerList release];
    [_viewList release];
    [super dealloc];
}

- (void) setStartIndex:(NSInteger)startIndex {
    if (startIndex >= [_layerList count]) {
        _startIndex = [_layerList count] -1;
    } else {
        _startIndex = startIndex;
    }
    [self checkSelectedLayer];
}

- (void) beginingAnimation {
    NSInteger step = _startIndex - 1;
    if (_startIndex > [_layerList count] - 2) {
        _startIndex = [_layerList count] - 1;
        step = [_layerList count] - 2;
    }
    
    [self moveAnimation:step duration:1.0f];
}

- (void) checkSelectedLayer {
    [checkLayer removeFromSuperlayer];

    checkLayer = [CALayer layer];
    checkLayer.contents = (id) [UIImage imageNamed:@"ic_check"].CGImage;        

    CALayer *layer = [_layerList objectAtIndex:_startIndex];
    [layer addSublayer:checkLayer];
    checkLayer.position = CGPointMake(10, -30);
    checkLayer.bounds = CGRectMake(0, 0, 40, 40);
}

- (void) btnSelect:(id) control {
    NSInteger index = [[[control layer] name] intValue];
    if (index + (_startIndex - 1) >= [_layerList count]) {
        return;
    }
    index = (index + (_startIndex -1) ) % [_layerList count];
    descLabel.text = [NSString stringWithFormat:@"%d", index];
}

- (void) initLayer {

    for (int i =0 ; i < [_layerList count]; i ++) {
        CALayer *layer = [_layerList objectAtIndex:i];
        layer.transform = [self initLayerTransform];
        layer.anchorPoint = CGPointMake(0, 0);
        layer.anchorPointZ = -500;
        layer.name = [NSString stringWithFormat:@"%d", i];
        layer.position = CGPointMake(self.center.x - i * i *  twistedRate, self.center.y /2 - 50);
        layer.transform = CATransform3DTranslate(layer.transform, 0, 0, -(i -1) * zGap);
    }
}

- (void) moveAnimation:(NSInteger) moveStep duration:(CGFloat) duration {
    isAnimating = YES;
    int i =0;
    
    for (CALayer *layer in _layerList) {  
        
        CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        moveAnimation.fromValue = [NSValue valueWithCGPoint:[(CALayer*)[layer presentationLayer] position]];
        moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x - pow(i - _startIndex, 2) * twistedRate, self.center.y /2 - 50)];
        moveAnimation.duration = duration;
        moveAnimation.removedOnCompletion = NO;
        moveAnimation.fillMode = kCAFillModeForwards;
        moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];        
        
        CABasicAnimation *moveBackXAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        moveBackXAnimation.fromValue = [NSValue valueWithCATransform3D:[(CALayer*)[layer presentationLayer] transform]];
        moveBackXAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DTranslate([(CALayer*)[layer presentationLayer] transform],0, 0, moveStep * zGap)];
        moveBackXAnimation.duration = duration;
        moveBackXAnimation.removedOnCompletion = NO;
        moveBackXAnimation.fillMode = kCAFillModeForwards;
        moveBackXAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.duration = duration;
        animationGroup.removedOnCompletion = NO;
        animationGroup.fillMode = kCAFillModeForwards;
        animationGroup.delegate = self;
        [animationGroup setValue:[NSString stringWithFormat:@"moving%d",i] forKey:@"animation"];
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [animationGroup setAnimations:[NSArray arrayWithObjects:moveAnimation,moveBackXAnimation, nil]];
        [layer addAnimation:animationGroup forKey:@"animationGroup"];
        i++;
    }
}


- (void) handlePan:(UIPanGestureRecognizer *) recognizer {

    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *) recognizer;
    CGFloat duration = 0.4f;
    CGFloat movingThresholdWidth = 10;
    CGPoint velocity = [pan velocityInView:pan.view];
    CGPoint delta = CGPointMake(velocity.x * 0.5, velocity.y * 0.5);    

    CGPoint direction = [pan translationInView:pan.view];
    
    CGFloat deltaX = 0;
    CGFloat deltaY = 0;

    NSInteger step = 0;
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        forePoint = CGPointZero;
        foreDirection = CGPointZero;
        return;
    } else if (pan.state == UIGestureRecognizerStateChanged) {
//        deltaX = forePoint.x - delta.x;
//        deltaY = forePoint.y - delta.y;
//        movingThresholdWidth = 100;
        deltaX = foreDirection.x - direction.x;
        deltaY = foreDirection.y - direction.y;
        movingThresholdWidth = 12;
//        NSLog(@"forePoint : %@ delatPoint : %@", NSStringFromCGPoint(forePoint), NSStringFromCGPoint(delta));
        CGFloat hypotenuse = sqrt(deltaX * deltaX + deltaY * deltaY);
        step = hypotenuse / movingThresholdWidth;  
//        NSLog(@"hypotenuse : %f step: %d movingThresholdWidth:%f", hypotenuse, step, movingThresholdWidth);        
        if (step == 0) {
            step = 1;
            duration = 0.4f;
        } else if (step > 5){
            duration = 0.8f;
        } else if (step > 1) {
            duration = 0.4f;
        }
    } else if (pan.state >= UIGestureRecognizerStateEnded) {
        return;
    }
    NSInteger movingIndex = _startIndex;
    
//    NSLog(@"deltaX : %f deltaY : %f", deltaX, deltaY);
    
//    NSLog(@"step : %d",step);

    if (step > 0) {
        if ((foreDirection.x - direction.x) * (foreDirection.y - direction.y) < 0) {
            if ((foreDirection.x - direction.x) > 0 && _startIndex != [_layerList count] -1) {
                if (_startIndex + step > [_layerList count] -1) {
                    step = ([_layerList count] - 1) - _startIndex;
                }
                movingIndex = (_startIndex + step) % [_layerList count];
            } else if ((foreDirection.x - direction.x) < 0 && _startIndex != 0) {
                if (_startIndex - step < 0) {
                    step = _startIndex;
                }
                movingIndex = (_startIndex - step) % [_layerList count];
                step *= -1;
            }
        } 
    } 
//    NSLog(@"forePoint : %@ delatPoint : %@", NSStringFromCGPoint(forePoint), NSStringFromCGPoint(delta));
    forePoint = delta;
    foreDirection = direction; 
    if (movingIndex == _startIndex || movingIndex < 0 || movingIndex > [_layerList count]-1) {
        return;
    } 
    if (isAnimating) {
        return;
    }

//    NSLog(@"startIndex : %d  movingIndex : %d step:%d", _startIndex, movingIndex, step);

    _startIndex = movingIndex; 
    [self moveAnimation:step duration:duration];
    
    
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *value = [anim valueForKey:@"animation"];
    if ([value isEqualToString:[NSString stringWithFormat:@"moving%d",([_layerList count]-1)]]) {
        isAnimating = NO;
//        [self checkSelectedLayer];
    } 
}

@end
