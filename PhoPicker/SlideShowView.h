//
//  SlideShowView.h
//  PhoPicker
//
//  Created by 백 승필 on 12. 8. 7..
//

#import <UIKit/UIKit.h>

@interface SlideShowView : UIView {
    NSMutableArray *_layerList;
    NSInteger imageIndexCount;
}
- (void) triggerSlideAnimation;
- (void) stopAnimation;
@end
