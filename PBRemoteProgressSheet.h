//
//  PBRemoteProgressSheetController.h
//  GitX
//
//  Created by Nathan Kinsinger on 12/6/09.
//  Copyright 2009 Nathan Kinsinger. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GlobalProtocols.h"

extern NSString * const kGitXProgressDescription;
extern NSString * const kGitXProgressSuccessDescription;
extern NSString * const kGitXProgressSuccessInfo;
extern NSString * const kGitXProgressErrorDescription;
extern NSString * const kGitXProgressErrorInfo;


@class PBGitRepository;

@interface PBRemoteProgressSheet : NSWindowController {
	NSWindowController *controller;

    NSArray  *arguments;
	NSString *title;
	NSString *description;

	NSTask    *gitTask;
	NSInteger  returnCode;

	NSTextField         *progressDescription;
	NSProgressIndicator *progressIndicator;

	NSTimer *taskTimer;
    NSView *progressView;
    
    NSView *cloneProgressView;
    NSTextField *cloneFromURLTextField;
    NSTextField *clonetoURLTextField;
    NSTextField *filesToCloneTextField;
    NSTextField *filesLeftTextField;
    NSProgressIndicator *cloneProgressIndicator;
    NSTimer *fileStatusTimer;
    NSURL *sourceURL;
    NSURL *destinationURL;
    NSNumber *sourceFilesCount;
}

+ (void) beginRemoteProgressSheetForArguments:(NSArray *)args title:(NSString *)theTitle description:(NSString *)theDescription inDir:(NSString *)dir windowController:(NSWindowController<Messages>*)windowController;

+ (void) beginRemoteProgressSheetForArguments:(NSArray *)args title:(NSString *)theTitle description:(NSString *)theDescription inRepository:(PBGitRepository *)repo;


@property (strong) IBOutlet NSTextField         *progressDescription;
@property (strong) IBOutlet NSProgressIndicator *progressIndicator;
@property (strong) IBOutlet NSView *progressView;
@property (strong) IBOutlet NSView *cloneProgressView;
@property (strong) IBOutlet NSTextField *cloneFromURLTextField;
@property (strong) IBOutlet NSTextField *clonetoURLTextField;
@property (strong) IBOutlet NSTextField *filesToCloneTextField;
@property (strong) IBOutlet NSTextField *filesLeftTextField;
@property (strong) IBOutlet NSProgressIndicator *cloneProgressIndicator;



@end