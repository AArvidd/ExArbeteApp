//
//  UiController.h
//  ExArbete
//
//  Created by Arvid.Oscarsson on 2025-02-07.
//

#import <Foundation/Foundation.h>
#import "Cocoa/Cocoa.h"
#import "MetalSetupp.h"
#import "SaveWindow.h"

#ifndef UiController_h
#define UiController_h


#endif /* UiController_h */

@interface UIcontroller : NSObject{
    
}

- (id)init: (MetalSetupp*)metal;

- (void) creatWindow;

@property (readonly) MetalSetupp* metal;

@end
