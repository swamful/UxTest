//
//  PhotoFrameButtonView.m
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 12..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import "PhotoFrameButtonView.h"
#import "AppUtility.h"
@implementation PhotoFrameButtonView
@synthesize linkUrl = _linkUrl, index;

- (void)layoutIndicator:(UIView *)aview{
	CGSize size = aview.bounds.size;
	CGSize mysize = [indicator sizeThatFits:size];
	indicator.frame = CGRectMake(roundf((size.width - mysize.width) / 2), roundf((size.height - mysize.height) / 2), mysize.width, mysize.height);
}

- (void) setImageInBackground:(NSString *)linkUrl forState:(UIControlState)state {
    controlState = state;
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self layoutIndicator:self];
    [self addSubview:indicator];
    [indicator startAnimating];
    [self performSelectorInBackground:@selector(getImage:) withObject:linkUrl];
}



- (void) getImage:(NSString *) linkUrl {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:linkUrl]];

    UIImage *image = [UIImage imageWithData:imageData];
    [self performSelectorOnMainThread:@selector(setImageInMain:) withObject:image waitUntilDone:NO];
    [pool release];

}

- (void) setImageInMain:(UIImage *) image {
    [self setImage:image forState:UIControlStateNormal];
    [indicator stopAnimating];
	[indicator removeFromSuperview];
}
@end
