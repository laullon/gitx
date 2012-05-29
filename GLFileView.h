//
//  GLFileView.h
//  GitX
//
//  Created by German Laullon on 14/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PBWebController.h"
#import "MGScopeBarDelegateProtocol.h"
#import "PBGitCommit.h"
#import "PBGitHistoryController.h"
#import "PBRefContextDelegate.h"
#import "SearchWebView.h"
#import "MGScopeBar.h"

@class PBGitGradientBarView;

@interface GLFileView : PBWebController <MGScopeBarDelegate> {
	__unsafe_unretained PBGitHistoryController* historyController;
	__unsafe_unretained MGScopeBar *typeBar;
	NSMutableArray *groups;
	NSString *logFormat;
	NSString *diffType;
	IBOutlet NSView *accessoryView;
	IBOutlet NSSplitView *fileListSplitView;
    IBOutlet NSSearchField *searchField;
    IBOutlet NSSegmentedControl *stepper;
    IBOutlet NSTextField *numberOfMatches;
    PBGitTree *lastFile;
}

@property(nonatomic, unsafe_unretained) IBOutlet PBGitHistoryController *historyController;
@property(nonatomic, unsafe_unretained) IBOutlet MGScopeBar *typeBar;

- (void)showFile;
- (void)didLoad;
- (NSString *)parseBlame:(NSString *)txt;
+ (NSString *)escapeHTML:(NSString *)txt;
+ (NSString *)parseDiff:(NSString *)txt;
+ (NSString *)parseDiffTree:(NSString *)txt withStats:(NSMutableDictionary *)stats;
+ (NSString *)getFileName:(NSString *)line;

+(BOOL)isStartDiff:(NSString *)line;
+(BOOL)isStartBlock:(NSString *)line;

+(NSArray *)getFilesNames:(NSString *)line;
+(BOOL)isBinaryFile:(NSString *)line;
+(NSString*)mimeTypeForFileName:(NSString*)file;
+(BOOL)isImage:(NSString*)file;
+(BOOL)isDiffHeader:(NSString*)line;

- (void) openFileMerge:(NSString*)file sha:(NSString *)sha sha2:(NSString *)sha2;

- (IBAction)searchFieldChanged:(NSSearchField *)sender;
- (IBAction)stepperPressed:(id)sender;
  
@property(strong) NSMutableArray *groups;
@property(strong) NSString *logFormat;

@property (strong) IBOutlet NSSegmentedControl *stepper;
@property (strong) IBOutlet NSSearchField *searchField;
@property (strong) IBOutlet NSTextField *numberOfMatches;
@end
