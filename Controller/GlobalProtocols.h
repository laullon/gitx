//
//  GlobalProtocols.h
//  GitX
//
//  Created by Robert Kyriakis on 08.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Messages
@required
- (void)showMessageSheet:(NSString *)messageText infoText:(NSString *)infoText;
- (void)showErrorSheet:(NSError *)error;
@end
