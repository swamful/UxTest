//
//  SlideSlingGestureView.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 8. 14..
//

#import "SlideSlingGestureView.h"
#define numOfMainBtn 3
#define numOfShowBtnInFrame 5
#define leftList [NSMutableDictionary dictionaryWithObjectsAndKeys:@"설정",@"0", @"추천",@"1", @"홈",@"2", nil]

@interface SlideSlingGestureView()
- (void) makeGrdientLayer;
- (void) makeLayer;
- (void) makeTitle:(NSDictionary *) data inLayer:(CALayer *) layer;
- (void) adjustLeftLayerPointX:(CGFloat) pointX;
- (void) adjustRightLayerPointX:(CGFloat) pointX;
- (BOOL) isLeftLayerInPoint:(CGPoint)point;
- (BOOL) isOnlyRightLayerInPoint:(CGPoint)point;
- (void) textLayerShow;
- (void) adjustFrameBetweenLayer;
- (void) homeTextShow:(BOOL) show;
- (void) positionJunction;
@end
@implementation SlideSlingGestureView

@synthesize data = _data, didFinishSelect = _didFinishSelect;

- (id) initWithFrame:(CGRect)frame withData:(NSDictionary*) data
{
    self = [super initWithFrame:frame];
    if (self) {
        self.data = [data retain];
        btnWidth = self.frame.size.width / numOfShowBtnInFrame;
        
        
        _leftTextLayerList = [[NSMutableArray alloc] init];
        _rightTextLayerList = [[NSMutableArray alloc] init];
        
        UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panRecognizer.minimumNumberOfTouches = 1;
        [self addGestureRecognizer:panRecognizer];
        [panRecognizer release];
        
        UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tapRecognizer];
        [tapRecognizer release];
        
        [self makeLayer];
        [self makeGrdientLayer];
        [CATransaction setDisableActions:NO];
        [CATransaction setValue:[NSNumber numberWithFloat:0.5] forKey:kCATransactionAnimationDuration];
    }
    return self;
}

- (void) dealloc {
    self.didFinishSelect = nil;
    [_leftTextLayerList release];
    [_rightTextLayerList release];
    [super dealloc];
}

- (void) makeGrdientLayer {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
//    gradient.backgroundColor = [UIColor clearColor].CGColor;
//    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor grayColor] CGColor], (id)[[UIColor whiteColor] CGColor],(id)[[UIColor whiteColor] CGColor],(id)[[UIColor whiteColor] CGColor],(id)[[UIColor grayColor] CGColor],nil];
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(1.0, 0.0);
    
    CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
    CGColorRef innerColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
    
    gradient.colors = [NSArray arrayWithObjects:(id)outerColor, 
                        (id)innerColor, (id)innerColor, (id)outerColor, nil];
    gradient.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], 
                           [NSNumber numberWithFloat:0.2], 
                           [NSNumber numberWithFloat:0.8], 
                           [NSNumber numberWithFloat:1.0], nil];
    
    
    
    [self.layer addSublayer:gradient];
}

- (void) makeLayer {        
    _rightLayer = [CALayer layer];
    rightLayerBasicPositionX = ([self.data count] * btnWidth / 2) + btnWidth * numOfMainBtn;
    _rightLayer.position = CGPointMake(rightLayerBasicPositionX, self.frame.size.height/2);
    _rightLayer.bounds = CGRectMake(0, 0, [self.data count] * btnWidth, self.frame.size.height);
    [self.layer addSublayer:_rightLayer];
    [self makeTitle:self.data inLayer:_rightLayer];
    
    
    _leftLayer = [CALayer layer];
    leftLayerBasicPositionX = btnWidth * numOfMainBtn /2;
    _leftLayer.position = CGPointMake(leftLayerBasicPositionX, self.frame.size.height/2);
    _leftLayer.bounds = CGRectMake(0, 0, btnWidth * numOfMainBtn, self.frame.size.height);
    [self.layer addSublayer:_leftLayer];
    [self makeTitle:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"설정",@"0", @"추천",@"1", @"홈",@"2", nil] inLayer:_leftLayer];
    
    [self textLayerShow];
}

- (void) makeTitle:(NSMutableDictionary *) data inLayer:(CALayer *) layer{
    for (int i = 0; i < [data count]; i ++) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.text = (NSString *)[data objectForKey:[NSString stringWithFormat:@"%d", i]];
        textLabel.textAlignment = UITextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:20.0f];
        textLabel.frame = CGRectMake(btnWidth * i, 0, btnWidth, self.frame.size.height);
        textLabel.backgroundColor = [UIColor clearColor];   
        [layer addSublayer:textLabel.layer];
        
        if (layer.position.x == rightLayerBasicPositionX) {
            [_rightTextLayerList addObject:textLabel];
        } else {
            [_leftTextLayerList addObject:textLabel];
        }
        [textLabel release];
    }
}


