//
//  BlurView.h
//  PhoPicker
//
//  Created by 승필 백 on 13. 3. 6..
//  Copyright (c) 2013년 NHN Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlurView : UIView {
    CALayer *titleLayer;
    CAShapeLayer *lightLayer;
    NSMutableArray *_bevelLayerList;
}

@end
