//
//  PhotoFrameButtonView.h
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 12..
//

#import <UIKit/UIKit.h>

@interface PhotoFrameButtonView : UIButton {
    NSInteger index;
    BOOL _isFirstFrame;
    UIActivityIndicatorView *indicator;
}

@property(nonatomic) NSInteger index;
@property(nonatomic) BOOL isFirstFrame;
- (void)showIndicator;
- (void)hideIndicator;
@end
