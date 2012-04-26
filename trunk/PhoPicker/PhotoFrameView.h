//
//  PhotoFrameView.h
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 12..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAPIXMLParser.h"
#import "UIConstants.h"
@interface PhotoFrameView : UIView {
    NSInteger frameHeight;
    CGPoint _offset;
    NSMutableArray *indexList;
}
@property (nonatomic) NSInteger frameHeight;
@property (nonatomic) CGPoint offset;
@property (nonatomic,retain) NSMutableArray *indexList;
- (void) makeButtonDown:(PhotoAPIParserModel *) parserModel;
- (NSInteger) visibleStartIndex;
@end
