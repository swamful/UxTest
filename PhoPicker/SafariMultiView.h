//
//  SafariMultiView.h
//  PhoPicker
//
//  Created by 승필 백 on 13. 6. 11..
//  Copyright (c) 2013년 NHN Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@interface SafariMultiView : UIView {
    CGPoint _beforePoint;
    NSMutableArray *_layerList;
    CGFloat _rotateAngle;
    NSInteger _currentIndex;
    CGFloat _firstPositionY;
    CGFloat _finalPositionY;
    
    NSInteger _maxCount;
    
    CALayer *_touchedLayer;
    BOOL isMovingWidth;
}

@end
