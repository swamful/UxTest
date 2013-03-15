//
//  PathAniView.m
//  PhoPicker
//
//  Created by 승필 백 on 13. 3. 14..
//  Copyright (c) 2013년 NHN Corp. All rights reserved.
//

#import "PathAniView.h"
#define radius 120
@implementation PathAniView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _mainLayer = [CALayer layer];
        _mainLayer.position = self.center;
        _mainLayer.bounds = self.bounds;
        [self.layer addSublayer:_mainLayer];
        
        _btnList = [[NSMutableArray alloc] init];
        
        
        _startBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _startBtn.layer.position = CGPointMake(30, self.bounds.size.height - 40);
        _startBtn.layer.bounds = CGRectMake(0, 0, 45, 45);
        [_startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
        [_startBtn setBackgroundImage:[UIImage imageNamed:@"h_ball_bg"] forState:UIControlStateNormal];
        [_startBtn setImage:[UIImage imageNamed:@"h_ball_plus"] forState:UIControlStateNormal];
        [self addSubview:_startBtn];

        for (int i = 0; i < 10; i++) {
            CALayer *layer = [CALayer layer];
            layer.contents = (id)[UIImage imageNamed:[NSString stringWithFormat:@"p%d",i]].CGImage;
            layer.position = _startBtn.layer.position;
            layer.bounds = (CGRect){CGPointZero, CGSizeMake(40, 40)};
            [_mainLayer addSublayer:layer];
            [_btnList addObject:layer];
        }
        
        UIButton *rotateEnableBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        rotateEnableBtn.frame = CGRectMake(10, 10, 100, 40);
        [rotateEnableBtn setTitle:@"rotateDisable" forState:UIControlStateNormal];
        [rotateEnableBtn addTarget:self action:@selector(rotateEnable:) forControlEvents:UIControlEventTouchUpInside];
        [rotateEnableBtn setTitle:@"rotateEnable" forState:UIControlStateSelected];
        [self addSubview:rotateEnableBtn];
        
        _pathAniBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _pathAniBtn.frame = CGRectMake(120, 10, 150, 40);
        [_pathAniBtn setTitle:@"org path Ani" forState:UIControlStateNormal];
        [_pathAniBtn addTarget:self action:@selector(pathAni:) forControlEvents:UIControlEventTouchUpInside];
        [_pathAniBtn setTitle:@"upgrade path Ani" forState:UIControlStateSelected];
        [self addSubview:_pathAniBtn];
        
        _needBegin = YES;
    }
    return self;
}

- (void) pathAni:(UIButton *) btn {
    btn.selected = !btn.selected;
    _needBegin = YES;
    if (btn.selected) {
        _startBtn.layer.position = self.center;
    } else {
        _startBtn.layer.position = CGPointMake(30, self.bounds.size.height - 40);
    }
    
    for (CALayer *layer in _btnList) {
        [layer removeAllAnimations];
        layer.position = _startBtn.layer.position;
    }
}

- (void) rotateEnable:(UIButton *)btn; {
    _isEnableRotate = !_isEnableRotate;
    btn.selected = !btn.selected;
}

- (void) start {
    if (_needBegin) {
        [UIView animateWithDuration:0.1 animations:^{
            _startBtn.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(45));
        }];
        if (!_pathAniBtn.selected) {
            [self beginPathOrgAnimation];
        } else {
            [self beginAnimation];
        }
    } else {
        [UIView animateWithDuration:0.1 animations:^{
            _startBtn.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
        }];
        [self endAnimation];
    }
    _needBegin = !_needBegin;
}

- (void) endAnimation {
    int i = 0;
    for (CALayer *layer in _btnList) {
        CGFloat moveBeginTime = 0.3;
        CAAnimationGroup *aniGroup = [CAAnimationGroup animation];
        aniGroup.duration = 1.0f;
        aniGroup.fillMode = kCAFillModeForwards;
        aniGroup.removedOnCompletion = NO;
        aniGroup.animations = [NSArray arrayWithObjects:[self rotateAnimationWithDuration:0.8 toValue:360 * 5 beginTime:0 repeatCount:0],
                               [self moveAnimationToPosition:_startBtn.layer.position beginTime:(moveBeginTime - (0.03*i++)) duration:0.2 autoReverse:NO],
                               nil];
        [layer addAnimation:aniGroup forKey:@"backAniGroup"];
    }
}