- (CGFloat) rightEndPointXInleftLayer {
    return _leftLayer.position.x + _leftLayer.bounds.size.width/2;
}

- (CGFloat) leftEndPointXInRightLayer {
    return _rightLayer.position.x - _rightLayer.bounds.size.width/2;
}


- (void) moveSlideAtIndex:(NSInteger) index {
    foreDeltaX = 0;
    CGFloat movePoint = (index - centerIndex) * btnWidth;

    BOOL isFixedLeftLayer = [self rightEndPointXInleftLayer] <= btnWidth;

    if (index <= 4) {
        if (!(index == 4 && isFixedLeftLayer)) {
            _leftLayer.position = CGPointMake(_leftLayer.position.x - movePoint, _leftLayer.position.y);            
        }
    }
    [self adjustRightLayerPointX:-movePoint];

    [self textLayerShow];
    if (centerIndex >= 4) {
        [self homeTextShow:YES];
    } else {
        [self homeTextShow:NO];
    }
}

- (BOOL) isWhichFrameIn:(UILabel *) textLabel isLeftLayer:(BOOL) isLeft withPosition:(SlideLayerPosition) position{
    CGRect leftFrame = CGRectMake((NSInteger) position * btnWidth, 0 , btnWidth , self.frame.size.height);
    CGRect rightFrame = CGRectMake(self.frame.size.width - btnWidth - (NSInteger) position *btnWidth, 0, btnWidth, self.frame.size.height);
    
    CGPoint absolutePoint;
    if (isLeft) {
        absolutePoint = CGPointMake(_leftLayer.position.x - _leftLayer.bounds.size.width/2 + textLabel.center.x, textLabel.center.y);
    } else {
        absolutePoint = CGPointMake([self leftEndPointXInRightLayer] + textLabel.center.x, textLabel.center.y);
    }

    if (CGRectContainsPoint(leftFrame, absolutePoint)) {
        return YES;
    } else if (CGRectContainsPoint(rightFrame, absolutePoint)) {
        return YES;
    }

    return NO;
}


#pragma mark - GestureReconizer
- (void) handleTap:(UITapGestureRecognizer *) recognizer {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *) recognizer;
    CGPoint location = [tap locationInView:tap.view];
    NSInteger index;
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([self isOnlyRightLayerInPoint:location]) {
            CGFloat relativePosition = location.x - [self leftEndPointXInRightLayer];
            index = relativePosition / btnWidth;
            [self moveSlideAtIndex:index + 3];
        } else if ([self isLeftLayerInPoint:location]) {
            CGFloat relativePosition = location.x - (_leftLayer.position.x - _leftLayer.bounds.size.width/2);
            index = relativePosition / btnWidth;
            [self moveSlideAtIndex:index];
        }
        if (self.didFinishSelect != nil) {
            self.didFinishSelect(index);
        }
    }
}



- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer*)recognizer;
    CGPoint delta = [pan translationInView:pan.view];

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        foreDeltaX = delta.x;
         
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        BOOL isFixedLeftLayer = [self rightEndPointXInleftLayer] <= btnWidth;
        BOOL isOverGapBetweenLayer = [self leftEndPointXInRightLayer] > [self rightEndPointXInleftLayer];
        
        if (!isFixedLeftLayer || isOverGapBetweenLayer) {
            [self adjustLeftLayerPointX:delta.x];
        }
        [self adjustRightLayerPointX:delta.x];
         
        foreDeltaX = delta.x;
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self positionJunction];
    }

    [self textLayerShow];
    [self adjustFrameBetweenLayer]; 
}

- (void) homeTextShow:(BOOL) show {
    UILabel *textLabel = [_leftTextLayerList lastObject];
    if (show) {
        textLabel.font = [UIFont systemFontOfSize:20.0f];
        textLabel.alpha = 1.0f;
        textLabel.textColor = [UIColor whiteColor];
        textLabel.backgroundColor = [UIColor blackColor];        
    } else {
        textLabel.textColor = [UIColor blackColor];
        textLabel.backgroundColor = [UIColor clearColor];
    }
}

- (void) positionJunction {
    NSInteger leftMoveStep = (NSInteger)(leftLayerBasicPositionX - _leftLayer.position.x)/btnWidth;
    NSInteger rightMoveStep = (NSInteger)(rightLayerBasicPositionX - _rightLayer.position.x)/btnWidth;        
    
    
    if (leftMoveStep < 0) {
        leftMoveStep = MAX(-2, leftMoveStep);
    }
    
    if (rightMoveStep > 0) {
        rightMoveStep = MIN([self.data count], rightMoveStep);            
    } else {
        rightMoveStep = MAX(-2, rightMoveStep);            
    }
    
    _leftLayer.position = CGPointMake(leftLayerBasicPositionX - btnWidth * leftMoveStep, _leftLayer.position.y);    
    _rightLayer.position = CGPointMake(rightLayerBasicPositionX - btnWidth * rightMoveStep, _rightLayer.position.y);
    
    if (leftMoveStep == 2) {
        [self homeTextShow:YES];
    } else {
        [self homeTextShow:NO];
    }
}

