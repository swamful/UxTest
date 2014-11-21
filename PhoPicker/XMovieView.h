//
//  XMovieView.h
//  PhoPicker
//
//  Created by 백 승필 on 12. 9. 13..
//

#import <UIKit/UIKit.h>

@interface XMovieView : UIView <UIGestureRecognizerDelegate> {
    NSInteger index;
    CGPoint forePoint;
    NSMutableArray *_layerList;
    
    UIButton *btn;
    
    BOOL isGestureMode;
}

@end
