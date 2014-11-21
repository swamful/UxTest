//
//  RotationView.h
//  PhoPicker
//
//  Created by 백 승필 on 12. 9. 6..
//

#import <UIKit/UIKit.h>

@interface RotationView : UIView <UIGestureRecognizerDelegate, UIWebViewDelegate> {
    UIView *rotateView;
    CGPoint forePoint;
    NSMutableArray *layerList;
    
    UILabel *descLabel;
}
@end
