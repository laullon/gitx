//
//  PBCommitList.h
//  GitX
//
//  Created by Pieter de Bie on 9/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebView.h>
#import "PBGitHistoryController.h"

@class PBWebHistoryController;

// Displays the list of commits. Additional behavior includes special key
// handling and hiliting search results.
// dataSource: PBRefController
// delegate: PBGitHistoryController
@interface PBCommitList : NSTableView {
	IBOutlet WebView* webView;
	__unsafe_unretained PBWebHistoryController *webController;
	__unsafe_unretained PBGitHistoryController *controller;
	__unsafe_unretained PBHistorySearchController *searchController;

    BOOL useAdjustScroll;
	NSPoint mouseDownPoint;
}

@property(nonatomic, unsafe_unretained) IBOutlet PBWebHistoryController *webController;
@property(nonatomic, unsafe_unretained) IBOutlet PBGitHistoryController *controller;
@property(nonatomic, unsafe_unretained) IBOutlet PBHistorySearchController *searchController;

@property (readonly) NSPoint mouseDownPoint;
@property (assign) BOOL useAdjustScroll;
@end
