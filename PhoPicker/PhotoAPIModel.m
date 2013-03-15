//
//  PhotoAPIModel.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 12..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import "PhotoAPIModel.h"
#import "PhotoAPIXMLParser.h"
#define naverApi @"http://openapi.naver.com/search?key=039cc334a00d8f3a13703ff0f7125dc5"
#define daumApi @"http://apis.daum.net/search/image?apikey=e202954a51b74aac45fac73534c7225bec82bf70"
@implementation NSString (url)
-(NSString *)stringByUrlEncoding {
	return [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8) autorelease];	
}

-(NSString *)stringByUrlDecoding {
	return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
@end 

@implementation PhotoAPIModel
@synthesize delegate = _delegate, conn;
static PhotoAPIModel *instance = nil;
+ (id) getSharedInstance {
    @synchronized(self){
        if (instance == nil) {
            instance = [[PhotoAPIModel alloc] init];
        }
    }
    return instance;
}

- (id) init {
    self = [super init];
    if (self) {
        _recvData = [[NSMutableData data] retain];
        self.conn = [[NSURLConnection alloc] init];
    }
    return self;
}

- (void) dealloc {
    self.conn = nil;
    [_recvData release];
    [super dealloc];
}

- (void) cancelRequest {
    if (self.conn) {
        [self.conn cancel];        
    }

    _delegate = nil;
    cancelRequest = YES;
}

- (void) getPhotoListBySearchText:(NSString*) searchText withEngine:(SEARCHENGINE) searchEngine startIndex:(NSInteger) startIndex {
    cancelRequest = NO;
    NSString *searchUrl ;
    switch (searchEngine) {
        case NAVER:
        case PHOPICKER:
            searchUrl = [NSString stringWithFormat:@"%@&query=%@&target=image&display=%d&start=%d", naverApi, [searchText stringByUrlEncoding], naverImageDownloadCount,startIndex];            
            break;
        case DAUM:
            searchUrl = [NSString stringWithFormat:@"%@&q=%@&output=xml&result=20", daumApi, [searchText stringByUrlEncoding]];            
            break;

        default:
            return;
            break;
    }
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:searchUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    [self.conn initWithRequest:req delegate:self];
    [self.conn start];
}

- (void) getCurrentPhotoList {
    cancelRequest = NO;
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://openapi.naver.com/search?key=039cc334a00d8f3a13703ff0f7125dc5&query=hotissue&target=image&display=60"]];
    [self.conn initWithRequest:req delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_recvData appendData:data];
}

- (void) didFinishWithDataForPhotoAPIResultParser:(NSData *)data {
    if (data != nil) {
//        NSString *decodingString = [[NSString alloc] initWithData:data encoding:0x80000940];    //EUC-KR decoding
        NSString *decodingString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"decodingString : %@", decodingString);
        PhotoAPIXMLParser *parser = [[PhotoAPIXMLParser alloc] init];
        parser.delegate = self;
        [parser parseAPIResultString:decodingString];
        [parser release];
        [decodingString release];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(apiRequestError:)]) {
        [_delegate apiRequestError:error];
    }
}

- (void)photoAPIParser:(PhotoAPIXMLParser *)parser didSuccessParse:(PhotoAPIParserModel *) parserResult {
    if (!cancelRequest && _delegate && [_delegate respondsToSelector:@selector(requestDone:)]) {
        [_delegate requestDone:parserResult];
    }
}
- (void)photoAPIParser:(PhotoAPIXMLParser *)parser didFailParse:(NSError *) parserError {
    NSLog(@"error : %@", parserError);
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self didFinishWithDataForPhotoAPIResultParser:_recvData];
    [_recvData setLength:0];
    if (!cancelRequest && _delegate && [_delegate respondsToSelector:@selector(connectionFinish)]) {
        [_delegate connectionFinish];
    }
    
}
@end
