//
//  CameraContextMenuView.m
//  NaverSearch
//
//  Created by 백 승필 on 12. 4. 3..
//

#import "CameraContextMenuView.h"
#import <MobileCoreServices/UTCoreTypes.h>

#define typeCamera 1
#define typeAlbum 0
@implementation CameraContextMenuView
@synthesize albumTitle = _albumTitle, cameraTitle = _cameraTitle;
@synthesize delegate = _delegate;

- (id) init {
    self = [super init];
    if (self) {
        self.albumTitle = @"앨범에서 가져오기";
        self.cameraTitle = @"카메라 찍기";
        _isSaveAfterTakePicture = NO;
    }
    return self;
}

- (void) setDelegate:(id<CameraContextMenuViewDelegate>)delegate {
    if (delegate == nil) {
        _parentViewController = nil;
        _showingView = nil;
        _delegate = nil;
    } else if (![delegate isKindOfClass:[UIViewController class]]) {
        NSLog(@"error : A Delegate class is not kind of UIViewController!!");
        return;
    } 

    _parentViewController = (UIViewController*) delegate;
    _showingView = _parentViewController.view;
    _delegate = delegate;
    [_showingView addSubview:self];
}

- (void) dealloc {
    NSLog(@"dealloc");
    [_albumTitle release];
    [_cameraTitle release];
    [super dealloc];
}

- (void) setSaveAfterTakePicture:(BOOL) isSave {
    _isSaveAfterTakePicture = isSave;
}

- (void) show {
    if (_delegate == nil) {
        return;
    }
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self 
                                              cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	sheet.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
    [sheet addButtonWithTitle:_albumTitle];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
    {
        [sheet addButtonWithTitle:_cameraTitle];
        sheet.cancelButtonIndex = 2;
    }
    else
        sheet.cancelButtonIndex = 1;
    
	[sheet addButtonWithTitle:@"취소"];
	
	sheet.actionSheetStyle = UIActionSheetStyleDefault;
	[sheet showInView:_showingView];
	[sheet release];
}

- (void)showImagePicker:(int)type {
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	
	if ( type == typeAlbum )
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; 
	else
		picker.sourceType = UIImagePickerControllerSourceTypeCamera; 
	
	picker.delegate = self; 
	
	[_parentViewController presentModalViewController:picker animated:YES];	
	[picker release];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	NSString *obj = [info objectForKey:@"UIImagePickerControllerMediaType"];
	if ( [obj isEqualToString:(NSString *)kUTTypeImage] ) {
		UIImage* myImage = [info objectForKey:UIImagePickerControllerOriginalImage];
		if (_isSaveAfterTakePicture && picker.sourceType == UIImagePickerControllerSourceTypeCamera ) {
			UIImageWriteToSavedPhotosAlbum(myImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(imageAfterTakePicture:)]) {
            [_delegate imageAfterTakePicture:myImage];
        }
	} 
    
    [picker dismissModalViewControllerAnimated:YES];
    if (!_isSaveAfterTakePicture) {
        [self removeFromSuperview];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error != nil) {
        NSLog(@"error : %@", error);
    }
    [self removeFromSuperview];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        switch (buttonIndex) {
            case 0:
                [self showImagePicker:typeAlbum];
                break;
            case 1:
                [self showImagePicker:typeCamera];
                break;
            default:
                break;
        }    
        
    }
}


@end
