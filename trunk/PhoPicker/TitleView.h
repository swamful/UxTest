//
//  TitleView.h
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 19..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleView : UIView {
    UILabel *_titleLabel;
    UIButton *_leftBtn;
    UIButton *_rightBtn;
    
    NSString *_leftBtnTitle;
    NSString *_rightBtnTitle;
}

- (void) setTitle:(NSString*) title;
- (void) setLeftBtnSelector:(SEL) selector;
@property (nonatomic, retain) NSString *leftBtnTitle;
@property (nonatomic, retain) NSString *rightBtntitle;
@end
