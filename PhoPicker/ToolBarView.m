//
//  ToolBarView.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 19..
//

#import "ToolBarView.h"

@interface ToolBarView() 
- (void) makeLeftBtn;
- (void) makeRightBtn;
@end
@implementation ToolBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeLeftBtn];
        [self makeRightBtn];
    }
    return self;
}

- (void) makeLeftBtn {
    
}

- (void) makeRightBtn {
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(self.frame.size.width / 2, 0, self.frame.size.width / 2, self.frame.size.height);
    [_rightBtn setTitle:@"사진찍기" forState:UIControlStateNormal];
    [_rightBtn addTarget:nil action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightBtn];
}

@end
