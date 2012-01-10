//
//  PBRemoteProgressSheetController.m
//  GitX
//
//  Created by Nathan Kinsinger on 12/6/09.
//  Copyright 2009 Nathan Kinsinger. All rights reserved.
//

#import "PBRemoteProgressSheet.h"
#import "PBGitWindowController.h"
#import "PBGitRepository.h"
#import "PBGitBinary.h"
#import "PBEasyPipe.h"

#define WINDOW_WIDTH_ADDITION 40.0
#define STANDARD_MAX_WIDTH 366.0
#define UPDATE_FILE_STATUS_INTERVAL 1.0

NSString * const kGitXProgressDescription        = @"PBGitXProgressDescription";
NSString * const kGitXProgressSuccessDescription = @"PBGitXProgressSuccessDescription";
NSString * const kGitXProgressSuccessInfo        = @"PBGitXProgressSuccessInfo";
NSString * const kGitXProgressErrorDescription   = @"PBGitXProgressErrorDescription";
NSString * const kGitXProgressErrorInfo          = @"PBGitXProgressErrorInfo";



@interface PBRemoteProgressSheet ()
- (void) beginRemoteProgressSheetForArguments:(NSArray *)args title:(NSString *)theTitle description:(NSString *)theDescription inDir:(NSString *)dir windowController:(NSWindowController<Messages>*)windowController;
- (void) showSuccessMessage;
- (void) showErrorMessage;
- (NSString *) progressTitle;
- (NSString *) successTitle;
- (NSString *) successDescription;
- (NSString *) errorTitle;
- (NSString *) errorDescription;
- (NSString *) commandDescription;
- (NSString *) standardOutputDescription;
- (NSString *) standardErrorDescription;
- (NSNumber *) filesCountAtURL:(NSURL *)url withRepeatTimer:(BOOL)repeat;
- (void) updateFileStatus;
@end



@implementation PBRemoteProgressSheet

@synthesize progressDescription;
@synthesize progressIndicator;
@synthesize progressView;
@synthesize cloneProgressView;
@synthesize cloneFromURLTextField;
@synthesize clonetoURLTextField;
@synthesize filesToCloneTextField;
@synthesize filesLeftTextField;
@synthesize cloneProgressIndicator;

static PBRemoteProgressSheet *sheet;
static PBGitRepository *repository;

#pragma mark -
#pragma mark PBRemoteProgressSheet

+ (void) beginRemoteProgressSheetForArguments:(NSArray *)args title:(NSString *)theTitle description:(NSString *)theDescription inDir:(NSString *)dir windowController:(NSWindowController<Messages>*)windowController
{
    if(!sheet) {
        sheet = [[self alloc] initWithWindowNibName:@"PBRemoteProgressSheet"];
    }
	[sheet beginRemoteProgressSheetForArguments:args title:theTitle description:theDescription inDir:dir windowController:windowController];
}


+ (void) beginRemoteProgressSheetForArguments:(NSArray *)args title:(NSString *)theTitle description:(NSString *)theDescription  inRepository:(PBGitRepository *)repo
{
	repository = repo;
    
    [PBRemoteProgressSheet beginRemoteProgressSheetForArguments:args title:theTitle description:theDescription inDir:[repo workingDirectory] windowController:repo.windowController];
}


