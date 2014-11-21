//
//  MeHomeGridView.m
//  NaverSearch
//
//  Created by 백 승필 on 12. 8. 9..
//

#import "MeHomeGridView.h"

#define btnMargin 2
#define numOfColumnInScreen 2
#define numOfRowInScreen 3
@interface MeHomeGridView()
- (void) makeLayerList;
- (void) drawLayerList;
- (void) makeGestureRecognizer;
- (void) playBeginAnimation;
- (void) moveSelectedLayerToLocation:(CGPoint) location;
- (NSInteger) layerIndexInPosition:(CGPoint) position;
- (CALayer*) layerInPoint:(CGPoint) point;
- (NSInteger) targetLayerIndexWithPoint:(CGPoint) point;
- (void) changePosition:(CALayer *) layer;
- (void) closeLayerEnable:(BOOL) enable;
@end

@implementation MeHomeGridView
@synthesize data = _data, didFinishEdit = _didFinishEdit, selectArticle = _selectArticle;
- (id)initWithFrame:(CGRect)frame withTileData:(NSDictionary *) dic
{
    self = [super initWithFrame:frame];
    if (self) {
        self.data= dic; 
        _mainScrollView = [[UIScrollView alloc] initWithFrame:frame];
        [self addSubview:_mainScrollView];
        [_mainScrollView release];
        selectedIndex = -1;
        _layerList = [[NSMutableArray alloc] init];
        btnWidth = (frame.size.width - btnMargin * (numOfColumnInScreen +1) ) / numOfColumnInScreen;
        btnHeight = (frame.size.height - btnMargin * (numOfRowInScreen +1) ) / numOfRowInScreen;
                               
        [self makeLayerList];
        [self makeGestureRecognizer];
    }
    return self;
}

- (void) makeGestureRecognizer {
    UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressRecognizer.minimumPressDuration = 0.7;
    [_mainScrollView addGestureRecognizer:longPressRecognizer];
    [longPressRecognizer release];
    
//    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    panRecognizer.minimumNumberOfTouches = 1;
//    [self addGestureRecognizer:panRecognizer];
//    [panRecognizer release];
    
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_mainScrollView addGestureRecognizer:tapRecognizer];
    [tapRecognizer release];
}

- (void) makeLayerList {
    [CATransaction setDisableActions:NO];
    for (int i =0; i< [self.data count]; i++) {
        CALayer *layer = [CALayer layer];
        UIImage *image = (UIImage*)[self.data objectForKey:[NSString stringWithFormat:@"%d",i]];
        layer.contents = (id)image.CGImage;
//        layer.backgroundColor = [UIColor redColor].CGColor;
        layer.bounds = CGRectMake(0, 0, btnWidth, btnHeight);
        layer.position = CGPointMake(btnWidth/2 + (btnMargin + btnWidth) * (i%2) + btnMargin , btnHeight/2  + (btnMargin + btnHeight) * (i/2) + btnMargin);
        layer.opacity = 1.0;
        CALayer *closeLayer = [CALayer layer];
        closeLayer.contents = (id)[UIImage imageNamed:@"btn_close.png"].CGImage; 
        closeLayer.bounds = CGRectMake(0, 0, 40, 40);
        closeLayer.position = CGPointMake(btnWidth * 0.25, btnHeight * 0.25);
        closeLayer.opacity = 0.0f;

        [layer addSublayer:closeLayer];
        
        [_mainScrollView.layer addSublayer:layer];
        [_layerList addObject:layer];
        
        CATextLayer *menuItemLayer=[CATextLayer layer]; 
        menuItemLayer.string=[NSString stringWithFormat:@"%d", i]; 
        menuItemLayer.font=@"Lucida-Grande"; 
        menuItemLayer.fontSize= 30.0f; 
        menuItemLayer.foregroundColor=[UIColor orangeColor].CGColor;
        menuItemLayer.bounds = CGRectMake(0, 0, 40, 40);
        menuItemLayer.position = CGPointMake(btnWidth * 0.75, btnWidth * 0.75);
        [layer addSublayer:menuItemLayer];
        
        _mainScrollView.contentSize = CGSizeMake(self.frame.size.width, layer.position.y + btnHeight/2 + btnMargin);
    }
}

- (void) layerOpacityShowAnmiation:(CALayer*)layer {
    [layer setOpacity:1.0f];
}

