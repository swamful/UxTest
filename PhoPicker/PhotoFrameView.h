//
//  PhotoFrameView.h
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 12..
//

#import <UIKit/UIKit.h>
#import "PhotoAPIXMLParser.h"
#import "UIConstants.h"
@interface PhotoFrameView : UIView {
    NSInteger frameHeight;
    NSMutableDictionary *_btnDictionary;
}
@property (nonatomic) NSInteger frameHeight;
@property (nonatomic, readonly) NSMutableDictionary *btnDictionary;
- (void) makeButtonDown:(PhotoAPIParserModel *) parserModel;
- (void) setImage:(PhotoAPIParserModel *) parserModel;
@end