- (void) beginRemoteProgressSheetForArguments:(NSArray *)args title:(NSString *)theTitle description:(NSString *)theDescription inDir:(NSString *)dir windowController:(NSWindowController<Messages>*)windowController
{
	controller  = windowController;
	arguments   = args;
	title       = theTitle;
	description = theDescription;

    [self window]; // loads the window (if it wasn't already)
    self.window.contentView = Nil;

    NSSize boundingSize = {0,0};
    NSRect frame;
    NSRect attributedFrame;
    NSAttributedString *attributedString;

    if ([(NSString*)[arguments objectAtIndex:0] compare:@"clone"] != NSOrderedSame)
    {
        // resize window if the description is larger than the default text field
        [self.progressDescription setStringValue:[self progressTitle]];
        attributedString = [self.progressDescription attributedStringValue];
        attributedFrame  = [attributedString boundingRectWithSize:boundingSize options:NSStringDrawingUsesLineFragmentOrigin];
        NSRect progressDescriptionTextFieldFrame = self.progressDescription.frame;
        
        progressDescriptionTextFieldFrame.size.width = attributedFrame.size.width;
        if (progressDescriptionTextFieldFrame.size.width < STANDARD_MAX_WIDTH)
        {
            progressDescriptionTextFieldFrame.size.width = STANDARD_MAX_WIDTH;
        }
        self.progressDescription.frame = progressDescriptionTextFieldFrame;

        frame = self.window.frame;
        frame.size.width = self.progressDescription.frame.size.width + WINDOW_WIDTH_ADDITION;
        frame.size.height = self.progressView.frame.size.height;
        [self.window setFrame:frame display:YES];
        
        progressView.frame = self.window.frame;
        
        self.window.contentView = progressView;
        [self.progressIndicator startAnimation:Nil];
    }
    else
    {
        float  maxWidth;
        
        NSString *sourceURLString = [arguments objectAtIndex:[arguments count]-2];
        if ([sourceURLString compare:@"."] == NSOrderedSame ) 
        {
            sourceURLString = dir;
        }
        sourceURL = [NSURL URLWithString:[sourceURLString stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation]];
        sourceURL = [sourceURL URLByResolvingSymlinksInPath];
        
        NSString *destinationURLString = [arguments objectAtIndex:[arguments count]-1];
        if ([destinationURLString compare:@"."] == NSOrderedSame ) 
        {
            destinationURLString = dir;
        }
        destinationURL = [NSURL URLWithString:[destinationURLString stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation]];
        destinationURL = [destinationURL URLByResolvingSymlinksInPath];

        [self.cloneFromURLTextField setStringValue:sourceURLString];
        attributedString = [self.cloneFromURLTextField attributedStringValue];
        attributedFrame  = [attributedString boundingRectWithSize:boundingSize options:NSStringDrawingUsesLineFragmentOrigin];
        NSRect cloneFromTextFieldFrame = self.cloneFromURLTextField.frame;
        cloneFromTextFieldFrame.size.width = attributedFrame.size.width;
        self.cloneFromURLTextField.frame = cloneFromTextFieldFrame;
        
        [self.clonetoURLTextField setStringValue:destinationURLString];
        attributedString = [self.clonetoURLTextField attributedStringValue];
        attributedFrame = [attributedString boundingRectWithSize:boundingSize options:NSStringDrawingUsesLineFragmentOrigin];
        NSRect clonetoTextFieldFrame = self.clonetoURLTextField.frame;
        clonetoTextFieldFrame.size.width = attributedFrame.size.width;
        self.clonetoURLTextField.frame = clonetoTextFieldFrame;
        
        if (cloneFromTextFieldFrame.size.width >= clonetoTextFieldFrame.size.width)
        {
            maxWidth = cloneFromTextFieldFrame.size.width;
        }
        else
        {
            maxWidth = clonetoTextFieldFrame.size.width;
        }
        
        if (maxWidth < STANDARD_MAX_WIDTH)
        {
            maxWidth = STANDARD_MAX_WIDTH;
        }
        
        frame = self.window.frame;
        frame.size.width = maxWidth + WINDOW_WIDTH_ADDITION;
        frame.size.height = self.cloneProgressView.frame.size.height;
        [self.window setFrame:frame display:YES];
        
        self.cloneProgressView.frame = frame;
        
        frame = self.cloneProgressIndicator.frame;
        frame.size.width = maxWidth;
        self.cloneProgressIndicator.frame = frame;

        self.window.contentView = cloneProgressView;
        
        [self.filesToCloneTextField setHidden:YES];
        [self.filesLeftTextField setHidden:NO];
        [self.filesLeftTextField setStringValue:@"Count Files at Source ..."];
        [self performSelectorInBackground:@selector(countSourceFiles) withObject:self];
        
        [self.cloneProgressIndicator setIndeterminate:YES];   
        [self.cloneProgressIndicator startAnimation:Nil];
    }

    [NSApp beginSheet:[self window] modalForWindow:[controller window] modalDelegate:self didEndSelector:nil contextInfo:nil];
    [self.window becomeKeyWindow];

	gitTask = [PBEasyPipe taskForCommand:[PBGitBinary path] withArgs:arguments inDir:dir];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskCompleted:) name:NSTaskDidTerminateNotification object:gitTask];
    
    NSMutableDictionary *argDict = [NSMutableDictionary new];
    [argDict setValue:repository forKey:[NSString stringWithFormat:@"Repository"]];
    
    for (int i=0; i<[arguments count]; i++)
    {
        [argDict setValue:[arguments objectAtIndex:i] forKey:[NSString stringWithFormat:@"Arg%d",i]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GitCommandSent" object:self userInfo:argDict];

	// having intermittent problem with long running git tasks not sending a termination notice, so periodically check whether the task is done
	taskTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(checkTask:) userInfo:nil repeats:YES];

	[gitTask launch];
}

