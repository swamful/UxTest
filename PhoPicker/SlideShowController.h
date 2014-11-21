//
//  SlideShowController.h
//  PhoPicker
//
//  Created by 백 승필 on 12. 8. 7..
//

#import <UIKit/UIKit.h>
#import "SlideShowView.h"
@interface SlideShowController : UIViewController <UIGestureRecognizerDelegate> {
    UIView *_topView;
    UIView *_bottomView;
    UIView *_pannelView;
    UIButton *_closeBtn;
    
    SlideShowView *showView;
}

- (void) slideStart;
- (void) slideStop;

@end
