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
@implementation PhotoFrameView
@synthesize frameHeight, btnDictionary = _btnDictionary;

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _btnDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) dealloc {
    [_btnDictionary release];
    [super dealloc];
}

- (NSInteger) frameHeight {
    return self.frame.origin.y + self.frame.size.height;
}

- (PhotoFrameButtonView *) getFrameButton {
    PhotoFrameButtonView *frameButton = [PhotoFrameButtonView buttonWithType:UIButtonTypeCustom];
    frameButton.backgroundColor = [UIColor blackColor];
    [frameButton addTarget:nil action:@selector(getLargePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:frameButton];
    return frameButton;
}

- (void) makeButtonDown:(PhotoAPIParserModel *) parserModel {
    PhotoFrameButtonView *frameButton = [self getFrameButton];
    frameButton.index = [parserModel index];
    [_btnDictionary setObject:frameButton forKey:[NSString stringWithFormat:@"%d", frameButton.index]];
    CGSize orgSize = CGSizeMake([[parserModel sizeWidth] intValue], [[parserModel sizeHeight] intValue]);
    NSInteger imgHeight = (orgSize.height * listFrameWidth) /orgSize.width;
    frameButton.frame = CGRectMake(0, self.frameHeight, listFrameWidth, imgHeight);
    [frameButton showIndicator];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, listFrameWidth, self.frameHeight + imgHeight); 
}

- (void) setImage:(PhotoAPIParserModel *) parserModel {
    PhotoFrameButtonView *frameButton = [_btnDictionary objectForKey:[NSString stringWithFormat:@"%d", parserModel.index]];
    [frameButton hideIndicator];
    [frameButton setBackgroundImage:[parserModel downloadImage] forState:UIControlStateNormal];
}

@end
