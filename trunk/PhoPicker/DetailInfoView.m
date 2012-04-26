//
//  DetailInfoView.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 26..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import "DetailInfoView.h"
@interface DetailInfoView()
- (void) makeTagView;
- (void) makeTextView;
@end
@implementation DetailInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeTagView];
        [self makeTextView];
    }
    return self;
}

- (void) makeTagView {
    UILabel *tagTitlaView = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, 60, 20)];
    tagTitlaView.text = @"@Tag";
    tagTitlaView.font = [UIFont fontWithName:@"TrebuchetMS-Italic" size:14.0f];
    [self addSubview:tagTitlaView];
    [tagTitlaView release];
}

- (void) makeTextView {
    _tagTextView = [[UILabel alloc] initWithFrame:CGRectMake(35, 30, 270, 20)];
    _tagTextView.font = [UIFont systemFontOfSize:13.0f];
    [self addSubview:_tagTextView];
    [_tagTextView release];
}

- (void) setTagText:(NSString *)tagText {
    _tagTextView.text = tagText;
}
@end
