//
//  PBGitHistoryController.h
//  GitX
//
//  Created by Pieter de Bie on 19-09-08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PBGitCommit.h"
#import "PBGitTree.h"
#import "PBViewController.h"

@class PBWebHistoryController;
@class PBGitGradientBarView;
@class PBRefController;
@class QLPreviewPanel;
@class PBCommitList;
@class GLFileView;
@class NSString;

@class PBHistorySearchController;

// Controls the split history view from PBGitHistoryView.xib
@interface PBGitHistoryController : PBViewController PROTOCOL_10_6(NSOutlineViewDelegate){
	IBOutlet NSSearchField *searchField;
	IBOutlet NSSearchField *filesSearchField;
	IBOutlet NSOutlineView* fileBrowser;
	NSArray *currentFileBrowserSelectionPath;
	IBOutlet PBWebHistoryController *webHistoryController;
	QLPreviewPanel* previewPanel;
	IBOutlet GLFileView *fileView;

	IBOutlet PBGitGradientBarView *upperToolbarView;
	IBOutlet NSButton *mergeButton;
	IBOutlet NSButton *cherryPickButton;
	IBOutlet NSButton *rebaseButton;

	IBOutlet PBGitGradientBarView *scopeBarView;
	IBOutlet NSButton *allBranchesFilterItem;
	IBOutlet NSButton *localRemoteBranchesFilterItem;
	IBOutlet NSButton *selectedBranchFilterItem;

	IBOutlet id webView;
	int selectedCommitDetailsIndex;
	BOOL forceSelectionUpdate;
	
	PBGitTree *gitTree;
	PBGitCommit *webCommit;
	PBGitCommit *selectedCommit;
	PBGitCommit *selectedCommitBeforeRefresh;
}

@property (unsafe_unretained) IBOutlet NSTreeController* treeController;
@property (unsafe_unretained) IBOutlet NSSplitView *historySplitView;
@property (nonatomic,assign) int selectedCommitDetailsIndex;
@property (strong) PBGitCommit *webCommit;
@property (strong) PBGitTree* gitTree;
@property (unsafe_unretained) IBOutlet NSArrayController *commitController;
@property (unsafe_unretained) IBOutlet PBRefController *refController;
@property (unsafe_unretained) IBOutlet PBHistorySearchController *searchController;
@property (unsafe_unretained) PBCommitList *commitList;

- (IBAction) setDetailedView:(id)sender;
- (IBAction) setTreeView:(id)sender;
- (IBAction) setBranchFilter:(id)sender;

- (void)selectCommit:(NSString *)commit;
- (IBAction) refresh:(id)sender;
- (IBAction) toggleQLPreviewPanel:(id)sender;
- (IBAction) openSelectedFile:(id)sender;
- (void) updateQuicklookForce: (BOOL) force;

// Context menu methods
- (NSMenu *)contextMenuForTreeView;
- (NSArray *)menuItemsForPaths:(NSArray *)paths;
- (void)showCommitsFromTree:(id)sender;
- (void)showInFinderAction:(id)sender;
- (void)openFilesAction:(id)sender;

// Repository Methods
- (IBAction) createBranch:(id)sender;
- (IBAction) createTag:(id)sender;
- (IBAction) showAddRemoteSheet:(id)sender;
- (IBAction) merge:(id)sender;
- (IBAction) cherryPick:(id)sender;
- (IBAction) rebase:(id)sender;

// Find/Search methods
- (IBAction)selectNext:(id)sender;
- (IBAction)selectPrevious:(id)sender;
- (IBAction) updateSearch:(id) sender;

- (void) copyCommitInfo;
- (void) copyCommitSHA;

- (BOOL) hasNonlinearPath;

- (NSMenu *)tableColumnMenu;

- (BOOL)splitView:(NSSplitView *)sender canCollapseSubview:(NSView *)subview;
- (BOOL)splitView:(NSSplitView *)splitView shouldCollapseSubview:(NSView *)subview forDoubleClickOnDividerAtIndex:(NSInteger)dividerIndex;

- (IBAction)loadAllCommits:(id)sender;
@end