- (void) playBeginAnimation {
    for (CALayer *layer in _layerList) {
        CGFloat ran = 0.1 * (arc4random()%6);
        [self performSelector:@selector(layerOpacityShowAnmiation:) withObject:layer afterDelay:ran];
    }
}

- (void) drawLayerList {
    CGPoint scrollOffset = [_mainScrollView contentOffset];
    for (int i = 0; i < [_layerList count]; i++) {
        CALayer *layer = [_layerList objectAtIndex:i];
        [CATransaction setDisableActions:NO];
        if (!isEditing) {
            layer.bounds = CGRectMake(0, 0, btnWidth, btnHeight);            
        }
        layer.position = CGPointMake(btnWidth/2  + (btnMargin + btnWidth) * (i%2) + btnMargin , btnHeight/2 + (btnMargin + btnHeight) * (i/2) + btnMargin);
        _mainScrollView.contentSize = CGSizeMake(self.frame.size.width, layer.position.y + btnHeight/2 + btnMargin);
    }
    
    [_mainScrollView setContentOffset:scrollOffset];
}

-(void) dealloc {
    self.didFinishEdit = nil;
    self.selectArticle = nil;
    [_layerList release];
    [super dealloc];
}

#pragma mark - GestureReconizer
- (void) handleTap:(UITapGestureRecognizer *) recognizer {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *) recognizer;
    CGPoint location = [tap locationInView:tap.view];
    if (!isEditing) {
        if (self.selectArticle) {
            self.selectArticle([self layerIndexInPosition:[self layerInPoint:location].position]);            
        }
        return;
    }
    
    if (selectedIndex != -1) {
        ((CALayer*)[_layerList objectAtIndex:selectedIndex]).bounds = CGRectMake(0, 0, btnWidth, btnHeight);
        selectedIndex = -1;        
    }
    
    CALayer *locLayer = [self layerInPoint:location];
    if (locLayer != nil) {
        CGRect closeLayeRect = CGRectMake(locLayer.position.x - btnWidth/2, locLayer.position.y - btnHeight/2, 50, 50);
        if (CGRectContainsPoint(closeLayeRect, location)) {
            [locLayer removeFromSuperlayer];
            [_layerList removeObjectAtIndex:[self layerIndexInPosition:locLayer.position]];
            [self drawLayerList];
            if (_mainScrollView.contentSize.height <= _mainScrollView.frame.size.height) {
                [_mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            return;
        }
    }
    
    isEditing = NO;
    [self closeLayerEnable:isEditing];
    if (self.didFinishEdit) {
        self.didFinishEdit();
    }
}

- (void) handleLongPress:(UILongPressGestureRecognizer *)recognizer {
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *) recognizer;
    CGPoint location = [longPress locationInView:longPress.view];
        
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        if (selectedIndex != -1) {
            ((CALayer*)[_layerList objectAtIndex:selectedIndex]).bounds = CGRectMake(0, 0, btnWidth, btnHeight);
        }
        CALayer *layer = [self layerInPoint:location];
        if (layer != nil) {
            isEditing = YES;
            [self closeLayerEnable:isEditing];
            selectedIndex = [self layerIndexInPosition:layer.position];
            layer.bounds = CGRectMake(0, 0, btnWidth * 1.05f, btnHeight * 1.05f);
            [layer removeFromSuperlayer];
            [_mainScrollView.layer addSublayer:layer];
        }
    }
    //    NSLog(@"recognizer state : %d, layer position:%@", recognizer.state, NSStringFromCGPoint(layer.position));
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self moveSelectedLayerToLocation:location];
    } else if (recognizer.state == UIGestureRecognizerStateEnded){
        if (selectedIndex != -1) {
            CALayer *layer = [_layerList objectAtIndex:selectedIndex];
            [self changePosition:layer];
            layer.bounds = CGRectMake(0, 0, btnWidth, btnHeight);
            selectedIndex = -1;
        }
    }
}

- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    if (!isEditing || selectedIndex == -1) {
        return;
    }
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer*)recognizer;
    CGPoint location = [pan locationInView:_mainScrollView];
    
    if (location.y > _mainScrollView.contentSize.height) {
        return;
    }

    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        [self moveSelectedLayerToLocation:location];
    } else if (recognizer.state == UIGestureRecognizerStateEnded){
        CALayer *layer = [_layerList objectAtIndex:selectedIndex];
        [self changePosition:layer];
    }
}

