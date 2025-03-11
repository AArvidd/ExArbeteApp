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

@property (readwrite) NSTextField* XField;
@property (readwrite) NSTextField* YField;
@property (readwrite) NSTextField* WField;

- (void)rightPress;
- (void)leftPress;
- (void)uppPress;
- (void)downPress;
- (void)inPress;
- (void)outPress;
- (void)resetPress;
- (void)colorModePress;
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
    
    NSRect rect = NSMakeRect(100, 100, windowWidth, windowHeight);
    
    view = [[mainView alloc] initWithFrame:NSMakeRect(0, 0, windowWidth, windowHeight)];
    
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
    
    NSButton* colorButton  = [[NSButton alloc] initWithFrame:NSMakeRect(buttonWidth * 3.5,  windowHeight - 40, buttonWidth * 2, buttonHeight)];
    [colorButton setTitle:@"Switch color mode"];
    [colorButton setAction:@selector(colorModePress)];
    
    NSButton* saveButton   = [[NSButton alloc] initWithFrame:NSMakeRect(windowWidth - buttonWidth - 10, windowHeight - 40, buttonWidth, buttonHeight)];
    [saveButton setTitle:@"save image"];
    [saveButton setAction:@selector(saveImagePress)];
    
    
    NSTextField* XField = [[NSTextField alloc] initWithFrame:NSMakeRect(10, 40, 200, 22)];
    NSTextField* YField = [[NSTextField alloc] initWithFrame:NSMakeRect(10, 10, 200, 22)];
    NSTextField* WField = [[NSTextField alloc] initWithFrame:NSMakeRect(10, 70, 200, 22)];
    [XField setEditable:NO];
    [YField setEditable:NO];
    [WField setEditable:NO];
    [XField setSelectable:YES];
    
    [XField setStringValue:[NSString stringWithFormat:@"X: %.15f", (float)_metal.FPX / FIXED_POINT_BASE]];
    [YField setStringValue:[NSString stringWithFormat:@"Y: %.15f", (float)_metal.FPY / FIXED_POINT_BASE]];
    [WField setStringValue:[NSString stringWithFormat:@"Width: %.15f", (float)_metal.FPwidth / FIXED_POINT_BASE]];
    
    view.XField = XField;
    view.YField = YField;
    view.WField = WField;
    
    
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
    [view addSubview:colorButton];
    [view addSubview:saveButton];
    
    [view addSubview:XField];
    [view addSubview:YField];
    [view addSubview:WField];
    
    [window setDelegate:view];
    [window makeKeyAndOrderFront:nil];
    
    [NSApp run];
    
}

@end



@implementation mainView

- (void) rightPress{
    _metal.FPX += _metal.FPwidth / 4;
    [self uppdateImage];
}

- (void) leftPress{
    _metal.FPX -= _metal.FPwidth / 4;
    [self uppdateImage];
}

- (void) uppPress{
    _metal.FPY += _metal.FPwidth / 4;
    [self uppdateImage];
}

- (void) downPress{
    _metal.FPY -= _metal.FPwidth / 4;
    [self uppdateImage];
}

- (void) inPress{
    if(_metal.FPwidth == 0x400){
        return;
    }
    _metal.FPwidth /= 2;
    [self uppdateImage];
}

- (void) outPress{
    if(_metal.FPwidth == 0x40000000){
        return;
    }
    _metal.FPwidth *= 2;
    [self uppdateImage];
}

- (void) resetPress{
    _metal.FPX = 0;
    _metal.FPY = 0;
    _metal.FPwidth = 2 << NUM_FRAC_BITS;
    [self uppdateImage];
}

- (void) colorModePress{
    _metal.colorMode++;
    if(_metal.colorMode == 2){
        _metal.colorMode = 0;
    }
    [self uppdateImage];
}


- (void) uppdateImage{
    [_metal uppdateData];
    [_metal SendComputeCommand];
    [_imageView setImage:_metal.nsImage];
    [_XField setStringValue:[NSString stringWithFormat:@"X: %.15f", (float)_metal.FPX / FIXED_POINT_BASE]];
    [_YField setStringValue:[NSString stringWithFormat:@"Y: %.15f", (float)_metal.FPY / FIXED_POINT_BASE]];
    [_WField setStringValue:[NSString stringWithFormat:@"Width: %.15f", (float)_metal.FPwidth / FIXED_POINT_BASE]];
}

- (void) saveImagePress{
    [[SaveWindow alloc] init:_metal];
}

- (void)windowWillClose:(NSNotification *)notification{
    [NSApp terminate:self];
}

@end
