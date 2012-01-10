//
//  PBGitXMessageSheet.h
//  GitX
//
//  Created by BrotherBard on 7/4/10.
//  Copyright 2010 BrotherBard. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PBGitXMessageSheet : NSWindowController
{
	NSImageView *iconView;
	NSTextField *messageField;
	NSTextView *infoView;
	NSScrollView *scrollView;
}

+ (void)beginMessageSheetForWindow:(NSWindow *)parentWindow withMessageText:(NSString *)message infoText:(NSString *)info;
+ (void)beginMessageSheetForWindow:(NSWindow *)parentWindow withError:(NSError *)error;


- (void)beginMessageSheetForWindow:(NSWindow *)parentWindow withMessageText:(NSString *)message infoText:(NSString *)info;
- (IBAction)closeMessageSheet:(id)sender;


@property (strong) IBOutlet NSImageView *iconView;
@property (strong) IBOutlet NSTextField *messageField;
@property (strong) IBOutlet NSTextView *infoView;
@property (strong) IBOutlet NSScrollView *scrollView;

@end
