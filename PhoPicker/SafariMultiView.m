//
//  SafariMultiView.m
//  PhoPicker
//
//  Created by 승필 백 on 13. 6. 11..
//

#import "SafariMultiView.h"
#define routeRadious 100.0f
@implementation SafariMultiView

#define zGap 120.0f
#define a zGap
#define b zGap * 0.5
#define rotateVariable 50
#define scaleDegree 0.005
CGFloat getYEllipsePoint(CGFloat xPoint) {
    return b /a * sqrtf(powf(a, 2) - powf(xPoint, 2)) - b;
}

- (CGFloat) layerGap {
    return ([_layerList count] > 3) ? self.bounds.size.height / 3.0f: self.bounds.size.height / (float)([_layerList count] + 1);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _layerList = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor blackColor];
        UIPanGestureRecognizer *gestureRecognize = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:gestureRecognize];
        [gestureRecognize release];
        _rotateAngle = 360.0 / 8.0f;
        _currentIndex = 0;
        _maxCount = 8;
        for (int i = 0; i < _maxCount; i ++) {
            CALayer *layer = [CALayer layer];
            layer.transform = [self getInitialTransform];
            layer.contents = (id)[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]].CGImage;
            layer.name = [NSString stringWithFormat:@"%d", i];
            layer.anchorPoint = CGPointMake(0.5, 0);
            layer.bounds = self.bounds;
//            view.layer.transform = CATransform3DTranslate(view.layer.transform, 0, -getYEllipsePoint(-(i+ 1) * zGap * 0.1), -i * zGap);
//            view.layer.transform = CATransform3DTranslate(view.layer.transform, 0, 0, -i * zGap);
//            view.layer.anchorPointZ = 500;
            [self.layer addSublayer:layer];

//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
//            label.text = [NSString stringWithFormat:@"%d", i];
//            label.font = [UIFont systemFontOfSize:30.0f];
//            
//            [layer addSublayer:label.layer];
//            [label release];
            
            [_layerList addObject:layer];
        }
        
        [self adjustLayerPosition];
        CALayer *firstLayer = [_layerList objectAtIndex:0];
        _firstPositionY = firstLayer.position.y;
        _finalPositionY = [[_layerList lastObject] position].y;
        
        
//        UIView *dimmedView = [[UIView alloc] initWithFrame:self.bounds];
//        dimmedView.backgroundColor = [UIColor blackColor];
//        dimmedView.alpha = 0.6;
//        [self addSubview:dimmedView];
//        [dimmedView release];
    }
    return self;
}

- (CGFloat) calculateInitiailRotateDegree:(CGPoint) position {
    return  rotateVariable / [self layerGap] * pow((9 - [_layerList count]), 2);
}

- (CGFloat) calculateScaleDegree:(CGPoint) position {
//    NSLog(@"postion y :%f  scale : %f", position.y , 1.0f/ 10000.0f * (position.y - 100.0f) + 1);
    return  - 0.001f* (position.y - 100.0f);
}

- (void) adjustLayerListWithIndex:(NSInteger) index {
    
    CGPoint lastPosition = [[_layerList objectAtIndex:0] position];

    if ([_layerList count] < 4) {
        [self adjustLayerPosition];
    }
    
    int i = 0;
    for (CALayer *layer in _layerList) {
        if (i <index) {
            i++;
//            CGFloat scale = [self calculateInitiailScaleDegree:view.layer.position];
//            view.layer.transform = CATransform3DScale([self getInitialTransform], scale, scale, scale);
            layer.transform = CATransform3DRotate([self getInitialTransform], DEGREES_TO_RADIANS([self calculateInitiailRotateDegree:layer.position]), 1, 0, 0);
            lastPosition = CGPointMake(self.center.x, layer.position.y - [self layerGap]);
            continue;
        }
        layer.position = lastPosition;
//        CGFloat scale = [self calculateInitiailScaleDegree:view.layer.position];
//        view.layer.transform = CATransform3DScale([self getInitialTransform], scale, scale, scale);
        layer.transform = CATransform3DRotate([self getInitialTransform], DEGREES_TO_RADIANS([self calculateInitiailRotateDegree:layer.position]), 1, 0, 0);

        NSLog(@"index : %d angle : %f layer gap : %f",i++, RADIANS_TO_DEGREE([[layer  valueForKeyPath:@"transform.rotation.x"] floatValue]), [self layerGap]);
        lastPosition = CGPointMake(self.center.x, layer.position.y - [self layerGap]);
    }
}

- (CATransform3D) getInitialTransform {
    CATransform3D transform = CATransform3DMakePerspective(2000);
    transform = CATransform3DScale(transform, 0.9, 0.9, 0.9);
    transform = CATransform3DRotate(transform, DEGREES_TO_RADIANS(-60.0f), 1, 0, 0);
    return transform;
}

