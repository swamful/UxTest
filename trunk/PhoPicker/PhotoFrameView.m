//
//  PhotoFrameView.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 12..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import "PhotoFrameView.h"
#import "PhotoFrameButtonView.h"
#import "AppUtility.h"
@interface PhotoFrameView()
- (PhotoFrameButtonView*) invisibleButtonFromCurrentPoint;
@end
@implementation PhotoFrameView
@synthesize frameHeight, offset = _offset, indexList;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (int i = 1; i < 35; i++) {
            PhotoFrameButtonView *frameButton = [[PhotoFrameButtonView alloc] init];
            frameButton.tag = i;
            frameButton.enabled = NO;
            frameButton.frame = CGRectMake(0, 0, listFrameWidth, 0);
            [frameButton addTarget:nil action:@selector(getLargePhoto:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:frameButton];
        }
        indexList = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void) dealloc {
    [indexList release];
    [super dealloc];
}

- (NSInteger) frameHeight {
    return self.frame.size.height + self.frame.origin.y;
}

- (PhotoFrameButtonView *) getFrameButton {
    for (int i = 1; i < 35; i++) {
        PhotoFrameButtonView *frameButton = (PhotoFrameButtonView*)[self viewWithTag:i];
        if (!frameButton.enabled) {
            frameButton.enabled = YES;
            return frameButton;
        }
    }
    return [self invisibleButtonFromCurrentPoint];
}

- (PhotoFrameButtonView*) invisibleButtonFromCurrentPoint {
    NSInteger farTag;
    NSInteger distance = 0;
    for (int i = 1; i < 35; i++) {
        PhotoFrameButtonView *frameButton = (PhotoFrameButtonView*)[self viewWithTag:i];
        if ((_offset.y - (self.frame.origin.y + frameButton.frame.origin.y)) > distance) {
            farTag = i;
            distance = abs(frameButton.frame.origin.y - _offset.y);            
        }         
    }
    NSLog(@"return tag :%d", farTag);
    PhotoFrameButtonView *frameButton = (PhotoFrameButtonView*)[self viewWithTag:farTag];
    CGRect frame = self.frame;
    frame.origin.y =  frame.origin.y + frameButton.frame.size.height;
    self.frame = frame;
    return frameButton;
}

- (void) makeButtonDown:(PhotoAPIParserModel *) parserModel {
    PhotoFrameButtonView *frameButton = [self getFrameButton];
    frameButton.index = [parserModel index];
    [indexList addObject:[NSNumber numberWithInt:[parserModel index]]];
    CGSize orgSize = CGSizeMake([[parserModel sizeWidth] intValue], [[parserModel sizeHeight] intValue]);
    NSInteger imgHeight = (orgSize.height * listFrameWidth) /orgSize.width;
    frameButton.frame = CGRectMake(0, self.frame.size.height, listFrameWidth, imgHeight);
    NSLog(@"framebtn :%@", NSStringFromCGRect(frameButton.frame));
    frameButton.backgroundColor = [UIColor blackColor];
    [frameButton setImageInBackground:[parserModel thumbnail] forState:UIControlStateNormal];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, listFrameWidth, self.frame.size.height + imgHeight); 
}

- (NSInteger) visibleStartIndex {
    for (int i = 1; i < 35; i++) {
        PhotoFrameButtonView *frameButton = (PhotoFrameButtonView*)[self viewWithTag:i];
        NSLog(@"offset : %f framebutton :%@", _offset.y, NSStringFromCGRect(frameButton.frame));
        if (_offset.y >= (frameButton.frame.origin.y + self.frame.origin.y)&& _offset.y <= (frameButton.frame.size.height + self.frame.origin.y)) {
            return frameButton.index;
        }         
    }
    return 1;
}

@end
