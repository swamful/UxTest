//
//  BubbleShowView.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 8. 31..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import "BubbleShowView.h"
#import "BubbleView.h"
@implementation BubbleShowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panRecognizer.minimumNumberOfTouches = 1;
        [self addGestureRecognizer:panRecognizer];
        [panRecognizer release];
        
        UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tapRecognizer];
        [tapRecognizer release];
        count = 0;
        

    }
    return self;
}



- (void) makeCircleInPosition:(CGPoint) position {
    count ++;
    NSLog(@"count :%d", count);
    BubbleView *view = [[BubbleView alloc] initWithPosition:position];
    [self addSubview:view];
    [view release];
    

    

    


}

#pragma mark - GestureReconizer
- (void) handleTap:(UITapGestureRecognizer *) recognizer {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *) recognizer;
    CGPoint location = [tap locationInView:tap.view];
    

    [self makeCircleInPosition:location];


    

}



- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer*)recognizer;
    CGPoint location = [pan locationInView:pan.view];
    
    [self makeCircleInPosition:location];
}

@end
