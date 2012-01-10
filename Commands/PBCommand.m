//
//  PBCommand.m
//  GitX
//
//  Created by Tomasz Krasnyk on 10-11-06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PBCommand.h"
#import "PBRemoteProgressSheet.h"

@implementation PBCommand
@synthesize displayName;
@synthesize commandDescription;
@synthesize commandTitle;
@synthesize repository;
@synthesize canBeFired;

- (id) initWithDisplayName:(NSString *) aDisplayName parameters:(NSArray *) params {
	return [self initWithDisplayName:aDisplayName parameters:params repository:nil];
}

- (id) initWithDisplayName:(NSString *) aDisplayName parameters:(NSArray *) params repository:(PBGitRepository *) repo {
	self = [super init];
	if (self != nil) {
		displayName = aDisplayName;
		parameters = [[NSMutableArray alloc] initWithArray:params];
		commandTitle = @"";
		commandDescription = @"";
		repository = repo;
		canBeFired = YES;
	}
	return self;
}

- (NSArray *) allParameters {
	return parameters;
}

- (void) appendParameters:(NSArray *) params {
	[parameters addObjectsFromArray:params];
}

- (void) invoke {
	[PBRemoteProgressSheet beginRemoteProgressSheetForArguments:[self allParameters] title:self.commandTitle description:self.commandDescription inRepository:self.repository];
}

@end
