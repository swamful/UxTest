//
//  SlideSlingView.h
//  PhoPicker
//
//  Created by 백 승필 on 12. 8. 13..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideSlingView : UIView <UIScrollViewDelegate>{
    CALayer *_mainLayer;
    CALayer *_leftLayer;
    CALayer *_rightLayer;
    CGFloat leftLayerBasicPositionX;
    CGFloat rightLayerBasicPositionX;
    NSDictionary *_data;
    
    UIScrollView *_mainScrollView;
    CGFloat btnWidth;
    CGFloat forePoint;
}

- (id) initWithFrame:(CGRect)frame withData:(NSDictionary*) data;

@property (nonatomic, assign) NSDictionary *data;
@end
