//
//  SlideSlingGestureView.h
//  PhoPicker
//
//  Created by 백 승필 on 12. 8. 14..
//

#import <UIKit/UIKit.h>

typedef enum {
    SIDE = 0,
    MEDIUM,
    CENTER, 
} SlideLayerPosition;

@interface SlideSlingGestureView : UIView <UIGestureRecognizerDelegate>{
    CALayer *_leftLayer;
    CALayer *_rightLayer;
    CGFloat leftLayerBasicPositionX;
    CGFloat rightLayerBasicPositionX;
    NSDictionary *_data;
    
    CGFloat btnWidth;
    CGFloat forePoint;
    
    CGFloat foreDeltaX;
    
    NSMutableArray *_rightTextLayerList;
    NSMutableArray *_leftTextLayerList;
    NSInteger centerIndex;
    
    void (^_didFinishSelect)(NSInteger index);
}
- (id) initWithFrame:(CGRect)frame withData:(NSDictionary*) data;
- (void) moveSlideAtIndex:(NSInteger) index;
@property (nonatomic, assign) NSDictionary *data;
@property (nonatomic, copy) void (^didFinishSelect)(NSInteger index);
@end