- (void) beginPathOrgAnimation {
    for (int i = 0; i <5; i ++) {
        CALayer *layer = [_btnList objectAtIndex:i];
        CGFloat moveBeginTime = 0;
        CGPoint finalPosition = CGPointMake((cosf(DEGREES_TO_RADIANS((90 / 4) * (i - 4))) * radius) + _startBtn.layer.position.x, sinf(DEGREES_TO_RADIANS((90 / 4) * (i - 4))) * radius + _startBtn.layer.position.y);
        CGPoint bouncePosition = CGPointMake((cosf(DEGREES_TO_RADIANS((90 / 4) * (i - 4))) * radius * 0.97) + _startBtn.layer.position.x, sinf(DEGREES_TO_RADIANS((90 / 4) * (i - 4))) * radius * 0.97 + _startBtn.layer.position.y);
        CAAnimationGroup *aniGroup = [CAAnimationGroup animation];
        aniGroup.duration = 1.0f;
        aniGroup.fillMode = kCAFillModeForwards;
        aniGroup.removedOnCompletion = NO;
        moveBeginTime = 0.02 * (i + 2);
        aniGroup.animations = [NSArray arrayWithObjects:[self rotateAnimationWithDuration:0.5 toValue:-360 beginTime:0 repeatCount:0],
                               [self moveAnimationToPosition:finalPosition beginTime:moveBeginTime duration:0.25 autoReverse:NO],
                               [self moveAnimationToPosition:bouncePosition beginTime:moveBeginTime + 0.25 duration:0.1 autoReverse:YES],
                               nil];
        [layer addAnimation:aniGroup forKey:@"aniGroup"];
    }
}

- (void) beginAnimation {
    if (_isEnableRotate) {
        [_mainLayer addAnimation:[self rotateAnimationWithDuration:1.0 toValue:360 * 2 beginTime:0 repeatCount:0] forKey:@"rotateAnimation"];
    }

    int i = -2;
    for (CALayer *layer in _btnList) {
        CGFloat moveBeginTime = 0;
        CGPoint finalPosition = CGPointMake((cosf(DEGREES_TO_RADIANS(36 * i)) * radius) + self.center.x, sinf(DEGREES_TO_RADIANS(36 * i)) * radius + self.center.y);
        CGPoint bouncePosition = CGPointMake((cosf(DEGREES_TO_RADIANS(36 * i)) * radius * 0.95) + self.center.x, sinf(DEGREES_TO_RADIANS(36 * i++)) * radius * 0.95 + self.center.y);
        CAAnimationGroup *aniGroup = [CAAnimationGroup animation];

        aniGroup.fillMode = kCAFillModeForwards;
        aniGroup.removedOnCompletion = NO;
        if (!_isEnableRotate) {
            moveBeginTime = 0.03 * (i + 2);
            aniGroup.duration = 1.0f;
            aniGroup.animations = [NSArray arrayWithObjects:[self rotateAnimationWithDuration:0.7 toValue:360 beginTime:0 repeatCount:0],
                                   [self moveAnimationToPosition:finalPosition beginTime:moveBeginTime duration:0.4 autoReverse:NO],
                                   [self moveAnimationToPosition:bouncePosition beginTime:moveBeginTime + 0.4 duration:0.1 autoReverse:YES],
                                   nil];
        } else {
            aniGroup.duration = 1.5f;
            aniGroup.animations = [NSArray arrayWithObjects:[self rotateAnimationWithDuration:1.5 toValue:360 * 3 beginTime:0 repeatCount:0],
                                   [self moveAnimationToPosition:finalPosition beginTime:moveBeginTime duration:0.8 autoReverse:NO],
                                   nil];
        }
        [layer addAnimation:aniGroup forKey:@"aniGroup"];
        layer.position = finalPosition;
        
    }
}

- (CABasicAnimation *) rotateAnimationWithDuration:(CGFloat) duration  toValue:(CGFloat) toValue beginTime:(CGFloat) beginTime repeatCount:(CGFloat) repeatCount{
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(toValue)];
    rotateAnimation.beginTime = beginTime;
    rotateAnimation.duration = duration;
    rotateAnimation.repeatCount = repeatCount;
    rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return rotateAnimation;
}

- (CABasicAnimation *) moveAnimationToPosition:(CGPoint) position beginTime:(CGFloat) beginTime duration:(CGFloat) duration autoReverse:(BOOL) autoReverse{
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.toValue = [NSValue valueWithCGPoint:position];
    moveAnimation.duration = duration;
    moveAnimation.beginTime = beginTime;
    moveAnimation.fillMode = kCAFillModeForwards;
    moveAnimation.removedOnCompletion = NO;        
    moveAnimation.autoreverses = autoReverse;
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return moveAnimation;
}

@end
