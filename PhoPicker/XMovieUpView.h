//
//  XMovieUpView.h
//  PhoPicker
//
//  Created by 백 승필 on 12. 9. 19..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMovieUpView : UIView <UIGestureRecognizerDelegate> {
    NSInteger _startIndex;
    CGFloat initY;
    CGPoint forePoint;
    NSMutableArray *_layerList;
    NSMutableArray *_viewList;
    
    UILabel *descLabel;
    BOOL isAnimating;
    CALayer *checkLayer;
    NSInteger twistIndex;
    CGPoint foreDirection;
}
@property (nonatomic) NSInteger startIndex;

@end
