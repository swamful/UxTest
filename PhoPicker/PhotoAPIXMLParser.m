//
//  PhotoAPIXMLParser.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 12..
//

#import "PhotoAPIXMLParser.h"

@implementation PhotoAPIParserModel
@synthesize title = _title, lastBuildDate = _lastBuildDate, total = _total, 
            start = _start, display = _display, item = _item, link = _link, thumbnail = _thumbnail, sizeHeight = _sizeHeight, sizeWidth = _sizeWidth, index, downloadImage = _downloadImage;

- (void) dealloc {
    [_title release];
    [_lastBuildDate release];
    [_total release];
    [_start release];
    [_display release];
    [_item release];
    [_link release];
    [_thumbnail release];
    [_sizeHeight release];
    [_sizeWidth release];
    [_downloadImage release];
    [super dealloc];
}

@end

@interface PhotoAPIXMLParser(PrivateMethod)
- (void) didFinishParsing:(PhotoAPIParserModel *)result;
- (void) didFailParsing:(NSError *)error;
@end
@implementation PhotoAPIXMLParser
@synthesize delegate = _delegate, resultModel = _resultModel;

static NSString * const kEntryElementName = @"item";
static NSString * const kTitleElementName = @"title";
static NSString * const kLinkElementName = @"link";
static NSString * const kImageElementName = @"image";
static NSString * const kThumbnailElementName = @"thumbnail";
static NSString * const kSizeHeightElementName = @"sizeheight";
static NSString * const kSizeWidthElementName = @"sizewidth";
static NSString * const kHeightElementName = @"height";
static NSString * const kWidthElementName = @"width";
static NSString * const kTotalElementName = @"total";

- (void) parseAPIResultString:(NSString *)string    {
    NSRange stringRange = [string rangeOfString:@"euc-kr" options:NSCaseInsensitiveSearch];
    if (stringRange.length > 0) {
        string = [string stringByReplacingOccurrencesOfString:@"euc-kr" withString:@"UTF-8" options:NSCaseInsensitiveSearch range:stringRange];
    }
    NSData *parsingData = [string dataUsingEncoding:NSUTF8StringEncoding];        
    [NSThread detachNewThreadSelector:@selector(parseAPIResult:) toTarget:self withObject:parsingData];
}
- (void) didFinishParsing:(PhotoAPIParserModel *)resultData    {
    if (_delegate && [_delegate respondsToSelector:@selector(photoAPIParser:didSuccessParse:)]) {
        [_delegate photoAPIParser:self didSuccessParse:resultData];
    }
}
- (void) didFailParsing:(NSError *)error    {
    if (_delegate && [_delegate respondsToSelector:@selector(photoAPIParser:didFailParse:)]) {
        [_delegate photoAPIParser:self didFailParse:error];
    }
}

- (void) parseAPIResult:(NSData *)data    {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    if(_resultModel)    [_resultModel release];
    _resultModel = nil;
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser parse];
    
    [parser release];
    [pool release];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if( [elementName isEqualToString:kEntryElementName] )  {
        if (_resultModel) {
            [_resultModel release];
        }
        _resultModel = [[PhotoAPIParserModel alloc] init];
        _currentElementValue = ParsingElementEntry;
        
    }  else if( [elementName isEqualToString:kTotalElementName] )  {
        if (_resultModel) {
            [_resultModel release];
        }
        _resultModel = [[PhotoAPIParserModel alloc] init];
        _currentElementValue = ParsingElementTotal;
        
    }  else if( [elementName isEqualToString:kTitleElementName]) {
        _currentElementValue = ParsingElementTitle;
        
    }   else if( [elementName isEqualToString:kLinkElementName] || [elementName isEqualToString:kImageElementName]) {
        _currentElementValue = ParsingElementLink;
        
    }   else if( [elementName isEqualToString:kThumbnailElementName]) {
        _currentElementValue = ParsingElementThumbnail;
        
    }   else if( [elementName isEqualToString:kSizeHeightElementName] || [elementName isEqualToString:kHeightElementName]) {        
        _currentElementValue = ParsingElementSizeHeight;
        
    }   else if( [elementName isEqualToString:kSizeWidthElementName] || [elementName isEqualToString:kWidthElementName]) {        
        _currentElementValue = ParsingElementSizewidth;
        
    }   else   {
        _currentElementValue = ParsingElementUndefine;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {     
    if ([elementName isEqualToString:kEntryElementName])    {
        if ( [self respondsToSelector:@selector(didFinishParsing:)] && _resultModel != nil) {
            [self performSelectorOnMainThread:@selector(didFinishParsing:) withObject:self.resultModel waitUntilDone:NO];
            
        }   else if([self respondsToSelector:@selector(didFailParsing:)]) {
            [self performSelectorOnMainThread:@selector(didFailParsing:) withObject:nil waitUntilDone:NO];
        }
    } else if ([elementName isEqualToString:kTotalElementName]) {
        if ( [self respondsToSelector:@selector(didFinishParsing:)] && _resultModel != nil) {
            [self performSelectorOnMainThread:@selector(didFinishParsing:) withObject:self.resultModel waitUntilDone:NO];
        }
    }
    _currentElementValue = ParsingElementUndefine;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {

    if (_resultModel == nil) return;    
    switch (_currentElementValue) {
        case ParsingElementTitle:
            _resultModel.title = string;
            break;
        case ParsingElementLink:            
            _resultModel.link = string;
            break;
        case ParsingElementThumbnail:
            _resultModel.thumbnail = string;
            break;
        case ParsingElementSizeHeight:
            _resultModel.sizeHeight = string;
            break;
        case ParsingElementSizewidth:
            _resultModel.sizeWidth = string;
            break;
        case ParsingElementTotal:
            _resultModel.total = string;
            break;
        default:
            break;
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if ([self respondsToSelector:@selector(didFailParsing:)]) {
        [self performSelectorOnMainThread:@selector(didFailParsing:) withObject:parseError waitUntilDone:NO];
    }
}
- (void)dealloc {
    [_resultModel release];
    [super dealloc];
}

@end
