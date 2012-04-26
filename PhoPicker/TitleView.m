//
//  TitleView.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 19..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import "TitleView.h"
@interface TitleView()
- (void) makeTitleView;
- (void) makeRightBtn;
- (void) makeLeftBtn;
@end
@implementation TitleView
@synthesize leftBtnTitle = _leftBtnTitle, rightBtntitle = _rightBtnTitle;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        [self makeTitleView];
//        [self makeRightBtn];
        [self makeLeftBtn];
    }
    return self;
}

- (void) dealloc {
    [_leftBtnTitle release];
    [_rightBtnTitle release];
    [super dealloc];
}

- (void) makeTitleView {
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_titleLabel];
    [_titleLabel release];
}

- (void) makeLeftBtn {
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(20, 5, 40, self.frame.size.height - 10);
    [_leftBtn setTitle:@"이전" forState:UIControlStateNormal];
    [self addSubview:_leftBtn];
    _leftBtn.hidden = YES;
}

- (void) setLeftBtnSelector:(SEL)selector {
    _leftBtn.hidden = NO;
    [_leftBtn addTarget:nil action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void) setTitle:(NSString *)title {
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:13.0f]];
    [_titleLabel setText:title];
    [_titleLabel setFrame:CGRectMake((self.frame.size.width - titleSize.width) /2, 0, titleSize.width, self.frame.size.height)];
}

@end
