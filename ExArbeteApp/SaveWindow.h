//
//  SaveWindow.h
//  ExArbeteApp
//
//  Created by Arvid.Oscarsson on 2025-03-04.
//

#import "Cocoa/Cocoa.h"
#import <Foundation/Foundation.h>
#import "MetalSetupp.h"

@interface SaveWindow : NSWindow <NSOpenSavePanelDelegate>

- (instancetype) init:(MetalSetupp*)metal;

- (void) savePress;
- (void) URLPress;

@end
