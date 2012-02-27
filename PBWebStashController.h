//
//  PBWebStashController.h
//
//  Created by David Catmull on 12-06-11.
//

#import <Cocoa/Cocoa.h>
#import "PBWebCommitController.h"

@class PBStashContentController;

@interface PBWebStashController : PBWebCommitController {
	__unsafe_unretained PBStashContentController *stashController;
}

@property(nonatomic, unsafe_unretained) IBOutlet PBStashContentController *stashController;

@end
