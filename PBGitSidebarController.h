//
//  PBGitSidebar.h
//  GitX
//
//  Created by Pieter de Bie on 9/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PBViewController.h"

@class PBSourceViewItem;
@class PBGitHistoryController;
@class PBGitCommitController;
@class PBStashContentController;

@interface PBGitSidebarController : PBViewController PROTOCOL_10_6(NSOutlineViewDelegate, NSMenuDelegate){
	IBOutlet NSWindow *window;
	IBOutlet NSOutlineView *sourceView;
	IBOutlet NSPopUpButton *actionButton;
	IBOutlet NSSegmentedControl *remoteControls;

	IBOutlet NSButton* svnFetchButton;
	IBOutlet NSButton* svnRebaseButton;
	IBOutlet NSButton* svnDcommitButton;
    
	/* Specific things */
	PBSourceViewItem *stage;

	PBSourceViewItem *branches, *remotes, *tags, *others, *stashes, *submodules;

	PBGitHistoryController *historyViewController;
	PBGitCommitController *commitViewController;
	PBStashContentController *stashViewController;
}

- (void) selectStage;
- (void) selectCurrentBranch;

- (NSMenu *) menuForRow:(NSInteger)row;

- (IBAction) fetchPullPushAction:(id)sender;
- (IBAction) svnFetch:(id)sender;
- (IBAction) svnRebase:(id)sender;
- (IBAction) svnDcommit:(id)sender;

- (void)setHistorySearch:(NSString *)searchString mode:(NSInteger)mode;

-(NSNumber *)countCommitsOf:(NSString *)range;
-(bool)remoteNeedFetch:(NSString *)remote;

@property(strong, readonly) NSMutableArray *items;
@property(strong, readonly) NSView *sourceListControlsView;
@property(strong, readonly) PBGitHistoryController *historyViewController;
@property(strong, readonly) PBGitCommitController *commitViewController;
@property(strong, readonly) PBStashContentController *stashViewController;

@end