- (void)countSourceFiles
{
    sourceFilesCount = [self filesCountAtURL:sourceURL withRepeatTimer:NO];

    if ([sourceFilesCount intValue] > 0)
    {
        [self.filesToCloneTextField setHidden:NO];
        [self.filesToCloneTextField setStringValue:[NSString stringWithFormat:@"Files to clone %@",sourceFilesCount]];
        [self updateFileStatus];

        [self.cloneProgressIndicator stopAnimation:Nil];
        [self.cloneProgressIndicator setIndeterminate:NO];
        [self.cloneProgressIndicator setMinValue:0.0];
        [self.cloneProgressIndicator setMaxValue:[sourceFilesCount doubleValue]];
        [self.cloneProgressIndicator setDoubleValue:0.0];
    }
    else
    {
        [self.filesLeftTextField setHidden:YES]; 
    }
}


#pragma mark Notifications

- (void) taskCompleted:(NSNotification *)notification
{
	[taskTimer invalidate];
    [fileStatusTimer invalidate];
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	[self.progressIndicator stopAnimation:Nil];
	[NSApp endSheet:[self window]];
	[[self window] orderOut:self];

	returnCode = [gitTask terminationStatus];
	if (returnCode)
		[self showErrorMessage];
	else
		[self showSuccessMessage];

	if ([controller respondsToSelector:@selector(repository)])
		[[(PBGitWindowController *)controller repository] reloadRefs];
}



#pragma mark taskTimer

- (void) checkTask:(NSTimer *)timer
{
	if (![gitTask isRunning]) {
		DLog(@"[%@ %@] gitTask terminated without notification", [self class], NSStringFromSelector(_cmd));
		[self taskCompleted:nil];
	}
}

- (void) updateFileStatusTimer:(NSTimer *)timer
{
    [self performSelectorInBackground:@selector(updateFileStatus) withObject:self];
}

- (void) updateFileStatus
{
    NSNumber *actDestinationFilesCount = [self filesCountAtURL:destinationURL withRepeatTimer:YES];
    [filesLeftTextField setStringValue:[NSString stringWithFormat:@"Files left %d", [sourceFilesCount intValue] - [actDestinationFilesCount intValue]]];
    [self.cloneProgressIndicator setDoubleValue:[actDestinationFilesCount doubleValue]];
}

#pragma mark Messages

