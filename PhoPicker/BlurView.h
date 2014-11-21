//
//  BlurView.h
//  PhoPicker
//
//  Created by 승필 백 on 13. 3. 6..
//

#import <UIKit/UIKit.h>

@interface BlurView : UIView {
    CALayer *titleLayer;
    CAShapeLayer *lightLayer;
    NSMutableArray *_bevelLayerList;
}

@end
