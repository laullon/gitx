//
//  PBCommandWithParameter.h
//  GitX
//
//  Created by Tomasz Krasnyk on 10-11-06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PBCommand.h"


@interface PBCommandWithParameter : PBCommand {
	PBCommand *command;
	NSString *parameterName;
	NSString *parameterDisplayName;
}
@property (nonatomic, strong, readonly) PBCommand *command;
@property (nonatomic, strong, readonly) NSString *parameterName;
@property (nonatomic, strong, readonly) NSString *parameterDisplayName;

- initWithCommand:(PBCommand *) command parameterName:(NSString *) param parameterDisplayName:(NSString *) paramDisplayName;
@end
