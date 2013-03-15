//
//  SlideShowView.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 8. 7..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import "SlideShowView.h"
@interface SlideShowView()
- (void) showSlide:(CALayer*) showLayer;
- (void) triggerSlideAnimation;
- (void) makeLayerList;
@end
@implementation SlideShowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeLayerList];
        imageIndexCount = 0;
        CALayer *layer = [_layerList objectAtIndex:imageIndexCount++];
        [self.layer addSublayer:layer];
        [self showSlide:layer];
    }
    return self;
}

- (void) makeLayerList { 
    _layerList = [[NSMutableArray alloc] init];
    for (int i = 1 ; i <= 5 ; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpeg", i]];
        CALayer *layer = [CALayer layer];    
        layer.contents = (id)image.CGImage;
        layer.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        layer.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height/2);  
        [_layerList addObject:layer];
    }
}

- (void) stopAnimation {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    for (CALayer *layer in _layerList) {
        [layer removeAllAnimations];
        [layer removeFromSuperlayer];
    }
}

- (void) triggerSlideAnimation {

    CALayer *layer = [_layerList objectAtIndex:imageIndexCount%5];

    NSInteger randomX = arc4random() % (NSInteger)(layer.bounds.size.width/2 - self.frame.size.width/2);
    NSInteger randomY = arc4random() % (NSInteger)(layer.bounds.size.height/2 - self.frame.size.height/2);
    [CATransaction setDisableActions:YES];

    NSInteger randomSign = arc4random()%4;
    if (randomSign == 1) {
        randomX = -randomX;
    } else if (randomSign == 2) {
        randomY = -randomY;
    } else if (randomSign == 3) {
        randomX = -randomX;
        randomY = -randomY;
    } 
    
    
    layer.position = CGPointMake(self.frame.size.width / 2 + randomX, self.frame.size.height /2 + randomY);
//    NSLog(@"randoxX : %d  randomY:%d", randomX, randomY);
//    NSLog(@"position : %@  bounds : %@", NSStringFromCGPoint(layer.position), NSStringFromCGRect(layer.bounds));
    [self.layer addSublayer:layer];
    [self showSlide:layer];
    CALayer *removeLayer = [_layerList objectAtIndex:(imageIndexCount -1 )%5];
    [removeLayer performSelector:@selector(removeFromSuperlayer) withObject:nil afterDelay:0.9];
    imageIndexCount ++;
}


- (void) showSlide:(CALayer*) showLayer {

 	CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
	fadeInAnimation.fromValue = [NSNumber numberWithFloat:0.0];
	fadeInAnimation.duration = 2.0;   
    
	CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeOutAnimation.toValue = [NSNumber numberWithFloat:0.0];
	fadeOutAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    fadeOutAnimation.beginTime = 8.0f;
	fadeOutAnimation.duration = 2.0;
	
	CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
	scaleAnimation.toValue = [NSNumber numberWithFloat:1.8];
	scaleAnimation.duration = 10.0f;
	scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
	animationGroup.duration = 10.0f;
    animationGroup.fillMode = kCAFillModeRemoved;
	[animationGroup setAnimations:[NSArray arrayWithObjects:fadeInAnimation, fadeOutAnimation, scaleAnimation, nil]];
    
	[showLayer addAnimation:animationGroup forKey:@"animationGroup"];    
    [self performSelector:@selector(triggerSlideAnimation) withObject:nil afterDelay:9.0];
}

- (void) dealloc {
    [_layerList release];
    [super dealloc];
}

@end
