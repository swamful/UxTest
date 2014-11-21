//
//  CameraContextMenuView.h
//  NaverSearch
//
//  Created by 백 승필 on 12. 4. 3..
//

#import <Foundation/Foundation.h>
@protocol CameraContextMenuViewDelegate;
@interface CameraContextMenuView : UIView <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    id <CameraContextMenuViewDelegate> _delegate;
    NSString *_albumTitle;
    NSString *_cameraTitle;
    UIView *_showingView;
    BOOL _isSaveAfterTakePicture;
    UIViewController* _parentViewController;
}

@property (nonatomic, assign) id <CameraContextMenuViewDelegate> delegate;
@property (nonatomic, assign) NSString *albumTitle;
@property (nonatomic, assign) NSString *cameraTitle;

- (void) show;
- (void) setSaveAfterTakePicture:(BOOL) isSave;
@end

@protocol CameraContextMenuViewDelegate <NSObject>
- (void) imageAfterTakePicture:(UIImage *) image;
@end