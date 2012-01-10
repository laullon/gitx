//
//  PBGitStash.m
//  GitX
//
//  Created by Tomasz Krasnyk on 10-11-06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PBGitStash.h"


@implementation PBGitStash
@synthesize name;
@synthesize message;
@synthesize stashRawString;
@synthesize stashSourceMessage;

- initWithRawStashLine:(NSString *) stashLineFromStashListOutput {
	if ((self = [super init])) {
		stashRawString = stashLineFromStashListOutput;
		NSArray *lineComponents = [stashLineFromStashListOutput componentsSeparatedByString:@":"];
		if ([lineComponents count] != 3) {
			return nil;
		}
		name = [lineComponents objectAtIndex:0];
		stashSourceMessage = [[lineComponents objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		message = [[lineComponents objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	}
	return self;
}


- (NSString *) description {
	return self.stashRawString;
}

#pragma mark Presentable

- (NSString *) displayDescription {
	return [NSString stringWithFormat:@"%@ (%@)", self.message, self.name];
}

- (NSString *) popupDescription {
	return [self description];
}

- (NSImage *) icon {
	return [NSImage imageNamed:@"stash-icon.png"];
}

@end
