//
//  PhotoAPIModel.h
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 12..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoAPIXMLParser.h"
#import "UIConstants.h"
@protocol PhotoAPIModelDelegate;

@interface PhotoAPIModel : NSObject <NSURLConnectionDataDelegate, PhotoAPIParserDelegate>{
    id<PhotoAPIModelDelegate> _delegate;
    NSMutableData *_recvData;
    NSURLConnection *conn;
    BOOL cancelRequest;
}

+ (id) getSharedInstance;
- (void) getCurrentPhotoList;
- (void) getPhotoListBySearchText:(NSString*) searchText withEngine:(SEARCHENGINE) searchEngine;
- (void) cancelRequest;
@property (nonatomic, assign) id<PhotoAPIModelDelegate> delegate;
@property (nonatomic, retain) NSURLConnection *conn;
@end

@protocol PhotoAPIModelDelegate <NSObject>
- (void) requestDone:(PhotoAPIParserModel*) resultData;
- (void) apiRequestError:(NSError *) error;
@end