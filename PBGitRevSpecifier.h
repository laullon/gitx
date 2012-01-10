//
//  PBGitRevSpecifier.h
//  GitX
//
//  Created by Pieter de Bie on 12-09-08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <PBGitRef.h>

@interface PBGitRevSpecifier : NSObject  <NSCopying> {
	NSArray *parameters;
	BOOL isSimpleRef;
}

- (id) initWithParameters:(NSArray *)params description:(NSString *)descrip;
- (id) initWithParameters:(NSArray*) params;
- (id) initWithRef: (PBGitRef*) ref;

- (NSString*) simpleRef;
- (PBGitRef *) ref;
- (BOOL) hasPathLimiter;
- (BOOL) hasLeftRight;
- (NSString *) title;

- (BOOL) isEqual: (PBGitRevSpecifier*) other;
- (BOOL) isAllBranchesRev;
- (BOOL) isLocalBranchesRev;

+ (PBGitRevSpecifier *)allBranchesRevSpec;
+ (PBGitRevSpecifier *)localBranchesRevSpec;

@property(nonatomic,strong) NSString *description;
@property(strong) NSString *helpText;
@property(readonly) NSArray *parameters;
@property(strong) NSURL *workingDirectory;
@property(readonly) BOOL isSimpleRef;
@property(strong) NSNumber *behind;
@property(strong) NSNumber *ahead;

@end
