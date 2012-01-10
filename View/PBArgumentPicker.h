//
//  PBArgumentPicker.h
//  GitX
//
//  Created by Tomasz Krasnyk on 10-11-06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PBArgumentPicker : NSView {
	IBOutlet NSTextField *textField;
	IBOutlet NSTextField *label;
	IBOutlet NSButton *okButton;
	IBOutlet NSButton *cancelButton;
}
@property (nonatomic, strong, readonly) NSTextField *textField;
@property (nonatomic, strong, readonly) NSTextField *label;
@property (nonatomic, strong, readonly) NSButton *okButton;
@property (nonatomic, strong, readonly) NSButton *cancelButton;


@end