- (void) adjustLayerPosition {
    if ([_layerList count] < 4) {
        for (int i =0; i < [_layerList count]; i++) {
            CALayer *layer = [_layerList objectAtIndex:i];
            layer.transform = CATransform3DRotate([self getInitialTransform], DEGREES_TO_RADIANS([self calculateInitiailRotateDegree:layer.position]), 1, 0, 0);
            layer.frame = (CGRect){CGPointMake(0, self.bounds.size.height - layer.frame.size.height - [self layerGap] * i) , layer.bounds.size};
        }
        return;
    }
    
    if (CGRectGetMaxY([[_layerList objectAtIndex:0] frame]) < self.bounds.size.height) {
        for (int i = 0; i <[_layerList count]; i++) {
            CALayer *layer = [_layerList objectAtIndex:i];
            
            layer.transform = CATransform3DRotate([self getInitialTransform], DEGREES_TO_RADIANS([self calculateInitiailRotateDegree:layer.position]), 1, 0, 0);
            layer.frame = (CGRect){CGPointMake(0, self.bounds.size.height - layer.frame.size.height - [self layerGap] * i) , layer.bounds.size};
            NSLog(@"view.frame : %@ index : %d cal : %f", NSStringFromCGRect(layer.frame), i, self.bounds.size.height - [self layerGap] * i);
        }
    } else if(CGRectGetMinY([[_layerList lastObject] frame]) > 0){
        for (int i= [_layerList count] - 1; i >= 0; i --) {
            CALayer *layer = [_layerList objectAtIndex:i];
            layer.frame = (CGRect) {CGPointMake(0, [self layerGap] * ([_layerList count] - i -1)), layer.bounds.size};
            layer.transform = CATransform3DRotate([self getInitialTransform], DEGREES_TO_RADIANS([self calculateInitiailRotateDegree:layer.position]), 1, 0, 0);
            NSLog(@"view.frame : %@ index : %d  cal : %f", NSStringFromCGRect(layer.frame), i, [self layerGap] * ([_layerList count] - i +1));
        }
    }
}

//- (void) adjustLayerList {
//    CGFloat lastYPostion = 0.0f;
//    if (CGRectGetMaxX([[_viewList objectAtIndex:0] frame]) > self.bounds.size.height) {
//        for (int i = 0; i <[_viewList count]; i++) {
//            UIView *view = [_viewList objectAtIndex:i];
//            view.layer.transform = CATransform3DRotate([self getInitialTransform], DEGREES_TO_RADIANS([self calculateInitiailRotateDegree:view.layer.position]), 1, 0, 0);
//            
//            
//        }
//    } else if (CGRectGetMinY([[_viewList lastObject] frame]) < 0) {
//        
//    }
//}

- (void) dealloc {
    [_layerList release];
    [super dealloc];
}

- (CALayer *) layerInLocation:(CGPoint) location {
    for (CALayer *layer in _layerList) {
        if (CGRectContainsPoint(layer.frame, location)) {
            return layer;
        }
    }
    return nil;
}

- (void) removeViewInList:(CALayer*) layer {
    
    NSInteger deletedIndex = [_layerList indexOfObject:layer];
    [_layerList removeObject:layer];
    if (layer.position.x - self.center.x > 0) {
        layer.position = CGPointMake(self.bounds.size.width * 2, layer.position.y);
    } else {
        layer.position = CGPointMake(- self.bounds.size.width, layer.position.y);
    }
    [self adjustLayerListWithIndex:deletedIndex];
    [layer performSelector:@selector(removeFromSuperlayer) withObject:nil afterDelay:0.3];
}

