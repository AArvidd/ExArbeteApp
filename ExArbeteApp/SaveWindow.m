//
//  SaveWindow.m
//  ExArbeteApp
//
//  Created by Arvid.Oscarsson on 2025-03-04.
//

#import "SaveWindow.h"



@implementation SaveWindow{
    
    NSTextField* widthFeld;
    NSTextField* heightFeld;
    NSTextField* URLFeld;
    
    NSSavePanel* save;
    
    MetalSetupp* Metal;
    
}

- (instancetype) init:(MetalSetupp*)metal {
    Metal = metal;
    
    save = [NSSavePanel savePanel];
    [save setDelegate:self];
    [save setPrompt:@"Select"];
    
    NSRect rect = NSMakeRect(200, 200, 500, 130);
    
    self = [super initWithContentRect:rect styleMask: NSWindowStyleMaskTitled | NSWindowStyleMaskClosable backing:NSBackingStoreBuffered defer:NO];
    
    [self setTitle:@"save image?"];
    
    [self setReleasedWhenClosed:NO];
    
    
    widthFeld  = [[NSTextField alloc] initWithFrame:NSMakeRect( 20, 70, 200, 22)];
    heightFeld = [[NSTextField alloc] initWithFrame:NSMakeRect(240, 70, 200, 22)];
    
    [[self contentView] addSubview:widthFeld];
    [[self contentView] addSubview:heightFeld];
    
    NSTextField* widthText  = [[NSTextField alloc] initWithFrame:NSMakeRect( 20, 100, 200, 22)];
    NSTextField* heightText = [[NSTextField alloc] initWithFrame:NSMakeRect(240, 100, 200, 22)];
    
    [widthText setStringValue:@"width"];
    [widthText setEditable:NO];
    [widthText setSelectable:NO];
    
    [heightText setStringValue:@"height"];
    [heightText setEditable:NO];
    [heightText setSelectable:NO];
    
    [[self contentView] addSubview:widthText];
    [[self contentView] addSubview:heightText];
    
    URLFeld = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 40, 320, 22)];
    [URLFeld setEditable:NO];
    [URLFeld setSelectable:NO];
    [URLFeld setStringValue:[[[[save URL] absoluteString] substringFromIndex:7] stringByAppendingString:@".png"]];
    
    [[self contentView] addSubview:URLFeld];
    
    NSButton* URLButton = [[NSButton alloc] initWithFrame:NSMakeRect(345, 40, 100, 22)];
    [URLButton setTitle:@"Select File"];
    [URLButton setAction:@selector(URLPress)];
    [URLButton setTarget:self];
    
    [[self contentView] addSubview:URLButton];
    
    
    NSButton* saveButton = [[NSButton alloc] initWithFrame:NSMakeRect(345, 10, 100, 22)];
    [saveButton setTitle:@"Save Image"];
    [saveButton setAction:@selector(savePress)];
    [saveButton setTarget:self];
    
    [[self contentView] addSubview:saveButton];
    
    [self makeKeyAndOrderFront:self];
    return self;
}

- (void) URLPress{
    [save runModal];
}

- (void) savePress{
    
    int width = (int)[widthFeld.stringValue integerValue];
    int height = (int)[heightFeld.stringValue integerValue];
    
    if(width <= 0 || height <= 0){
        // write allert
        NSAlert* alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Not valid input"];
        [alert setInformativeText:@"One of the inputs is invalid"];
        [alert runModal];
        return;
    }
    
    Metal.pWidth = width;
    Metal.pHeight = height;
    
    [Metal uppdateData];
    [Metal SendComputeCommand];
    [Metal saveImage:[URLFeld stringValue]];
    
    Metal.pWidth = 1000;
    Metal.pHeight = 1000;
    
    [self close];
    
}

- (NSString*) panel:(id)sender userEnteredFilename:(NSString *)filename confirmed:(BOOL)okFlag{
    NSString* URLString = [[[save URL] absoluteString] stringByAppendingString:@".png"];
    
    URLString = [URLString substringFromIndex:7];
    [URLFeld setStringValue:URLString];
    return filename;
}

@end
