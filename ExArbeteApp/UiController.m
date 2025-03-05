//
//  UiController.m
//  ExArbeteMVP
//
//  Created by Arvid.Oscarsson on 2025-02-07.
//

#import "UiController.h"

@interface mainView : NSView

@property (readwrite) MetalSetupp* metal;
@property (readwrite) NSImageView* imageView;

- (void)rightPress;
- (void)leftPress;
- (void)uppPress;
- (void)downPress;
- (void)inPress;
- (void)outPress;
- (void)resetPress;
- (void)saveImagePress;

@end


@implementation UIcontroller


- (id) init:(MetalSetupp*)metal{
    
    _metal = metal;
    
    return self;
}


- (void) creatWindow{
    
    int windowWidth = 700;
    int windowHeight = 700;
    
    NSApp = [NSApplication sharedApplication];
    [NSApp activateIgnoringOtherApps:YES];
    
    NSWindow* window;
    mainView* view;
    
//    NSRect rect = NSMakeRect(100, 100, gPWidth, gPHeight);
    NSRect rect = NSMakeRect(100, 100, windowWidth, windowHeight);
    
    view = [[mainView alloc] initWithFrame:rect];
    
    view.metal = _metal;
    
    int buttonWidth = 60;
    int buttonHeight = 40;

    NSButton* rightButton = [[NSButton alloc] initWithFrame:NSMakeRect(buttonWidth * 1.5,   windowHeight - 70, buttonWidth, buttonHeight)];
    [rightButton setTitle:@"right"];
    [rightButton setAction:@selector(rightPress)];
    
    NSButton* leftButton  = [[NSButton alloc] initWithFrame:NSMakeRect(10,                  windowHeight - 70, buttonWidth, buttonHeight)];
    [leftButton setTitle:@"left"];
    [leftButton setAction:@selector(leftPress)];
    
    NSButton* uppButton   = [[NSButton alloc] initWithFrame:NSMakeRect(buttonWidth * 0.85,  windowHeight - 40, buttonWidth, buttonHeight)];
    [uppButton setTitle:@"upp"];
    [uppButton setAction:@selector(uppPress)];
    
    NSButton* downButton  = [[NSButton alloc] initWithFrame:NSMakeRect(buttonWidth * 0.85,  windowHeight - buttonHeight - 60, buttonWidth, buttonHeight)];
    [downButton setTitle:@"down"];
    [downButton setAction:@selector(downPress)];
    
    NSButton* inButton    = [[NSButton alloc] initWithFrame:NSMakeRect(buttonWidth * 2.5,   windowHeight - 40, buttonWidth, buttonHeight)];
    [inButton setTitle:@"in"];
    [inButton setAction:@selector(inPress)];
    
    NSButton* outButton   = [[NSButton alloc] initWithFrame:NSMakeRect(buttonWidth * 2.5,   windowHeight - 70, buttonWidth, buttonHeight)];
    [outButton setTitle:@"out"];
    [outButton setAction:@selector(outPress)];
    
    NSButton* resetButton  = [[NSButton alloc] initWithFrame:NSMakeRect(buttonWidth * 2.5,  windowHeight - 100, buttonWidth, buttonHeight)];
    [resetButton setTitle:@"reset"];
    [resetButton setAction:@selector(resetPress)];
    
    NSButton* saveButton   = [[NSButton alloc] initWithFrame:NSMakeRect(windowWidth - buttonWidth - 10, windowHeight - 40, buttonWidth, buttonHeight)];
    [saveButton setTitle:@"save image"];
    [saveButton setAction:@selector(saveImagePress)];
    
    
    
    NSImageView* imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, windowWidth, windowHeight)];
    [imageView setImageScaling:NSScaleToFit];
    [imageView setImage:_metal.nsImage];
    
    view.imageView = imageView;
    
    window =[[NSWindow alloc]
             initWithContentRect:rect
             styleMask:
                NSWindowStyleMaskTitled |
                NSWindowStyleMaskClosable |
                NSWindowStyleMaskMiniaturizable
             backing:NSBackingStoreBuffered defer:NO];
    
    [window setTitle:@"Mandelbrot viewer"];
    
    [window setContentView:view];
    
    [view addSubview:imageView];
    [view addSubview:rightButton];
    [view addSubview:leftButton];
    [view addSubview:uppButton];
    [view addSubview:downButton];
    [view addSubview:inButton];
    [view addSubview:outButton];
    [view addSubview:resetButton];
    [view addSubview:saveButton];
    
    [window setDelegate:view];
    [window makeKeyAndOrderFront:nil];
    
    [NSApp run];
    
}

@end



@implementation mainView

- (void) rightPress{
    _metal.X += _metal.width / 4;
    [self uppdateImage];
}

- (void) leftPress{
    _metal.X -= _metal.width / 4;
    [self uppdateImage];
}

- (void) uppPress{
    _metal.Y += _metal.width / 4;
    [self uppdateImage];
}

- (void) downPress{
    _metal.Y -= _metal.width / 4;
    [self uppdateImage];
}

- (void) inPress{
    _metal.width /= 2;
    [self uppdateImage];
}

- (void) outPress{
    _metal.width *= 2;
    [self uppdateImage];
}

- (void) resetPress{
    _metal.X = 0;
    _metal.Y = 0;
    _metal.width = 2;
    [self uppdateImage];
}


- (void) uppdateImage{
    [_metal uppdateData];
    [_metal SendComputeCommand];
    [_imageView setImage:_metal.nsImage];
}

- (void) saveImagePress{
    
    [[SaveWindow alloc] init:_metal];
    
//    [_metal saveImage];
}

- (void)windowWillClose:(NSNotification *)notification{
    [NSApp terminate:self];
}

@end