- (void) showSuccessMessage
{
	NSMutableString *info = [NSMutableString string];
	[info appendString:[self successDescription]];
	[info appendString:[self commandDescription]];
	[info appendString:[self standardOutputDescription]];

    [(NSWindowController<Messages>*)controller showMessageSheet:[self successTitle] infoText:info];
}


- (void) showErrorMessage
{
	NSMutableString *info = [NSMutableString string];
	[info appendString:[self errorDescription]];
	[info appendString:[self commandDescription]];
	[info appendString:[self standardOutputDescription]];
	[info appendString:[self standardErrorDescription]];

	NSDictionary *errorUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
								   [self errorTitle], NSLocalizedDescriptionKey,
								   info, NSLocalizedRecoverySuggestionErrorKey,
								   nil];
	NSError *error = [NSError errorWithDomain:PBGitRepositoryErrorDomain code:0 userInfo:errorUserInfo];

    [(NSWindowController<Messages>*)controller showErrorSheet:error];
}



#pragma mark Display Strings

- (NSString *) progressTitle
{
	NSString *progress = description;
	if (!progress)
		progress = @"Operation in progress.";

	return progress;
}


- (NSString *) successTitle
{
	NSString *success = title;
	if (!success)
		success = @"Operation";

	return [success stringByAppendingString:@" completed."];
}


- (NSString *) successDescription
{
	NSString *info = description;
	if (!info)
		return @"";

	return [info stringByAppendingString:@" completed successfully.\n\n"];
}


- (NSString *) errorTitle
{
	NSString *error = title;
	if (!error)
		error = @"Operation";

	return [error stringByAppendingString:@" failed."];
}


- (NSString *) errorDescription
{
	NSString *info = description;
	if (!info)
		return @"";

	return [info stringByAppendingString:@" encountered an error.\n\n"];
}


- (NSString *) commandDescription
{
	if (!arguments || ([arguments count] == 0))
		return @"";

	return [NSString stringWithFormat:@"command: git %@", [arguments componentsJoinedByString:@" "]];
}


- (NSString *) standardOutputDescription
{
	if (!gitTask || [gitTask isRunning])
		return @"";

	NSData *data = [[[gitTask standardOutput] fileHandleForReading] readDataToEndOfFile];
	NSString *standardOutput = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

	if ([standardOutput isEqualToString:@""])
		return @"";

	return [NSString stringWithFormat:@"\n\n%@", standardOutput];
}


- (NSString *) standardErrorDescription
{
	if (!gitTask || [gitTask isRunning])
		return @"";

	NSData *data = [[[gitTask standardError] fileHandleForReading] readDataToEndOfFile];
	NSString *standardError = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

	if ([standardError isEqualToString:@""])
		return [NSString stringWithFormat:@"\nerror = %d", returnCode];

	return [NSString stringWithFormat:@"\n\n%@\nerror = %d", standardError, returnCode];
}


#pragma mark - Extension methods
- (NSNumber *) filesCountAtURL:(NSURL *)url withRepeatTimer:(BOOL)repeat
{
    int filesCount = 0;
    NSDirectoryEnumerator *dirEnumerator = [[NSFileManager defaultManager] enumeratorAtURL:url
                                                                includingPropertiesForKeys:Nil
                                                                                   options:NSDirectoryEnumerationSkipsPackageDescendants                                                     
                                                                              errorHandler:Nil];
    for (NSURL *theURL in dirEnumerator) 
    {
            filesCount++;
    }
    
    if (repeat)
    {
        [self performSelectorOnMainThread:@selector(startFilesCountTimer) withObject:self waitUntilDone:YES];
    }
    
    
    return [NSNumber numberWithInt:filesCount];    
}


- (void) startFilesCountTimer
{
    [fileStatusTimer invalidate];
    fileStatusTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_FILE_STATUS_INTERVAL 
                                                 target:self 
                                               selector:@selector(updateFileStatusTimer:) 
                                               userInfo:nil 
                                                repeats:NO];
}


@end
