//
//  SlideSlingView.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 8. 13..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import "SlideSlingView.h"
#define numOfMainBtn 3
#define numOfShowBtnInFrame 5
#define leftList [NSMutableDictionary dictionaryWithObjectsAndKeys:@"설정",@"0", @"추천",@"1", @"홈",@"2", nil]
@interface SlideSlingView()
- (void) makeGrdientLayer;
- (void) makeLayer;
- (void) makeTitle:(NSDictionary *) data inLayer:(CALayer *) layer;
@end


@implementation SlideSlingView
@synthesize data = _data;

- (id) initWithFrame:(CGRect)frame withData:(NSDictionary*) data
{
    self = [super initWithFrame:frame];
    if (self) {
        self.data = [data retain];
        btnWidth = self.frame.size.width / numOfShowBtnInFrame;
        
        [self makeGrdientLayer];
  
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _mainScrollView.delegate = self;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_mainScrollView];
        [_mainScrollView release];
        _mainScrollView.contentSize = CGSizeMake(btnWidth * ([data count] + numOfMainBtn), self.frame.size.height);
        [self bringSubviewToFront:_mainScrollView];
        
        [self makeLayer];
        
        [CATransaction setDisableActions:NO];
        [CATransaction setValue:[NSNumber numberWithFloat:0.5] forKey:kCATransactionAnimationDuration];
    }
    return self;
}

- (void) makeGrdientLayer {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor grayColor] CGColor], (id)[[UIColor whiteColor] CGColor],(id)[[UIColor whiteColor] CGColor],(id)[[UIColor whiteColor] CGColor],(id)[[UIColor grayColor] CGColor],nil];
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(1.0, 0.0);
    [self.layer addSublayer:gradient];
}

- (void) makeLayer {

    
    _mainLayer = [CALayer layer];
    _mainLayer.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    _mainLayer.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.layer addSublayer:_mainLayer];
//    _mainLayer.anchorPointZ = 10.0f;
//    _mainLayer.transform = CATransform3DTranslate(_mainLayer.transform, 0, 0, 10);
    
    _leftLayer = [CALayer layer];
    leftLayerBasicPositionX = btnWidth * numOfMainBtn /2;
    _leftLayer.position = CGPointMake(leftLayerBasicPositionX, self.frame.size.height/2);
    _leftLayer.bounds = CGRectMake(0, 0, btnWidth * numOfMainBtn, self.frame.size.height);
    [self.layer addSublayer:_leftLayer];
    [self makeTitle:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"설정",@"0", @"추천",@"1", @"홈",@"2", nil] inLayer:_leftLayer];
    
    _rightLayer = [CALayer layer];
    rightLayerBasicPositionX = ([self.data count] * btnWidth / 2) + btnWidth * numOfMainBtn;
    _rightLayer.position = CGPointMake(rightLayerBasicPositionX, self.frame.size.height/2);
    _rightLayer.bounds = CGRectMake(0, 0, [self.data count] * btnWidth, self.frame.size.height);
    [self.layer addSublayer:_rightLayer];
    [self makeTitle:self.data inLayer:_rightLayer];
}

- (void) makeTitle:(NSMutableDictionary *) data inLayer:(CALayer *) layer{
    for (int i = 0; i < [data count]; i ++) {
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.string= (NSString *)[data objectForKey:[NSString stringWithFormat:@"%d", i]]; 
        textLayer.font=@"Lucida-Grande"; 
        textLayer.fontSize= 15.0f; 
        textLayer.foregroundColor=[UIColor blackColor].CGColor;
        textLayer.bounds = CGRectMake(0, 0, btnWidth, self.frame.size.height*0.3);
        textLayer.position = CGPointMake(btnWidth * 0.5 + btnWidth * i, self.frame.size.height * 0.5);
        textLayer.alignmentMode = kCAAlignmentCenter;
        [layer addSublayer:textLayer];
    }
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scrollOffset : %@ limit : %f", NSStringFromCGPoint(scrollView.contentOffset), btnWidth * 2);

    if (scrollView.contentOffset.x > btnWidth *2) {
//       _mainLayer.transform = CATransform3DRotate(_mainLayer.transform, (CGFloat)DEGREES_TO_RADIANS(forePoint - scrollView.contentOffset.x), 0 , 1, 0);
        _leftLayer.position = CGPointMake(leftLayerBasicPositionX - btnWidth * 2, _leftLayer.position.y);
        _rightLayer.position = CGPointMake(rightLayerBasicPositionX - scrollView.contentOffset.x, self.frame.size.height/2);
        NSLog(@"_leftLayer postion : %@", NSStringFromCGPoint(_leftLayer.position));
    } else if(scrollView.contentOffset.x < 0) {
        _leftLayer.position = CGPointMake(leftLayerBasicPositionX - scrollView.contentOffset.x, _leftLayer.position.y);   
        _rightLayer.position = CGPointMake(rightLayerBasicPositionX - scrollView.contentOffset.x, _rightLayer.position.y);
        NSLog(@"scrollView.contentOffset.x < 0 _leftLayer postion : %@", NSStringFromCGPoint(_leftLayer.position));
    } else {
        _leftLayer.position = CGPointMake(leftLayerBasicPositionX - scrollView.contentOffset.x, _leftLayer.position.y);
        _rightLayer.position = CGPointMake(rightLayerBasicPositionX - scrollView.contentOffset.x, _rightLayer.position.y);
        NSLog(@"else _leftLayer postion : %@", NSStringFromCGPoint(_leftLayer.position));
    }


}


@end
