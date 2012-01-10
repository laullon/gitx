//
//  PBGitRef.m
//  GitX
//
//  Created by Pieter de Bie on 06-09-08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PBGitRef.h"


NSString * const kGitXTagType    = @"tag";
NSString * const kGitXBranchType = @"branch";
NSString * const kGitXRemoteType = @"remote";
NSString * const kGitXRemoteBranchType = @"remote branch";

NSString * const kGitXTagRefPrefix    = @"refs/tags/";
NSString * const kGitXBranchRefPrefix = @"refs/heads/";
NSString * const kGitXRemoteRefPrefix = @"refs/remotes/";


@implementation PBGitRef

@synthesize ref;

- (NSString *) tagName
{
	if (![self isTag])
		return nil;

	return [self shortName];
}

- (NSString *) branchName
{
	if (![self isBranch])
		return nil;

	return [self shortName];
}

- (NSString *) remoteName
{
	if (![self isRemote])
		return nil;

	return (NSString *)[[ref componentsSeparatedByString:@"/"] objectAtIndex:2];
}

- (NSString *) remoteBranchName
{
	if (![self isRemoteBranch])
		return nil;

	return [[self shortName] substringFromIndex:[[self remoteName] length] + 1];;
}

- (NSString *) type
{
	if ([self isBranch])
		return @"head";
	if ([self isTag])
		return @"tag";
	if ([self isRemote])
		return @"remote";
	return nil;
}

- (BOOL) isBranch
{
	return [ref hasPrefix:kGitXBranchRefPrefix];
}

- (BOOL) isTag
{
	return [ref hasPrefix:kGitXTagRefPrefix];
}

- (BOOL) isRemote
{
	return [ref hasPrefix:kGitXRemoteRefPrefix];
}

- (BOOL) isRemoteBranch
{
	if (![self isRemote])
		return NO;

	return ([[ref componentsSeparatedByString:@"/"] count] > 3);
}

- (BOOL) isEqualToRef:(PBGitRef *)otherRef
{
	return [ref isEqualToString:[otherRef ref]];
}

- (PBGitRef *) remoteRef
{
	if (![self isRemote])
		return nil;

	return [PBGitRef refFromString:[kGitXRemoteRefPrefix stringByAppendingString:[self remoteName]]];
}

+ (PBGitRef*) refFromString: (NSString*) s
{
	return [[PBGitRef alloc] initWithString:s];
}

- (PBGitRef*) initWithString: (NSString*) s
{
	ref = s;
	return self;
}

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSelector
{
	return NO;
}

+ (BOOL)isKeyExcludedFromWebScript:(const char *)name {
	return NO;
}


#pragma mark <PBGitRefish>

- (NSString *) refishName
{
	return ref;
}

- (NSString *) shortName
{
	if ([self type])
		return [ref substringFromIndex:[[self type] length] + 7];
	return ref;
}

- (NSString *) refishType
{
	if ([self isBranch])
		return kGitXBranchType;
	if ([self isTag])
		return kGitXTagType;
	if ([self isRemoteBranch])
		return kGitXRemoteBranchType;
	if ([self isRemote])
		return kGitXRemoteType;
	return nil;
}

-(NSString *)description
{
    NSMutableString *str = [NSMutableString new];
    
    [str appendString:@"-super description-\n"];
    [str appendString:[super description]];
    [str appendString:@"\n\n-PBGitRef description-\n"];
    [str appendString:[NSString stringWithFormat:@"refishName: %@\n",[self refishName]]];
    [str appendString:[NSString stringWithFormat:@"shortName: %@\n",[self shortName]]];
    [str appendString:[NSString stringWithFormat:@"refishType: %@\n",[self refishType]]];
    [str appendString:[NSString stringWithFormat:@"isTag: %@\n",[self isTag]? @"YES":@"NO"]];
    [str appendString:[NSString stringWithFormat:@"tagName: %@\n",[self tagName]]];
    [str appendString:[NSString stringWithFormat:@"isBranch: %@\n",[self isBranch]? @"YES":@"NO"]];
    [str appendString:[NSString stringWithFormat:@"branchName: %@\n",[self branchName]]];
    [str appendString:[NSString stringWithFormat:@"isRemote: %@\n",[self isRemote]? @"YES":@"NO"]];
    [str appendString:[NSString stringWithFormat:@"remoteName: %@\n",[self remoteName]]];
    [str appendString:[NSString stringWithFormat:@"isRemoteBranch: %@\n",[self isRemoteBranch]? @"YES":@"NO"]];   
    [str appendString:[NSString stringWithFormat:@"remoteBranchName: %@\n",[self remoteBranchName]]];
    [str appendString:[NSString stringWithFormat:@"type: %@\n",[self type]]];
    [str appendString:[NSString stringWithFormat:@"remoteRef: %p\n",[self remoteRef]]];

    return str;
}

@end
