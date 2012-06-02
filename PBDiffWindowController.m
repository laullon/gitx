//
//  PBDiffWindowController.m
//  GitX
//
//  Created by Pieter de Bie on 13-10-08.
//  Copyright 2008 Pieter de Bie. All rights reserved.
//

#import "PBDiffWindowController.h"
#import "PBGitRepository.h"
#import "PBGitCommit.h"
#import "PBGitDefaults.h"
#import "GLFileView.h"
#import "PBWebCommitController.h"


@implementation PBDiffWindowController
@synthesize diff;

- (id) initWithDiff:(NSString *)aDiff
{
	if (!(self = [super initWithWindowNibName:@"PBDiffWindow"]))
		return nil;

	diff = aDiff;
    
	return self;
}


+ (void) showDiffWindowWithFiles:(NSArray *)filePaths fromCommit:(PBGitCommit *)startCommit diffCommit:(PBGitCommit *)diffCommit
{
	if (!startCommit)
		return;

	if (!diffCommit)
		diffCommit = [startCommit.repository headCommit];

	NSString *commitSelector = [NSString stringWithFormat:@"%@..%@", [startCommit realSha], [diffCommit realSha]];
	NSMutableArray *args = [NSMutableArray arrayWithObjects:@"diff", @"--no-ext-diff", commitSelector, nil];

	if (![PBGitDefaults showWhitespaceDifferences])
		[args insertObject:@"-w" atIndex:1];

	if (filePaths) {
		[args addObject:@"--"];
		[args addObjectsFromArray:filePaths];
	}

	int retValue;
	NSString *diff = [startCommit.repository outputInWorkdirForArguments:args retValue:&retValue];
	if (retValue) {
		DLog(@"diff failed with retValue: %d   for command: '%@'    output: '%@'", retValue, [args componentsJoinedByString:@" "], diff);
		return;
	}
    
    // File Stats
    args = [NSMutableArray arrayWithObjects:@"show", @"--numstat", @"--summary", @"--pretty=raw", [startCommit realSha], [diffCommit realSha], nil];
	if (![PBGitDefaults showWhitespaceDifferences])
		[args insertObject:@"-w" atIndex:1];
    NSString *details = [startCommit.repository outputInWorkdirForArguments:args];
    NSMutableDictionary *stats = [PBWebCommitController parseStats:details];
    
    // File list
    args = [NSMutableArray arrayWithObjects:@"diff-tree", @"--root", @"-r", @"-C90%", @"-M90%", nil];
    [args addObject:[startCommit realSha]];
    [args addObject:[diffCommit realSha]];
    NSString *dt = [startCommit.repository outputInWorkdirForArguments:args];
    NSString *fileList = [GLFileView parseDiffTree:dt withStats:stats];
    
    // Hunk list
    NSString *hunks = [GLFileView parseDiff:diff];
    hunks=[hunks stringByReplacingOccurrencesOfString:@"{SHA_PREV}" withString:[startCommit realSha]];
    hunks=[hunks stringByReplacingOccurrencesOfString:@"{SHA}" withString:[diffCommit realSha]];

    NSString *html = [NSString stringWithFormat:@"%@%@",fileList,hunks];
    
	PBDiffWindowController *diffController = [[PBDiffWindowController alloc] initWithDiff:html];
	[diffController showWindow:nil];
}


@end
