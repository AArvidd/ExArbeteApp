//
//  MetalSetupp.h
//  ExArbeteMVP
//
//  Created by Arvid.Oscarsson on 2024-11-28.
//

#import <Foundation/Foundation.h>
#import "Metal/Metal.h"
#import "CoreGraphics/CoreGraphics.h"
#import "CoreServices/CoreServices.h"
#import "ImageIO/ImageIO.h"
#import "Cocoa/Cocoa.h"

#define FIXED_POINT_BASE 0x10000000
#define NUM_FRAC_BITS 28


NS_ASSUME_NONNULL_BEGIN

@interface MetalSetupp : NSObject
- (instancetype) initWithDevice: (id<MTLDevice>) device;
- (void) prepareData;
- (void) SendComputeCommand;
- (void) prepareImage;
- (void) saveImage: (NSString*) filePath;
- (void) uppdateData;

@property (readonly) NSImage* nsImage;

@property (readwrite) int FPX;
@property (readwrite) int FPY;
@property (readwrite) int FPwidth;

@property (readwrite) unsigned int pWidth;
@property (readwrite) unsigned int pHeight;
@property (readwrite) unsigned int colorMode;

@end

NS_ASSUME_NONNULL_END
