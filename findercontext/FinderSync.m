//
//  FinderSync.m
//  findercontext
//
//  Created by Ryan Bowring on 12/24/17.
//  Copyright © 2017 SevenBits. All rights reserved.
//

#import "FinderSync.h"

@interface FinderSync ()

@property NSURL *myFolderURL;

@end

@implementation FinderSync

- (instancetype)init {
    self = [super init];

    NSLog(@"%s launched from %@ ; compiled at %s", __PRETTY_FUNCTION__, [[NSBundle mainBundle] bundlePath], __TIME__);

    // Set up the directory we are syncing.
    self.myFolderURL = [NSURL fileURLWithPath:@"/"];
    FIFinderSyncController.defaultController.directoryURLs = [NSSet setWithObject:self.myFolderURL];
    
    return self;
}

#pragma mark - Primary Finder Sync protocol methods

- (void)beginObservingDirectoryAtURL:(NSURL *)url {
    // The user is now seeing the container's contents.
    // If they see it in more than one view at a time, we're only told once.
    NSLog(@"beginObservingDirectoryAtURL:%@", url.filePathURL);
}


- (void)endObservingDirectoryAtURL:(NSURL *)url {
    // The user is no longer seeing the container's contents.
    NSLog(@"endObservingDirectoryAtURL:%@", url.filePathURL);
}

#pragma mark - Menu item

- (NSMenu *)menuForMenuKind:(FIMenuKind)whichMenu {
    // Produce a menu for the extension.
	NSArray<NSURL *> *paths = FIFinderSyncController.defaultController.selectedItemURLs;
	NSString *ext = paths[0].pathExtension;
	NSMenu *menu = [[NSMenu alloc] initWithTitle:@""];
	
	if (whichMenu == FIMenuKindContextualMenuForItems && [ext isEqualToString:@"iso"]) {
    	[menu addItemWithTitle:@"Open in Mac Linux USB Loader" action:@selector(openInUSBLoader:) keyEquivalent:@""];
	}
	
	return menu;
}

- (IBAction)openInUSBLoader:(id)sender {
    NSArray* items = [[FIFinderSyncController defaultController] selectedItemURLs];

    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSString *path = [obj filePathURL].path;
		NSLog(@"Opening file: %@", path);
		if ([path.pathExtension isEqualToString:@"iso"]) {
			BOOL result = [NSWorkspace.sharedWorkspace launchApplication:@"Mac Linux USB Loader"];
			NSLog(@"Result: %s", result ? "yes" : "no");
			result = [NSWorkspace.sharedWorkspace openFile:path withApplication:@"Mac Linux USB Loader"];
			NSLog(@"Result: %s", result ? "yes" : "no");
		}
    }];
}

@end

