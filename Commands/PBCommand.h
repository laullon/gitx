//
//  PBCommand.h
//  GitX
//
//  Created by Tomasz Krasnyk on 10-11-06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PBGitRepository;

@interface PBCommand : NSObject {
	PBGitRepository *repository;
	NSString *displayName;
	NSMutableArray *parameters;
	BOOL confirmAction;
	BOOL canBeFired;
}

@property BOOL canBeFired;
@property (readonly) BOOL confirmAction;
@property (readonly) PBGitRepository *repository;
@property (strong) NSString *commandTitle;
@property (strong) NSString *commandDescription;
@property (readonly) NSString *displayName;

- (id) initWithDisplayName:(NSString *) aDisplayName parameters:(NSArray *) params repository:(PBGitRepository *) repo;
- (id) initWithDisplayName:(NSString *) aDisplayName parameters:(NSArray *) params repository:(PBGitRepository *) repo confirmAction:(BOOL) confirm;
- (void) invoke;
- (NSArray *) allParameters;
- (void) appendParameters:(NSArray *) params;

@end