- (void) closeLayerEnable:(BOOL)enable {
    for (CALayer *layer in _layerList) {
        for (CALayer *subLayer in [layer sublayers]) {
            if (![subLayer isKindOfClass:[CATextLayer class]]) {
                if (enable) {
                    subLayer.opacity = 1.0f;                
                } else {
                    subLayer.opacity = 0.0f;                
                }
            }
        }
    }
}

- (void) movePositionInTransaction:(CALayer *)layer location:(CGPoint)location duration:(CGFloat) duration {
    [CATransaction setValue:[NSNumber numberWithFloat:duration] forKey:kCATransactionAnimationDuration];
    layer.position = CGPointMake(location.x, location.y);
    [CATransaction setValue:[NSNumber numberWithFloat:0.25] forKey:kCATransactionAnimationDuration];
}

- (void) moveSelectedLayerToLocation:(CGPoint) location {
    CALayer *layer = [_layerList objectAtIndex:selectedIndex];
    CGRect layerFrame = CGRectMake(layer.position.x - btnWidth/2, layer.position.y - btnHeight/2, btnWidth, btnHeight);
    if (!CGRectContainsPoint(layerFrame, location)) {
        return;
    }
    [self movePositionInTransaction:layer location:location duration:0.01];
    CGFloat scrollBottomPointY = [_mainScrollView contentOffset].y + [_mainScrollView frame].size.height;
    if (scrollBottomPointY < (layer.position.y + btnHeight/2) && layer.position.y  < _mainScrollView.contentSize.height) {

        if (scrollBottomPointY+ btnHeight < _mainScrollView.contentSize.height) {
            [self movePositionInTransaction:layer location:location duration:0.01];
            [_mainScrollView setContentOffset:CGPointMake(0, _mainScrollView.contentOffset.y + btnHeight) animated:YES];            
        } else {
            [_mainScrollView setContentOffset:CGPointMake(0, _mainScrollView.contentSize.height -_mainScrollView.frame.size.height) animated:YES];            
        }
    } else if ([_mainScrollView contentOffset].y > (layer.position.y - btnHeight/2) && layer.position.y > 0) {
        if (layer.position.y - btnHeight > 0) {
            [self movePositionInTransaction:layer location:location duration:0.01];
            [_mainScrollView setContentOffset:CGPointMake(0, _mainScrollView.contentOffset.y - btnHeight) animated:YES];            
        } else {
            [_mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];            
        }
    } else {
        if (selectedIndex != [self targetLayerIndexWithPoint:layer.position]) {
            [self changePosition:layer];
        }
    }
}

- (void) changePosition:(CALayer *) layer {
    NSInteger movedIndex = [self targetLayerIndexWithPoint:layer.position];
    CALayer *selectedLayer = [_layerList objectAtIndex:selectedIndex];
    [_layerList removeObjectAtIndex:selectedIndex];
    [_layerList insertObject:selectedLayer atIndex:movedIndex];
    
    [self drawLayerList];
    selectedIndex = movedIndex;
}

- (NSInteger) targetLayerIndexWithPoint:(CGPoint) point {
    for (int i = 0; i < [_layerList count]; i++) {
        if (i == selectedIndex) {
            continue;
        }
        point.y = MAX(btnMargin, point.y);
        point.y = MIN(_mainScrollView.contentSize.height - btnMargin, point.y);
        CALayer *layer = [_layerList objectAtIndex:i];
        CGRect layerFrame = CGRectMake(layer.position.x - btnWidth/2, layer.position.y - btnHeight/2, btnWidth, btnHeight);

        if (CGRectContainsPoint(layerFrame, point)) {
            return i;
        }
    }
    return selectedIndex;
}

- (CALayer *) layerInPoint:(CGPoint)point {
    for (int i = 0; i < [_layerList count]; i++) {
        CALayer *layer = [_layerList objectAtIndex:i];
        CGRect layerFrame = CGRectMake(layer.position.x - btnWidth/2, layer.position.y - btnHeight/2, btnWidth, btnHeight);
        if (CGRectContainsPoint(layerFrame, point)) {
            return layer;
        }
    }
    return nil;
}

- (NSInteger) layerIndexInPosition:(CGPoint) position {
    for (int i = 0; i < [_layerList count]; i++) {
        CALayer *listLayer = [_layerList objectAtIndex:i];
        if (CGPointEqualToPoint(listLayer.position, position)) {
            return i;
        }
    }
    return -1;
}

@end
