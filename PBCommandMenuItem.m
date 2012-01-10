//
//  PBCommandMenuItem.m
//  GitX
//
//  Created by Tomasz Krasnyk on 10-11-06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PBCommandMenuItem.h"

@implementation PBCommandMenuItem

- initWithCommand:(PBCommand *) aCommand {
	if ((self = [super init])) {
		super.title = [aCommand displayName];
		[self setTarget:aCommand];
		[self setAction:@selector(invoke)];
		[self setEnabled:[aCommand canBeFired]];
	}
	return self;
}



@end
