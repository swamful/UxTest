//
//  EarthEffectView.m
//  PhoPicker
//
//  Created by 승필 백 on 13. 5. 31..
//

#import "EarthEffectView.h"
#define diameterWidth 200
@implementation EarthEffectView
- (CATransform3D) getTransForm3DIdentity {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = - 1.0f/ 1000.0f;
    return transform;
}

- (CATransform3D) getWidthTransForm3DIdentity:(int) index {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = - 1.0f/ 1000.0f;
    transform = CATransform3DRotate(transform, DEGREES_TO_RADIANS(45.0f * (index - 1)), 0, 1, 0);
    return transform;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor blackColor];
        UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panRecognizer.minimumNumberOfTouches = 1;
        [self addGestureRecognizer:panRecognizer];
        [panRecognizer release];
        _widthLayerList = [[NSMutableArray alloc] init];
        
        [self makeWidthCircles];
//        [self makeHeightCircles];
    }
    return self;
}

- (void) dealloc {
    [_widthLayerList release];
    [super dealloc];
}

- (void) makeHeightCircles {
    for (int i = 0; i < 9; i ++) {
        CALayer *layer = [self circleLayer];
        layer.transform = CATransform3DRotate(layer.transform, DEGREES_TO_RADIANS(90.0f), 1, 0, 0);
        layer.position = CGPointMake(layer.position.x, layer.position.y + diameterWidth / 10 * (i - 4));
        layer.bounds = CGRectMake(0, 0, diameterWidth * sinf(DEGREES_TO_RADIANS(180.0f/10 * (i + 1))), diameterWidth * sinf(DEGREES_TO_RADIANS(180.0f/10 * (i + 1))));
        layer.cornerRadius = layer.bounds.size.width/2;
        [self.layer addSublayer:layer];
    }
}

- (void) makeWidthCircles {
    for (int i = 0 ; i < 4; i++) {
        CALayer *layer = [self circleLayer];
        layer.transform = CATransform3DRotate(layer.transform, DEGREES_TO_RADIANS(45.0f * (i - 1)), 0, 1, 0);
        layer.name = i;
        [self.layer addSublayer:layer];
        [_widthLayerList addObject:layer];
        NSLog(@"rotateDegree : %f", RADIANS_TO_DEGREE([[layer valueForKeyPath:@"transform.rotation.y"] floatValue]));
    }
}

- (CALayer *) circleLayer {
    CALayer *layer = [CALayer layer];
//    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.position = self.center;
    layer.bounds = CGRectMake(0, 0, diameterWidth, diameterWidth);
    layer.borderWidth = 1.0f;
    layer.cornerRadius = diameterWidth/2;
    layer.borderColor = [UIColor blackColor].CGColor;
    layer.transform = [self getTransForm3DIdentity];
    return layer;
}

- (void) handlePan:(UIPanGestureRecognizer *) recognizer {
    CGPoint delta = [recognizer translationInView:recognizer.view];
    
    
    CGFloat deltaX = _beforePoint.x - delta.x;
    CGFloat deltaY = _beforePoint.y - delta.y;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _beforePoint = delta;
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (fabs(deltaX) > fabs(deltaY)) {
            for (CALayer *layer in [self.layer sublayers]) {
//                layer.transform = CATransform3DRotate(layer.transform, DEGREES_TO_RADIANS(-deltaX), 0, 1, 0);
                NSLog(@"rotateDegree : %f", RADIANS_TO_DEGREE([[layer valueForKeyPath:@"transform.rotation.y"] floatValue]));
            }
//            self.layer.transform = CATransform3DRotate(self.layer.transform, DEGREES_TO_RADIANS(deltaX), 0, 1, 0);
            NSLog(@"deltaX : %f", deltaX);
        } else {
            for (CALayer *layer in [self.layer sublayers]) {
                layer.transform = CATransform3DRotate(layer.transform, DEGREES_TO_RADIANS(-deltaY), 1, 0, 0);
//                                layer.transform = CATransform3DRotate([self getWidthTransForm3DIdentity:[layer.name intValue]], DEGREES_TO_RADIANS(delta.y * 0.1), 1, 0, 0);
                NSLog(@"rotateDegree : %f", RADIANS_TO_DEGREE([[layer valueForKeyPath:@"transform.rotation.x"] floatValue]));
            }
//            self.layer.transform = CATransform3DRotate(self.layer.transform, DEGREES_TO_RADIANS(deltaY), 1, 0, 0);
            NSLog(@"deltaY : %f", deltaY);
        }

        
    } else if (recognizer.state >= UIGestureRecognizerStateEnded) {
        
    }
    
    _beforePoint = delta;

}
@end
