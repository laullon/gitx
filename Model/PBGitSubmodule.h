//
//  PBGitSubmodule.h
//  GitX
//
//  Created by Tomasz Krasnyk on 10-11-07.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PBPresentable.h"

typedef enum {
	PBGitSubmoduleStateNotInitialized,
	PBGitSubmoduleStateMatchingIndex,
	PBGitSubmoduleStateDoesNotMatchIndex,
	PBGitSubmoduleStateFailed,
} PBGitSubmoduleState;

@interface PBGitSubmodule : NSObject<PBPresentable> {
	NSString *name;
	NSString *path;
	NSString *checkedOutCommit;

	PBGitSubmoduleState submoduleState;
	
	NSMutableArray *submodules;
}
@property (readonly) NSMutableArray *submodules;
@property (readonly) PBGitSubmoduleState submoduleState;
@property (readonly) NSString *name;
@property (readonly) NSString *path;
@property (readonly) NSString *checkedOutCommit;

- (id) initWithRawSubmoduleStatusString:(NSString *) submoduleStatusString;

+ (NSImage *) imageForSubmoduleState:(PBGitSubmoduleState) state;
+ (PBGitSubmoduleState) submoduleStateFromCharacter:(unichar) character;

- (void) addSubmodule:(PBGitSubmodule *) submodule;
@end
