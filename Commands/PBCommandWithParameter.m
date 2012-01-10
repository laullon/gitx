//
//  PBCommandWithParameter.m
//  GitX
//
//  Created by Tomasz Krasnyk on 10-11-06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PBCommandWithParameter.h"
#import "PBArgumentPickerController.h"
#import "PBGitRepository.h"
#import "PBGitWindowController.h"

@implementation PBCommandWithParameter
@synthesize command;
@synthesize parameterName;
@synthesize parameterDisplayName;

- initWithCommand:(PBCommand *) aCommand parameterName:(NSString *) param parameterDisplayName:(NSString *) paramDisplayName {
	if ((self = [super initWithDisplayName:[aCommand displayName] parameters:nil repository:[aCommand repository]])) {
		command = aCommand;
		parameterName = param;
		parameterDisplayName = paramDisplayName;
	}
	return self;
}



- (void) invoke {
	PBArgumentPickerController *controller = [[PBArgumentPickerController alloc] initWithCommandWithParameter:self];
	[NSApp beginSheet:[controller window] modalForWindow:[command.repository.windowController window] modalDelegate:controller didEndSelector:nil contextInfo:NULL];
}
@end
