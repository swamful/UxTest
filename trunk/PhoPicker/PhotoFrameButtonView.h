//
//  PhotoFrameButtonView.h
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 12..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoFrameButtonView : UIButton {
    NSString *_linkUrl;
    UIControlState controlState;
    NSInteger index;
    UIActivityIndicatorView *indicator;
}

@property(nonatomic, retain) NSString *linkUrl;
@property(nonatomic) NSInteger index;
- (void) setImageInBackground:(NSString *)linkUrl forState:(UIControlState)state;

@end
