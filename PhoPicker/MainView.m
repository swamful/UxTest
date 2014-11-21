//
//  MainView.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 9. 21..
//

#import "MainView.h"
#import "XMovieUpView.h"
@implementation MainView
@synthesize text;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 180, 50)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"0~13 까지 중 고르세요";
        [self addSubview:label];
        [label release];
        
        text = [[UITextField alloc] initWithFrame:CGRectMake(220, 50, 50, 30)];
        text.borderStyle = UITextBorderStyleBezel;
        text.delegate = self;
        text.keyboardType = UIKeyboardTypeNumberPad;
        text.returnKeyType = UIReturnKeyDone;
        [self addSubview:text];
        [text release];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(280, 50, 30, 30);
        [btn setTitle:@"go" forState:UIControlStateNormal];
        [btn addTarget:nil action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];

    }
    return self;
}

- (void) dealloc {
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
