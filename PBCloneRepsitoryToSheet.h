//
//  PBCloneRepsitoryToSheet.h
//  GitX
//
//  Created by Nathan Kinsinger on 2/7/10.
//  Copyright 2010 Nathan Kinsinger. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class PBGitRepository;

@interface PBCloneRepsitoryToSheet : NSWindowController {
	PBGitRepository *repository;
	BOOL isBare;
	NSTextField *message;
	NSView      *cloneToAccessoryView;
    NSOpenPanel *cloneToSheet;
}

+ (void) beginCloneRepsitoryToSheetForRepository:(PBGitRepository *)repo;


@property(strong) PBGitRepository *repository;
@property BOOL isBare;
@property(strong) IBOutlet NSTextField *message;
@property(strong) IBOutlet NSView      *cloneToAccessoryView;

- (IBAction) showHideHiddenFiles:(id)sender;

@end
