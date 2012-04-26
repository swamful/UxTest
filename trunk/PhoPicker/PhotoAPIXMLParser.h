//
//  PhotoAPIXMLParser.h
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 12..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import <Foundation/Foundation.h>
enum {
    ParsingElementUndefine = -1,
    ParsingElementEntry = 0,
    ParsingElementLastBuildDate = 1,
    ParsingElementTotal = 2,
    ParsingElementStart = 3,
    ParsingElementDisplay = 4,
    ParsingElementItem = 5,
    ParsingElementTitle = 6,
    ParsingElementLink = 7,
    ParsingElementThumbnail = 8,
    ParsingElementSizeHeight = 9,
    ParsingElementSizewidth = 10,
};
typedef NSUInteger ParsingElement;

@interface PhotoAPIParserModel : NSObject {
    NSString *_lastBuildDate;
    NSString *_total;
    NSString *_start;
    NSString *_display;
    NSString *_item;
    NSString *_title;
    NSString *_link;
    NSString *_thumbnail;
    NSString *_sizeHeight;
    NSString *_sizeWidth;
    NSString *_tagText;
    NSInteger index;
}

@property (nonatomic, retain) NSString *lastBuildDate;
@property (nonatomic, retain) NSString *total;
@property (nonatomic, retain) NSString *start;
@property (nonatomic, retain) NSString *display;
@property (nonatomic, retain) NSString *item;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *thumbnail;
@property (nonatomic, retain) NSString *sizeHeight;
@property (nonatomic, retain) NSString *sizeWidth;
@property (nonatomic, retain) NSString *tagText;
@property (nonatomic) NSInteger index;
@end


@protocol PhotoAPIParserDelegate;

@interface PhotoAPIXMLParser : NSObject <NSXMLParserDelegate> {
    id<PhotoAPIParserDelegate> _delegate;
    PhotoAPIParserModel *_resultModel;
    ParsingElement _currentElementValue;
}

@property (nonatomic, assign) id<PhotoAPIParserDelegate> delegate;
@property (nonatomic, readonly) PhotoAPIParserModel *resultModel;

- (void) parseAPIResultString:(NSString *)string;
@end

@protocol PhotoAPIParserDelegate <NSObject>
- (void)photoAPIParser:(PhotoAPIXMLParser *)parser didSuccessParse:(PhotoAPIParserModel *) parserResult;
- (void)photoAPIParser:(PhotoAPIXMLParser *)parser didFailParse:(NSError *) parserError;
@end