- (void) adjustFrameBetweenLayer {
    BOOL isOverGapBetweenLayer = [self leftEndPointXInRightLayer] > [self rightEndPointXInleftLayer];
    if (isOverGapBetweenLayer) {
        NSInteger leftMoveStep = ([self leftEndPointXInRightLayer] - [self rightEndPointXInleftLayer]) / btnWidth;
        _leftLayer.position = CGPointMake(_leftLayer.position.x + btnWidth * leftMoveStep, _leftLayer.position.y);
        [self homeTextShow:NO];
    }
}

- (void) adjustLeftLayerPointX:(CGFloat) pointX {
    if (_leftLayer.position.x >= leftLayerBasicPositionX - btnWidth * 2) {
        _leftLayer.position = CGPointMake(_leftLayer.position.x + pointX - foreDeltaX, _leftLayer.position.y);            
        [self homeTextShow:NO];
    } else {
        _leftLayer.position = CGPointMake(leftLayerBasicPositionX - btnWidth * 2, _leftLayer.position.y);
        [self homeTextShow:YES];
    }
}

- (void) adjustRightLayerPointX:(CGFloat) pointX {
    _rightLayer.position = CGPointMake(_rightLayer.position.x + pointX - foreDeltaX, _rightLayer.position.y);
}

- (BOOL) isLeftLayerInPoint:(CGPoint)point {
    CGRect layerFrame = CGRectMake(_leftLayer.position.x - _leftLayer.bounds.size.width/2, _leftLayer.position.y - _leftLayer.bounds.size.height/2, _leftLayer.bounds.size.width, _leftLayer.bounds.size.height);
    if (CGRectContainsPoint(layerFrame, point)) {
        return YES;
    }
    return NO;
}

- (BOOL) isOnlyRightLayerInPoint:(CGPoint)point {
    CGRect layerFrame = CGRectMake([self leftEndPointXInRightLayer], _rightLayer.position.y - _rightLayer.bounds.size.height/2, _rightLayer.bounds.size.width, _rightLayer.bounds.size.height);
    if (CGRectContainsPoint(layerFrame, point) && ![self isLeftLayerInPoint:point]) {
        return YES;
    }
    return NO;
}

- (void) textLayerShow {
    NSInteger numOfCoverdBtn = 0;
    if ([self rightEndPointXInleftLayer] > [self leftEndPointXInRightLayer]) {
        numOfCoverdBtn = (NSInteger) ([self rightEndPointXInleftLayer] - [self leftEndPointXInRightLayer]) / btnWidth;
    }
    
    numOfCoverdBtn = MIN(numOfCoverdBtn, [_rightTextLayerList count]);
    for (int i = 0; i < numOfCoverdBtn; i++) {
        UILabel *textLabel = [_rightTextLayerList objectAtIndex:i];
        textLabel.alpha = 0.0;
    }
    
    for (int i = numOfCoverdBtn; i < [_rightTextLayerList count]; i++) {
        UILabel *textLabel = [_rightTextLayerList objectAtIndex:i];
        if ([self isWhichFrameIn:textLabel isLeftLayer:NO withPosition:SIDE]) {
            textLabel.alpha = 0.3;
            textLabel.font = [UIFont systemFontOfSize:10.0f];
        } else if ([self isWhichFrameIn:textLabel isLeftLayer:NO withPosition:MEDIUM]) {
            textLabel.alpha = 1.0;
            textLabel.font = [UIFont systemFontOfSize:15.0f];
        } else if([self isWhichFrameIn:textLabel isLeftLayer:NO withPosition:CENTER]){
            textLabel.font = [UIFont systemFontOfSize:20.0f];
            textLabel.alpha = 1.0;
            centerIndex = i + [_leftTextLayerList count];
        }
    }
    
    for (int i = 0 ; i < [_leftTextLayerList count]; i ++) {
        UILabel *textLabel = [_leftTextLayerList objectAtIndex:i];
        if ([self isWhichFrameIn:textLabel isLeftLayer:YES withPosition:SIDE] && !(i==2 && _leftLayer.position.x < leftLayerBasicPositionX)) {
            textLabel.alpha = 0.3;
            textLabel.font = [UIFont systemFontOfSize:10.0f];
        } else if ([self isWhichFrameIn:textLabel isLeftLayer:YES withPosition:MEDIUM]) {
            textLabel.alpha = 1.0;
            textLabel.font = [UIFont systemFontOfSize:15.0f];
        } else if([self isWhichFrameIn:textLabel isLeftLayer:YES withPosition:CENTER]){
            textLabel.font = [UIFont systemFontOfSize:20.0f];
            textLabel.alpha = 1.0;
            centerIndex = i;
        }
    }
}

@end
