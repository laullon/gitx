//
//  PBCommandMenuItem.h
//  GitX
//
//  Created by Tomasz Krasnyk on 10-11-06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBCommand.h"

@interface PBCommandMenuItem : NSMenuItem {}

- initWithCommand:(PBCommand *) aCommand;

@end
