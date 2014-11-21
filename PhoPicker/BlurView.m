//
//  BlurView.m
//  PhoPicker
//
//  Created by 승필 백 on 13. 3. 6..
//

#import "BlurView.h"

@implementation BlurView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = UIColorFromRGB(0xc9ffc3, 0.8);
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0xb3ffaa, 0.9) CGColor],
                                (id)[UIColorFromRGB(0x7dfe74, 0.9) CGColor],
                                (id)[UIColorFromRGB(0x47c83e, 0.9) CGColor],
                                (id)[UIColorFromRGB(0x008000, 0.9) CGColor],
                                (id)[UIColorFromRGB(0x003800, 0.9) CGColor],
                                nil];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 1);
        gradientLayer.frame = self.bounds;
        gradientLayer.contentsGravity = kCAGravityResize;
        [self.layer addSublayer:gradientLayer];
        
        _bevelLayerList = [[NSMutableArray alloc] init];
        titleLayer = [CALayer layer];
        UIImage *naverAppImg = [UIImage imageNamed:@"naverapp"];
        titleLayer.contents = (id) naverAppImg.CGImage;
        titleLayer.position = self.center;
        titleLayer.bounds = CGRectMake(0, 0, naverAppImg.size.width * 0.3, naverAppImg.size.height * 0.3);
        [self.layer addSublayer:titleLayer];
        
        lightLayer = [CAShapeLayer layer];
        lightLayer.transform = CATransform3DMakePerspective(1000);
        lightLayer.anchorPoint = CGPointMake(0, 1);
        
        lightLayer.frame = CGRectMake(-70, 0, titleLayer.bounds.size.width + 40, titleLayer.bounds.size.height);

        [lightLayer setShadowOpacity:1.0];
        [lightLayer setShadowRadius:15.0f];
        [lightLayer setShadowColor:[UIColorFromRGB(0xC4FFBE, 1.0) CGColor]];
        [lightLayer setShadowPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, titleLayer.bounds.size.width + 80, titleLayer.bounds.size.height) cornerRadius:20.0f] CGPath]];
        lightLayer.transform = CATransform3DRotate(CATransform3DMakePerspective(1000), DEGREES_TO_RADIANS(-90), 0, 0, 1);
        
        [titleLayer addSublayer:lightLayer];
//        titleLayer.mask = lightLayer;
        titleLayer.masksToBounds = YES;
        
        UIButton *repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [repeatBtn setFrame:CGRectMake(20, 10, 60, 40)];
        [repeatBtn setTitle:@"start" forState:UIControlStateNormal];
        [repeatBtn addTarget:self action:@selector(repeat) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:repeatBtn];
        
        [self makeBevelLayerList];
    }
    return self;
}

- (void) makeBevelLayerList {
    CALayer *bevelLayer = [self makeBevelLayerWithSize:CGSizeMake(80, 80) withColor:UIColorFromRGB(0x00486f, 0.8)];
    bevelLayer.position = CGPointMake(150, 140);
    bevelLayer.opacity = 0.0f;
    [self.layer addSublayer:bevelLayer];
    [_bevelLayerList addObject:bevelLayer];
    
    bevelLayer = [self makeBevelLayerWithSize:CGSizeMake(120, 120) withColor:UIColorFromRGB(0xd6c94d, 0.8)];
    bevelLayer.position = CGPointMake(40, 320);
    bevelLayer.opacity = 0.0f;
    [self.layer addSublayer:bevelLayer];
    [_bevelLayerList addObject:bevelLayer];
    
    bevelLayer = [self makeBevelLayerWithSize:CGSizeMake(90, 90) withColor:UIColorFromRGB(0xbc2424, 0.8)];
    bevelLayer.position = CGPointMake(10, 120);
    bevelLayer.opacity = 0.0f;
    [self.layer addSublayer:bevelLayer];
    [_bevelLayerList addObject:bevelLayer];

}

- (void) repeat {
    [self beginAnimation];
}

- (void) beginAnimation {
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(-90)];
    rotateAnimation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(90)];
    rotateAnimation.beginTime = 8.0f;
    rotateAnimation.duration = 4.0f;
    rotateAnimation.repeatCount = HUGE_VAL;
    rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [lightLayer addAnimation:rotateAnimation forKey:@"rotateAnimation"];
    
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 12.0f;
    animationGroup.repeatCount = HUGE_VAL;
    [animationGroup setAnimations:[NSArray arrayWithObjects:[self opacityAnimationValue:1.0 beginTime:1 duration:5 autoReverse:YES]
                                                            ,[self moveAnimationToPosition:CGPointMake(50,100) beginTime:0 duration:12]
                                                            ,nil]];
    
    CALayer *layer = [_bevelLayerList objectAtIndex:0];
    [layer addAnimation:animationGroup forKey:@"aniGroup"];
    
    animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 12.0f;
    animationGroup.repeatCount = HUGE_VAL;
    [animationGroup setAnimations:[NSArray arrayWithObjects:[self opacityAnimationValue:1.0 beginTime:0 duration:6 autoReverse:YES]
                                   ,[self moveAnimationToPosition:CGPointMake(150,380) beginTime:0 duration:12]
                                   ,nil]];
    
    layer = [_bevelLayerList objectAtIndex:1];
    [layer addAnimation:animationGroup forKey:@"aniGroup"];
    
    animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 12.0f;
    animationGroup.repeatCount = HUGE_VAL;
    [animationGroup setAnimations:[NSArray arrayWithObjects:[self opacityAnimationValue:1.0 beginTime:0 duration:12 autoReverse:YES]
                                   ,[self moveAnimationToPosition:CGPointMake(100,-100) beginTime:0 duration:12]
                                   ,nil]];
    
    layer = [_bevelLayerList objectAtIndex:2];
    [layer addAnimation:animationGroup forKey:@"aniGroup"];
}

- (CABasicAnimation *) opacityAnimationValue:(CGFloat) toValue beginTime:(CGFloat) beginTime duration:(CGFloat) duration autoReverse:(BOOL) autoReverse{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue = [NSNumber numberWithFloat:toValue];
    opacityAnimation.duration = duration;
    opacityAnimation.beginTime = beginTime;
    opacityAnimation.autoreverses = autoReverse;
    return opacityAnimation;
}

- (CABasicAnimation *) moveAnimationToPosition:(CGPoint) position beginTime:(CGFloat) beginTime duration:(CGFloat) duration {
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.toValue = [NSValue valueWithCGPoint:position];
    moveAnimation.duration = duration;
    moveAnimation.beginTime = beginTime;
    return moveAnimation;
}

- (CALayer *) makeBevelLayerWithSize:(CGSize) size withColor:(UIColor*) color{
    CALayer *bevelLayer = [CALayer layer];
    bevelLayer.bounds = CGRectZero;
    [bevelLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [bevelLayer setShadowOpacity:1.0];
    [bevelLayer setShadowRadius:12.0f];
    [bevelLayer setShadowColor:[color CGColor]];
    [bevelLayer setShadowPath:[[UIBezierPath bezierPathWithRoundedRect:(CGRect){CGPointZero, size} cornerRadius:size.width/2] CGPath]];
    return bevelLayer;
}

@end
