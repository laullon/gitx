//
//  SearchWebView.h
//  GitX
//
//  Created by German Laullon on 19/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface WebView (SearchWebView)

@property(readonly) int resultCount;

- (void)highlightAllOccurencesOfString:(NSString*)str inNode:(DOMNode *)node;
- (void)removeAllHighlights;
- (void)search:(NSSearchField *)sender update:(BOOL)update grabFocus:(BOOL)grabFocus direction:(BOOL)forward;

@end
