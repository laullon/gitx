//
//  PBChangedFile.h
//  GitX
//
//  Created by Pieter de Bie on 22-09-08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PBGitRepository.h"

typedef enum {
	NEW,
	MODIFIED,
	DELETED,
	ADDED
} PBChangedFileStatus;

@interface PBChangedFile : NSObject 

@property (copy) NSString *path, *commitBlobSHA, *commitBlobMode;
@property (assign) PBChangedFileStatus status;
@property (assign) BOOL hasStagedChanges, hasUnstagedChanges;

- (NSImage *)icon;
- (NSString *)indexInfo;

+ (NSImage *) iconForStatus:(PBChangedFileStatus) aStatus;
- (id) initWithPath:(NSString *)p;
@end