- (void) handlePan:(UIPanGestureRecognizer *) recognizer {
    CGPoint delta = [recognizer translationInView:recognizer.view];
    CGPoint velocity = [recognizer velocityInView:recognizer.view];

    
    CGFloat deltaX =  delta.x - _beforePoint.x;
    CGFloat deltaY =  (delta.y - _beforePoint.y) * 1;
    [CATransaction setDisableActions:NO];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _beforePoint = delta;
        _touchedLayer = nil;
        if (fabs(deltaX) > fabs(deltaY)) {
            isMovingWidth = YES;
        } else {
            isMovingWidth = NO;
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        [CATransaction setDisableActions:YES];
        if (isMovingWidth) {
            if (_touchedLayer == nil) {
                _touchedLayer = [self layerInLocation:[recognizer locationInView:recognizer.view]];
            }
            _touchedLayer.position = CGPointMake(_touchedLayer.position.x + deltaX, _touchedLayer.position.y);
            if (_touchedLayer.position.x < self.center.x) {
                deltaX *= -1;
            }
            NSInteger index = [_layerList indexOfObject:_touchedLayer];
            if ([_layerList count] > 5) {
                for (int i = 0; i < [_layerList count]; i++) {
                    if (i <= index) {
                        continue;
                    }                
                    CALayer *layer = [_layerList objectAtIndex:i];
                    layer.position = CGPointMake(self.center.x, layer.position.y + (deltaX / self.bounds.size.width * [self layerGap]));
                }
            } else {
                
            }
            
            
        } else {
//            NSLog(@"deltaY : %f", deltaY);
            CALayer *firstLayer = [_layerList objectAtIndex:0];
            CALayer *lastLayer = [_layerList lastObject];
            int i = 0;
            
            for (CALayer *layer in _layerList) {
                if (CGRectGetMaxY(firstLayer.frame) < self.bounds.size.height && deltaY < 0) {
                    layer.position = CGPointMake(layer.position.x, layer.position.y + deltaY / ((i++ + 2) * 1.2));
                } else if (CGRectGetMinY(lastLayer.frame) > 0 && deltaY > 0) {
                    layer.position = CGPointMake(layer.position.x, layer.position.y + deltaY / ([_layerList count] + 3 - (i++ * 1.2) ));
                } else {
                    layer.position = CGPointMake(layer.position.x, layer.position.y + deltaY);
                    
                }
//                view.transform = CGAffineTransformScale(view.transform, scale, scale);
                layer.transform = CATransform3DRotate(layer.transform, DEGREES_TO_RADIANS( -deltaY * 0.03), 1, 0, 0);
                
//                if (view.layer.position.y < 50) {
//                    CGFloat degree = [self calculateScaleDegree:view.layer.position];
//                    CGFloat curScale = [[[view.layer presentationLayer] valueForKeyPath:@"transform.scale"] floatValue];
//                    NSLog(@"degree : %f", degree);
//                    NSLog(@"curScale : %f", curScale);
//                    if (deltaY < 0) {
//                        view.layer.transform = CATransform3DScale(view.layer.transform, 1 - degree, 1 - degree, 1 - degree);
//                    } else {
//                        if (curScale * (1 + degree) > 0.9f) {
//                            view.layer.transform = CATransform3DScale(view.layer.transform, 0.9 / curScale, 0.9 / curScale, 0.9 / curScale);
//                        } else {
//                            view.layer.transform = CATransform3DScale(view.layer.transform, 1 + degree, 1 + degree, 1 + degree);
//                        }
//                    }
//                } 
                
//                if (zPosition > - 700) {
//                    [layer addAnimation:[self transformAnimation:0.15 toValue:CATransform3DTranslate(layer.transform, 0, 0  , deltaY ) layer:layer] forKey:@"transform"];
//                    layer.transform = CATransform3DTranslate(layer.transform, 0, 0 , deltaY );
                
                    
                    
//                } else {
//                    CABasicAnimation *scaleAnimation = [self transformAnimation:0.15 toValue:CATransform3DScale(layer.transform, 0.9, 0.9, 0.9) layer:layer];
//                    
//                    [layer addAnimation:[self transformAnimation:0.15 toValue:CATransform3DScale(layer.transform, 0.9, 0.9, 0.9) layer:layer] forKey:@"rotateAnimation"];
//                    layer.transform = CATransform3DScale(layer.transform, 0.9, 0.9, 0.9);
//                }
//
            }
        }
        _beforePoint = delta;
    } else if (recognizer.state >= UIGestureRecognizerStateEnded) {        
        CALayer *firstLayer = [_layerList objectAtIndex:0];
        if (_touchedLayer && fabs(_touchedLayer.position.x - self.center.x) > 120) {
            [self removeViewInList:_touchedLayer];
        } else if (CGRectGetMaxY(firstLayer.frame) < self.bounds.size.height || CGRectGetMinY([[_layerList lastObject] frame]) > 0) {
            [self adjustLayerPosition];
        } else {
            NSLog(@"vel : %f", velocity.y);
//            [self adjustLayerListWithIndex:0];
            NSLog(@"duration : %f", self.bounds.size.height / fabs(velocity.y));
            CGFloat duration = MIN(300 / fabs(velocity.y), 0.5);
            [CATransaction setAnimationDuration:duration];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
            for (CALayer *layer in _layerList) {
                layer.position = CGPointMake(layer.position.x, layer.position.y + velocity.y * 0.3);
                layer.transform = CATransform3DRotate([self getInitialTransform], DEGREES_TO_RADIANS([self calculateInitiailRotateDegree:layer.position]), 1, 0, 0);
            }
            [self performSelector:@selector(adjustLayerPosition) withObject:nil afterDelay:duration];
        }
        _beforePoint = CGPointZero;
    }
    
    
}

- (CABasicAnimation *) transformAnimation:(CGFloat) duration  toValue:(CATransform3D) toValue layer:(CALayer *)layer{
//    NSLog(@"toValue : %f", toValue);
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:[(CALayer*)[layer presentationLayer] transform]];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:toValue];
    transformAnimation.duration = duration;
    transformAnimation.fillMode = kCAFillModeForwards;
    transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return transformAnimation;
}

@end
