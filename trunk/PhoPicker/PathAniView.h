//
//  PathAniView.h
//  PhoPicker
//
//  Created by 승필 백 on 13. 3. 14..
//  Copyright (c) 2013년 NHN Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PathAniView : UIView {
    CALayer *_mainLayer;
    NSMutableArray *_btnList;
    BOOL _isEnableRotate;
    UIButton *_startBtn;
    UIButton *_pathAniBtn;
    BOOL _needBegin;
}

@end
