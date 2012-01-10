//
//  PBGitRevList.h
//  GitX
//
//  Created by Pieter de Bie on 17-06-08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PBGitRepository;
@class PBGitRevSpecifier;

@interface PBGitRevList : NSObject {
	NSMutableArray *commits;

	PBGitRepository *repository;
	PBGitRevSpecifier *currentRev;
	BOOL isGraphing;

	NSThread *parseThread;
	BOOL isParsing;
	BOOL resetCommits;
    BOOL reloadAll;
}

- (id) initWithRepository:(PBGitRepository *)repo rev:(PBGitRevSpecifier *)rev shouldGraph:(BOOL)graph;
- (void)loadRevisons:(BOOL)all;
- (void)cancel;

@property (strong) NSMutableArray *commits;
@property (readonly) BOOL isParsing;

@end
