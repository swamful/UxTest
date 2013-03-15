//
//  MeHomeGridView.h
//  NaverSearch
//
//  Created by 백 승필 on 12. 8. 9..
//  Copyright (c) 2012 NHN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MeHomeGridView : UIView <UIGestureRecognizerDelegate>{
    NSDictionary *_data;
    NSMutableArray *_layerList;
    CGFloat btnHeight;
    CGFloat btnWidth;
    UIScrollView *_mainScrollView;
    
    NSInteger selectedIndex;
    BOOL isEditing;
    
    void (^_didFinishEdit)();
    void (^_selectArticle)(NSInteger index);
}

@property (nonatomic, assign) NSDictionary *data;
@property (nonatomic, copy) void (^didFinishEdit)();
@property (nonatomic, copy) void (^selectArticle)(NSInteger index);

- (id)initWithFrame:(CGRect)frame withTileData:(NSDictionary *) dic;

@end
