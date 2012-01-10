//
//  PBCloneRepositoryPanel.h
//  GitX
//
//  Created by Nathan Kinsinger on 2/7/10.
//  Copyright 2010 Nathan Kinsinger. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GlobalProtocols.h"


@interface PBCloneRepositoryPanel : NSWindowController <Messages> {
	NSTextField *repositoryURL;
	NSTextField *destinationPath;
	NSTextField *errorMessage;
	
    NSView      *browseRepositoryPanelAccessoryView;
    NSView      *browseDestinationPanelAccessoryView;

	NSOpenPanel *browseRepositoryPanel;
	NSOpenPanel *browseDestinationPanel;

	NSString *path;
	BOOL isBare;
}

+ (id) panel;
+ (void)beginCloneRepository:(NSString *)repository toURL:(NSURL *)targetURL isBare:(BOOL)bare;

- (void)showMessageSheet:(NSString *)messageText infoText:(NSString *)infoText;
- (void)showErrorSheet:(NSError *)error;

- (IBAction) closeCloneRepositoryPanel:(id)sender;
- (IBAction) clone:(id)sender;
- (IBAction) browseRepository:(id)sender;
- (IBAction) showHideHiddenFiles:(id)sender;
- (IBAction) browseDestination:(id)sender;
- (IBAction) bareCheckBoxChanged:(NSButton*)sender;

@property (strong) IBOutlet NSTextField *repositoryURL;
@property (strong) IBOutlet NSTextField *destinationPath;
@property (strong) IBOutlet NSTextField *errorMessage;
@property (strong) IBOutlet NSView      *browseRepositoryPanelAccessoryView;
@property (strong) IBOutlet NSView      *browseDestinationPanelAccessoryView;

@property (assign) BOOL isBare;

@end
